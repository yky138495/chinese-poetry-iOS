//
//  FileDownloader.h
//  MQAI
//
//  Created by ymg on 15/3/11.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloadRequest.h"


@interface FileDownloader : NSObject

// 单例
+ (FileDownloader *)sharedInstance;

// 文件下载超时时间
@property (nonatomic, assign) NSTimeInterval timeout;

- (void)downloadFileWithURL:(NSURL *)url
            completionBlock:(FileDownloadCompletionBlock)completionBlock;

- (void)downloadFileWithURL:(NSURL *)url
                   useCache:(BOOL)useCache
            completionBlock:(FileDownloadCompletionBlock)completionBlock;

- (void)downloadFileWithURL:(NSURL *)url
                   useCache:(BOOL)useCache
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock;

- (void)downloadFileWithURL:(NSURL *)url
                   priority:(NSOperationQueuePriority)priority
                   useCache:(BOOL)useCache
                allowResume:(BOOL)allowResume
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock;

// 取消下载
- (void)cancelDownloadFileWithURL:(NSURL *)url;

@end
