//
//  RSFYJPushManager.m
//  RSFYKeep
//
//  Created by yangmengge on 2018/6/7.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "RSFYJPushManager.h"
#import "JPUSHService.h"

static NSInteger bandRequestCount;
static NSInteger unBandRequestCount;

@implementation RSFYJPushManager

// 绑定极光
+ (void)bandJPush
{
    bandRequestCount = 5;
    [self doBand];
}

+ (void)doBand
{
    [JPUSHService setAlias:@"" callbackSelector:@selector(bandJPushCallBack:tags:alias:) object:self];
}

+ (void)bandJPushCallBack:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    bandRequestCount--;
    NSLog(@"band rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if (bandRequestCount > 0) {
        if (iResCode == 0) {
            // 绑定成功
            bandRequestCount = 0;
        } else if (iResCode == 6002) {
            // 设置超时
            [self doBand];
        } else {
            // 设置失败，不再处理
        }
    }
}


// 极光解绑
+ (void)unbandJPush
{
    unBandRequestCount = 5;
    [self doUnband];
}

+ (void)doUnband
{
    [JPUSHService setAlias:@"" callbackSelector:@selector(unbandJPushCallBack:tags:alias:) object:self];
}

+ (void)unbandJPushCallBack:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"unband rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if (unBandRequestCount > 0) {
        if (iResCode == 0) {
            // 解绑成功
            unBandRequestCount = 0;
        } else if (iResCode == 6002) {
            // 设置超时
            [self doUnband];
        } else {
            // 设置失败，不再处理
        }
    }
    unBandRequestCount--;
}

@end
