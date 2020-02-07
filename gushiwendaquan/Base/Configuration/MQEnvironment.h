//
//  MQEnvironment.h
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>


// APP环境初始化宏
#define MQ_ENVIRONMENT_INIT ENV

// APP环境单例对象
#define ENV [MQEnvironment sharedInstance]


// 环境定义
#define MQ_ENV_DEV          @"DEV"
#define MQ_ENV_TEST         @"TEST"
#define MQ_ENV_PROD         @"PROD"


#ifdef DEBUG


#endif


#if DEBUG
#define ENV_PROP_DESC (nonatomic, copy)
#else
#define ENV_PROP_DESC (nonatomic, copy, readonly)
#endif

//
// 环境对象
//
@interface MQEnvironment : NSObject

DEF_SINGLETON(MQEnvironment);

@property ENV_PROP_DESC NSString *environmentName;

@property (nonatomic, copy, readonly) NSString *appName;

@property (nonatomic, copy, readonly) NSString *appScheme;

@property (nonatomic, copy, readonly) NSString *appChannel;

@property (nonatomic, copy, readonly) NSString *mobileMarket;

@property ENV_PROP_DESC NSString *apiBaseURLString;

@property ENV_PROP_DESC NSString *apiBasePathString;

@property (nonatomic, assign, readonly) NSTimeInterval apiRequestTimeout;


@property (nonatomic, copy, readonly) NSString *signKey;

@property (nonatomic, copy, readonly) NSString *secondSignKey;

// 极光推送，App Key
@property (nonatomic, copy, readonly) NSString *jpAppKey;
// 极光推送，是否是生产环境
@property (nonatomic, copy, readonly) NSString *jpIsProduction;
// TalkingData的App Key
@property (nonatomic, copy, readonly) NSString *talkingDataAppKey;

// ShareSDK的App Key
@property (nonatomic, copy, readonly) NSString *shareAppKey;
// 新浪微博分享的App Key
@property (nonatomic, copy, readonly) NSString *sinaAppKey;
// 新浪微博分享的App Secret
@property (nonatomic, copy, readonly) NSString *sinaAppSecret;
// QQ分享的App Id
@property (nonatomic, copy, readonly) NSString *qqAppId;
// QQ分享的App Key
@property (nonatomic, copy, readonly) NSString *qqAppKey;
// 微信分享的App Id
@property (nonatomic, copy, readonly) NSString *wxAppId;
// 微信分享的App Secret
@property (nonatomic, copy, readonly) NSString *wxAppSecret;

#if DEBUG
- (void)synchronize;
#endif

@end
