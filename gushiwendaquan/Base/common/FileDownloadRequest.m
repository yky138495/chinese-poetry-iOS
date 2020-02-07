//
//  FileDownloadRequest.m
//  MQAI
//
//  Created by ymg on 15/3/15.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "FileDownloadRequest.h"
#import <Mantle/MTLEXTScope.h>
#import <Mantle/MTLEXTKeyPathCoding.h>
#import <CocoaSecurity/CocoaSecurity.h>
#import "CFileHandle.h"

void * const FileDownloadRequestOperationContext = @"FileDownloadRequestOperationContext";


// 文件缓存目录 Library/Caches/Download
static NSString *fileCacheDirectory()
{
    static NSString *_fileCacheDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _fileCacheDirectory = [cacheDirectory stringByAppendingString:@"/FileDownload/"];
        [CFileHandle createDirectoryAtPath:_fileCacheDirectory];
    });
    return _fileCacheDirectory;
}

// 文件临时目录 tmp/FileDownload
static NSString *fileDownloaderDirectory()
{
    static NSString *_fileDownloadDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tempDirectory = NSTemporaryDirectory();
        _fileDownloadDirectory = [tempDirectory stringByAppendingString:@"FileDownload/"];
        [CFileHandle createDirectoryAtPath:_fileDownloadDirectory];
    });
    return _fileDownloadDirectory;
}


@interface FileDownloadRequest ()

@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, assign, readwrite) NSTimeInterval timeout;
@property (nonatomic, strong, readwrite) AFHTTPRequestOperation *operation;

@property (nonatomic, assign) BOOL useCache;
@property (nonatomic, assign) BOOL allowResume;
@property (nonatomic, copy) NSString *fileCachePath;
@property (nonatomic, copy) NSString *fileDownloadPath;

- (void)fetchItemFromCacheForURL:(NSURL*)url
                   progressBlock:(FileDownloadProgressBlock)progressBlock
                 completionBlock:(FileDownloadCompletionBlock_)completionBlock;

+ (AFHTTPRequestOperation *)operationWithURLRequest:(NSURLRequest *)urlRequest
                                   fileDownloadPath:(NSString *)fileDownloadPath;

+ (NSURLRequest *)urlRequestWithURL:(NSURL *)url
                            timeout:(NSTimeInterval)timeout
                        allowResume:(BOOL)allowResume
                   fileDownloadPath:(NSString *)fileDownloadPath;

+ (BOOL)hasCacheForURL:(NSURL *)url;
+ (NSString *)cachePathForURL:(NSURL *)url;
+ (NSString *)downloadPathForURL:(NSURL *)url;

@end


@implementation FileDownloadRequest

+ (FileDownloadRequest *)downloadRequestWithURL:(NSURL *)url
                                        timeout:(NSTimeInterval)timeout
                                       priority:(NSOperationQueuePriority)priority
                                       useCache:(BOOL)useCache
                                    allowResume:(BOOL)allowResume
                                  progressBlock:(FileDownloadProgressBlock)progresBlock
                                completionBlock:(FileDownloadCompletionBlock_)completionBlock
{
    FileDownloadRequest *request = [FileDownloadRequest new];
    
    request.url = url;
    request.timeout = timeout;
    request.useCache = useCache;
    request.allowResume = allowResume;
    request.fileCachePath = [self cachePathForURL:url];
    request.fileDownloadPath = [self downloadPathForURL:url];
    
    // 使用缓存文件
    if (useCache && [self hasCacheForURL:url]) {
        [request fetchItemFromCacheForURL:url
                            progressBlock:progresBlock
                          completionBlock:completionBlock];
        return nil;
    }
    
    // 重新下载文件
    NSURLRequest *urlRequest = [self urlRequestWithURL:url
                                               timeout:timeout
                                           allowResume:allowResume
                                      fileDownloadPath:request.fileDownloadPath];
    request.operation = [self operationWithURLRequest:urlRequest fileDownloadPath:request.fileDownloadPath];
    request.operation.queuePriority = priority;
    // KVO
    [request.operation addObserver:request
                        forKeyPath:@keypath2(request.operation, isExecuting)
                           options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                           context:FileDownloadRequestOperationContext];
    
    //
    @weakify(request);
    //
    [request.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        @strongify(request);
        CGFloat progress;
        if (totalBytesExpectedToRead == -1) {
            progress = -32;
        } else {
            progress = (CGFloat)totalBytesRead / (CGFloat)totalBytesExpectedToRead;
        }
        progresBlock(request.url, progress);
    }];
    
    //
    [request.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(request);
        if (request.useCache) {
            [CFileHandle removeFileAtPath:request.fileCachePath];
            [CFileHandle moveItemAtPath:request.fileDownloadPath toPath:request.fileCachePath];
            completionBlock(request.url, [NSURL fileURLWithPath:request.fileCachePath], NO, nil);
        } else {
            completionBlock(request.url, [NSURL fileURLWithPath:request.fileDownloadPath], NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(request);
        completionBlock(request.url, nil, NO, error);
    }];
    
    return request;
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != FileDownloadRequestOperationContext) {
        if ([[self superclass] instancesRespondToSelector:_cmd]) {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        return;
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isExecuting))]) {
        if ([object isKindOfClass:[NSOperation class]]) {
            NSOperation *operation = (NSOperation *)object;
            if (operation.isExecuting) {
                if (!self.allowResume) {
                    // 下载开始前删除临时文件
                    [CFileHandle removeFileAtPath:self.fileDownloadPath];
                }
                [operation removeObserver:self
                                 forKeyPath:@keypath2(operation, isExecuting)
                                    context:FileDownloadRequestOperationContext];
            }
        }
    }
}

// 直接使用缓存文件
- (void)fetchItemFromCacheForURL:(NSURL*)url
                   progressBlock:(FileDownloadProgressBlock)progressBlock
                 completionBlock:(FileDownloadCompletionBlock_)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fileCachePath = self.fileCachePath;
        // self.data = [CFileHandle readDataFromPath:fileCachePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            progressBlock(url, 1.f);
            completionBlock(url, [NSURL fileURLWithPath:fileCachePath], YES, nil);
        });
    });
}

// 创建下载操作
+ (AFHTTPRequestOperation *)operationWithURLRequest:(NSURLRequest *)urlRequest
                                   fileDownloadPath:(NSString *)fileDownloadPath
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:fileDownloadPath append:YES];
    return operation;
}

// 创建URLRequest
+ (NSURLRequest *)urlRequestWithURL:(NSURL *)url
                            timeout:(NSTimeInterval)timeout
                        allowResume:(BOOL)allowResume
                   fileDownloadPath:(NSString *)fileDownloadPath;
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:timeout];
    //
    // 允许断点续传（需要服务器支持）
    //
    if (allowResume) {
        // 检查已下载部分的字节
        unsigned long long downloadedBytes = 0;
        if ([CFileHandle containFileAtPath:fileDownloadPath]) {
            downloadedBytes = [CFileHandle getFileSize:fileDownloadPath];
            if (downloadedBytes) {
                NSMutableURLRequest *mutableURLRequest = [urlRequest mutableCopy];
                NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                
                urlRequest = mutableURLRequest;
            }
        }
    } else {
        // 删除临时文件
        [CFileHandle removeFileAtPath:fileDownloadPath];
    }
    
    // 不使用HTTP缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:urlRequest];
    
    return urlRequest;
}

// 是否存在缓存文件
+ (BOOL)hasCacheForURL:(NSURL *)url
{
    NSString *fileCachePath = [self cachePathForURL:url];
    return [CFileHandle containFileAtPath:fileCachePath];
}

// 缓存路径
+ (NSString *)cachePathForURL:(NSURL *)url
{
    NSString *fileName = [[[CocoaSecurity md5:[url absoluteString]] hexLower]stringByAppendingString:@".txt"];
    return [fileCacheDirectory() stringByAppendingString:fileName];
}

// 下载路径
+ (NSString *)downloadPathForURL:(NSURL *)url
{
    NSString *fileName = [[[CocoaSecurity md5:[url absoluteString]] hexLower]stringByAppendingString:@".txt"];
    return [fileDownloaderDirectory() stringByAppendingString:fileName];
}

@end
