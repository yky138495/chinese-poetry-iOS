//
//  MQCacheService.m
//  MQAI
//
//  Created by ymg on 15/3/30.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQCacheService.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "CFileHandle.h"


@interface MQCacheService ()

@property (nonatomic, copy, readwrite) NSString *imageCacheDirectory;
@property (nonatomic, copy, readwrite) NSString *splashCacheDirectory;
@property (nonatomic, copy, readwrite) NSString *configsCacheDirectory;
@property (nonatomic, copy, readwrite) NSString *noticeCacheDirectory;

@end


@implementation MQCacheService

IMP_SINGLETON(MQCacheService);

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)isImageCached:(NSURL *)url
{
    NSString *imagePath = [self cachePathForImageURL:url];
    return [CFileHandle containFileAtPath:imagePath];
}

- (BOOL)cleanCacheForImageURL:(NSURL *)url
{
    if ([self isImageCached:url]) {
        return [CFileHandle removeFileAtPath:[self cachePathForImageURL:url]];
    }
    return YES;
}

- (NSString *)cachePathForImageURL:(NSURL *)url
{
    if (!url) {
        return nil;
    }
    
    NSString *imageName = [self imageNameWithURL:url];
    if (imageName) {
        return [[self imageCacheDirectory] stringByAppendingPathComponent:imageName];
    }
    
    return nil;
}

- (NSString *)imageNameWithURL:(NSURL *)url
{
    if (url) {
        return [[CocoaSecurity md5:[url absoluteString]] hexLower];
    }
    return nil;
}

- (NSString *)imageCacheDirectory
{
    if (!_imageCacheDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _imageCacheDirectory = [cacheDirectory stringByAppendingString:@"/ImageCache/"];
        if (![CFileHandle isDirectory:_imageCacheDirectory]) {
            [CFileHandle createDirectoryAtPath:_imageCacheDirectory];
        }
    }
    return _imageCacheDirectory;
}

- (NSString *)splashCacheDirectory
{
    if (!_splashCacheDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _splashCacheDirectory = [cacheDirectory stringByAppendingString:@"/Splash/"];
        if (![CFileHandle isDirectory:_splashCacheDirectory]) {
            [CFileHandle createDirectoryAtPath:_splashCacheDirectory];
        }
    }
    return  _splashCacheDirectory;
}

- (NSString *)configsCacheDirectory
{
    if (!_configsCacheDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _configsCacheDirectory = [cacheDirectory stringByAppendingString:@"/Configs/"];
        if (![CFileHandle isDirectory:_configsCacheDirectory]) {
            [CFileHandle createDirectoryAtPath:_configsCacheDirectory];
        }
    }
    return  _configsCacheDirectory;
}

- (NSString *)noticeCacheDirectory
{
    if (!_noticeCacheDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _noticeCacheDirectory = [cacheDirectory stringByAppendingString:@"/Notice/"];
        if (![CFileHandle isDirectory:_noticeCacheDirectory]) {
            [CFileHandle createDirectoryAtPath:_noticeCacheDirectory];
        }
    }
    return  _noticeCacheDirectory;
}

@end
