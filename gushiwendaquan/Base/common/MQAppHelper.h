//
//  MQAppHelper.h
//  MQAI
//
//  Created by ymg on 14/12/16.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQMacros.h"
#import "MQError.h"

//
// 应用扩展协议
//
@protocol MQAppExtensionProtocol <NSObject>

@optional
- (UIViewController *)topViewController;
- (void)handleFrozenAccount:(MQError *)error;

@end


//
// 应用助手类
//
@interface MQAppHelper : NSObject

DEF_SINGLETON(MQAppHelper);

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) BOOL deviceTokenBinded;

- (CGAffineTransform)transformForOrientation;
+ (NSString *)bundleSeedID;

@end


// 应用基本信息
@interface MQAppHelper (AppInfo)

- (NSString *)appName;
- (NSString *)appBundleName;
- (NSString *)appBundleID;
- (NSString *)appVersion;
- (NSString *)appFullVersion;

@end

// 首次启动判断
@interface MQAppHelper (Launch)

- (BOOL)isFirstLaunch;
- (BOOL)isEverLaunched;
- (void)setFirstLaunch:(BOOL)firstLaunch;
- (void)setEverLaunched:(BOOL)everLaunched;

@end


// Controller相关
@interface MQAppHelper (ViewController)

/** 获取当前展示Controller */
- (UIViewController *)topViewController;
- (UIViewController *)topViewController:(UIViewController *)rootViewController;

@end

