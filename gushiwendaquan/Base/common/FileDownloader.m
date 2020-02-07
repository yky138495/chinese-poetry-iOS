//
//  FileDownloader.m
//  MQAI
//
//  Created by ymg on 15/3/11.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "FileDownloader.h"


// 超时时间
#define FILE_DOWNLOADER_TIMEOUT 10.f
// 最大并发数
#define FILE_DOWNLOADER_MAX_CONCURRENT 3



@interface FileDownloader ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *requestQueue;
@property (nonatomic, strong) NSMutableDictionary *waitingQueue;

- (void)startFileDownloadRequest:(FileDownloadRequest *)request withURL:(NSURL *)url;
- (void)finishFileDownloadWithURL:(NSURL *)url;
- (BOOL)isDownloadingFileWithURL:(NSURL *)url;

@end


@implementation FileDownloader

+ (FileDownloader *)sharedInstance
{
    static dispatch_once_t once;
    static FileDownloader * __singleton__;
    dispatch_once(&once, ^{ __singleton__ = [[FileDownloader alloc] init]; });
    return __singleton__;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
        self.operationQueue.maxConcurrentOperationCount = FILE_DOWNLOADER_MAX_CONCURRENT;
        self.requestQueue = [NSMutableDictionary dictionary];
        self.waitingQueue = [NSMutableDictionary dictionary];
        self.timeout = FILE_DOWNLOADER_TIMEOUT;
    }
    return self;
}

- (void)downloadFileWithURL:(NSURL *)url
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    [self downloadFileWithURL:url
                     useCache:YES
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                   useCache:(BOOL)useCache
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    [self downloadFileWithURL:url
                     useCache:useCache
                progressBlock:NULL
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                   useCache:(BOOL)useCache
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    [self downloadFileWithURL:url
                     priority:NSOperationQueuePriorityNormal
                     useCache:useCache
                  allowResume:NO
                progressBlock:progresBlock
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                   priority:(NSOperationQueuePriority)priority
                   useCache:(BOOL)useCache
                allowResume:(BOOL)allowResume
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    FileDownloadRequest *request = [FileDownloadRequest downloadRequestWithURL:url
                                                                       timeout:self.timeout
                                                                      priority:priority
                                                                      useCache:useCache
                                                                   allowResume:allowResume
                                                                 progressBlock:^(NSURL *url, CGFloat progress) {
                                                                     if (progresBlock) {
                                                                         progresBlock(url, progress);
                                                                     }
                                                                 } completionBlock:^(NSURL *url, NSURL *filePath, BOOL hitCache, NSError *error) {
                                                                     if (completionBlock) {
                                                                         completionBlock(url, filePath, error);
                                                                     }
                                                                     if (!hitCache) {
                                                                         [self finishFileDownloadWithURL:url];
                                                                     }
                                                                 }];
    if (request) {
        // 相同文件的下载请求需排队
        if ([self isDownloadingFileWithURL:url]) {
            NSMutableArray *queue = self.waitingQueue[url];
            if (!queue) {
                queue = [NSMutableArray array];
                self.waitingQueue[url] = queue;
            }
            [queue addObject:request];
        } else {
            [self startFileDownloadRequest:request withURL:url];
        }
    }
}

- (void)startFileDownloadRequest:(FileDownloadRequest *)request withURL:(NSURL *)url
{
    if (!url) {
        return;
    }
    [self.requestQueue safeSetObject:request forKey:url];
    if (request.operation) {
        [self.operationQueue addOperation:request.operation];
    }
}

- (void)finishFileDownloadWithURL:(NSURL *)url
{
    [self.requestQueue removeObjectForKey:url];
    //
    NSMutableArray *queue = self.waitingQueue[url];
    if ([queue count]) {
        FileDownloadRequest *nextRequest = [queue firstObject];
        [queue removeObjectAtIndex:0];
        if (![queue count]) {
            [self.waitingQueue removeObjectForKey:url];
        }
        [self startFileDownloadRequest:nextRequest withURL:url];
    }
}

- (void)cancelDownloadFileWithURL:(NSURL *)url
{
    FileDownloadRequest *request = self.requestQueue[url];
    if (request) {
        [request.operation cancel];
    }
}

- (BOOL)isDownloadingFileWithURL:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    return ([self.requestQueue objectForKey:url]? YES : NO);
}

@end
