//
//  FileDownloadRequest.h
//  MQAI
//
//  Created by ymg on 15/3/15.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void (^FileDownloadProgressBlock)(NSURL *url, CGFloat progress);
typedef void (^FileDownloadCompletionBlock)(NSURL *url, NSURL *filePath, NSError *error);
typedef void (^FileDownloadCompletionBlock_)(NSURL *url, NSURL *filePath, BOOL hitCache, NSError *error);

//
// 文件下载请求
//
@interface FileDownloadRequest : NSObject

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, readonly) NSTimeInterval timeout;
@property (nonatomic, strong, readonly) AFHTTPRequestOperation *operation;

+ (FileDownloadRequest *)downloadRequestWithURL:(NSURL *)url
                                        timeout:(NSTimeInterval)timeout
                                       priority:(NSOperationQueuePriority)priority
                                       useCache:(BOOL)useCache
                                    allowResume:(BOOL)allowResume
                                progressBlock:(FileDownloadProgressBlock)progresBlock
                              completionBlock:(FileDownloadCompletionBlock_)completionBlock;

@end

