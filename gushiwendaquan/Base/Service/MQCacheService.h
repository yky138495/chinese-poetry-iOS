//
//  MQCacheService.h
//  MQAI
//
//  Created by ymg on 15/3/30.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 * /Library/Caches/Splash       插屏数据缓存目录
 * /Library/Caches/ImageCache   图片文件缓存目录
 * /Library/Caches/Configs      环境配置文件缓存目录
 *
 */
@interface MQCacheService : NSObject

DEF_SINGLETON(MQCacheService);

@property (nonatomic, copy, readonly) NSString *imageCacheDirectory;
@property (nonatomic, copy, readonly) NSString *splashCacheDirectory;
@property (nonatomic, copy, readonly) NSString *configsCacheDirectory;
@property (nonatomic, copy, readonly) NSString *noticeCacheDirectory;


- (BOOL)isImageCached:(NSURL *)url;
- (BOOL)cleanCacheForImageURL:(NSURL *)url;
- (NSString *)imageNameWithURL:(NSURL *)url;
- (NSString *)cachePathForImageURL:(NSURL *)url;

@end
