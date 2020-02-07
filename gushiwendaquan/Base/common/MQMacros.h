//
//  MQMacros.h
//  MQAI
//
//  Created by ymg on 14/12/13.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#ifndef MQAI_MQMacros_h
#define MQAI_MQMacros_h

#import <math.h>
#import <Foundation/NSObjCRuntime.h>


//
// 很有用的宏定义
// 比如 @weakify 和 @strongify
//
#import <Mantle/MTLEXTScope.h>
#import <Mantle/MTLEXTKeyPathCoding.h>


//
// 未使用变量宏（去警告）
//
#define MQ_UNUSED(x) ((void)(x))


//
// 要求调用父类
//
#if __has_attribute(objc_requires_super)
#define MQ_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define MQ_REQUIRES_SUPER
#endif

//
// 标记废弃的属性
//
#if __has_attribute(deprecated)
#define MQ_DEPRECATED __attribute__((deprecated))
#else
#define MQ_DEPRECATED
#endif

//
// ARC下performSelector无法编译通过
//
#define MQ_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


//
//
// IOS设备检查宏
//
#define IS_OS_7_OR_EARLIER         ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.99)
#define IS_OS_7_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_OS_9_EARLIER            ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.99)
#define IS_OS_11_EARLIER           ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.99)
#define IS_OS_11_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)

#define IS_IPAD                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5                (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) &&  ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6       (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_STANDARD_IPHONE_X  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)
#define IS_ZOOMED_IPHONE_6_PLUS    (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

// 屏幕宽高度宏（不受设备转向影响）
//#define SCREEN_WIDTH        (IS_OS_8_OR_LATER?[[UIScreen mainScreen] nativeBounds].size.width:[[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT       (IS_OS_8_OR_LATER?[[UIScreen mainScreen] nativeBounds].size.height:[[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE        [[UIScreen mainScreen] scale]


#define GSColor(r,g,b) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:1]
#define GSColorWithAlpha(r,g,b,a) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:(a)]
#define GSRandomColor GSColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define IPHONE5 [[UIScreen mainScreen] bounds].size.height == 568.0
#define IPHONE7PLUS [[UIScreen mainScreen] bounds].size.height == 736.0


//是否是iphoneX
#define IsiphoneX  (kScreenHeight == 812)
/** 导航栏加状态栏高度 */
#define NavBarHeight (IsiphoneX ? 88 : 64)
/** 状态栏高度 */
#define StatusBarHeight (IsiphoneX ? 44 : 20)
/** tabbar高度 */
#define TabbarHeight (IsiphoneX ? 83 : 49)
/** 底部安全距离 */
#define BottomSafeHeight (IsiphoneX ? 34 : 0)

#define IS_IPHONE_5_OR_BIGGER       (IS_IPHONE_5 || IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS || (SCREEN_HEIGHT >= 568.0))
#define IS_IPHONE_6_OR_BIGGER   (IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS || (SCREEN_HEIGHT >= 568.0 && !IS_IPHONE_5))

//
//
//
#define STATUS_BAR_FRAME    [[UIApplication sharedApplication] statusBarFrame]
#define STATUS_BAR_HEIGHT   MIN(STATUS_BAR_FRAME.size.height, STATUS_BAR_FRAME.size.width)
#define NAVIGATION_BAR_FRAME(__ofViewController)    (__ofViewController.navigationController.navigationBar.frame)
#define NAVIGATION_BAR_HEIGHT(__ofViewController)   (NAVIGATION_BAR_FRAME(__ofViewController).size.height)

//
// 浮点数比较操作宏（不要使用==、!=来判断浮点数）
//
#define FLT_EQUAL(a, b) (fabs((a) - (b)) < FLT_EPSILON)
#define FLT_EQUAL_ZERO(a) (fabs(a) < FLT_EPSILON)

#define DBL_EQUAL(a, b) (fabs((a) - (b)) < DBL_EPSILON)
#define DBL_EQUAL_ZERO(a) (fabs(a) < DBL_EPSILON)


//
// 非法数据检查宏
//
#define CHECK_VALID_STRING(__aString)               (__aString && [__aString isKindOfClass:[NSString class]] && [__aString length])
#define CHECK_VALID_DATA(__aData)                   (__aData && [__aData isKindOfClass:[NSData class]] && [__aData length])
#define CHECK_VALID_NUMBER(__aNumber)               (__aNumber && [__aNumber isKindOfClass:[NSNumber class]])
#define CHECK_VALID_ARRAY(__aArray)                 (__aArray && [__aArray isKindOfClass:[NSArray class]] && [__aArray count])
#define CHECK_VALID_DICTIONARY(__aDictionary)       (__aDictionary && [__aDictionary isKindOfClass:[NSDictionary class]] && [__aDictionary count])
#define CHECK_VALID_SET(__aSet)                     (__aSet && [__aSet isKindOfClass:[NSSet class]] && [__aSet count])

//
// 各型数据默认值宏
//
#define DEFAULT_STRING                              (@"")
#define DEFAULT_NUMBER                              ([NSNumber numberWithInteger:0])
#define DEFAULT_ARRAY                               ([NSArray array])
#define DEFAULT_DICTIONARY                          ([NSDictionary dictionary])

//
// 安全数据
//
#define SAFE_STRING(__str)                           (CHECK_VALID_STRING(__str)?__str:DEFAULT_STRING)
#define SAFE_NUMBER(__num)                           (CHECK_VALID_NUMBER(__num)?__num:DEFAULT_NUMBER)
#define SAFE_ARRAY(__arr)                            (CHECK_VALID_ARRAY(__arr)?__arr:DEFAULT_ARRAY)
#define SAFE_DICTIONARY(__dict)                      (CHECK_VALID_DICTIONARY(__dict)?__dict:DEFAULT_DICTIONARY)

//
// 单例定义和实现宏
//
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	IMP_SINGLETON
#define IMP_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


#endif
