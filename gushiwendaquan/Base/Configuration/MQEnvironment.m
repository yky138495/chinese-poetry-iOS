//
//  MQEnvironment.m
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQEnvironment.h"
#import "MQCacheService.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "CFileHandle.h"

// 开发环境签名秘钥
#define DEV_SIGN_KEY (__KEY1_VALUE)
#define DEV_SECOND_SIGN_KEY (__KEY2_VALUE)

// 测试环境签名秘钥
#define TEST_SIGN_KEY @""
#define TEST_SECOND_SIGN_KEY (__KEY2_VALUE)

// 预发布环境签名秘钥
#define PRE_SIGN_KEY @""
#define PRE_SECOND_SIGN_KEY (__KEY2_VALUE)

// 生产环境签名秘钥
#define PROD_SIGN_KEY (__KEY1_VALUE)
#define PROD_SECOND_SIGN_KEY (__KEY2_VALUE)

#define MQ_DEFAULT_ENVIORMENT_PLIST @"DEFAULT_ENVIORMENT.plist"
#define MQ_DEFAULT_ENVIORMENT_COMPARE_PLIST @"DEFAULT_ENVIORMENT_COMPARE.plist"

@interface MQEnvironment ()

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *configsCachePath;

- (void)loadEnvironmentDict:(NSDictionary *)dict;

@end


@implementation MQEnvironment

IMP_SINGLETON(MQEnvironment);

static NSString * __KEY1_VALUE = nil;
static NSString * __KEY2_VALUE = nil;

+ (void)initialize
{
   
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initDefaultEnvironment];
        self.configsCachePath = [[MQCacheService sharedInstance].configsCacheDirectory stringByAppendingPathComponent:MQ_DEFAULT_ENVIORMENT_PLIST];
        self.dict = [NSDictionary dictionaryWithContentsOfFile:self.configsCachePath];

        // 为防止plist文件被意外破坏（非越狱app应该不会出现）
        if (!CHECK_VALID_DICTIONARY(_dict)) {
            NSLog(@"Invalid environment plist");
            return nil;
        }

        // 从dict中读取并设置APP环境变量
        [self loadEnvironmentDict:_dict];
        
        // 打印环境配置
        __block NSString *envars = @"";
        [_dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            envars = [envars stringByAppendingFormat:@"  %@: %@\n", key, obj];
        }];
        
#if DEBUG
        NSLog(@"Environment plist: %@\n", self.configsCachePath);
#endif
        NSLog(@"%@", [NSString stringWithFormat:@"Start environment configuration\n*************** %@ ***************\n%@****************************************\n", [self cnEnvironmentNameWithEnName:_environmentName], envars]);
    }
    return self;
}

#if DEBUG

- (void)initDefaultEnvironment
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"environment" ofType:@"plist"];
    NSString *configsCachePath = [[MQCacheService sharedInstance].configsCacheDirectory stringByAppendingPathComponent:MQ_DEFAULT_ENVIORMENT_PLIST];
    NSString *configsCacheComparePath = [[MQCacheService sharedInstance].configsCacheDirectory stringByAppendingPathComponent:MQ_DEFAULT_ENVIORMENT_COMPARE_PLIST];
    if (![CFileHandle containFileAtPath:configsCachePath]) {
        [CFileHandle copyItemAtPath:bundlePath toPath:configsCachePath];
        [CFileHandle copyItemAtPath:bundlePath toPath:configsCacheComparePath];
    }else{
        NSDictionary *bundleEnviornmentdict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
        NSDictionary *cacheEnviornmentComparedict = [NSDictionary dictionaryWithContentsOfFile:configsCacheComparePath];
        
        if (CHECK_VALID_DICTIONARY(bundleEnviornmentdict)&&CHECK_VALID_DICTIONARY(cacheEnviornmentComparedict)){
            if (![bundleEnviornmentdict isEqualToDictionary:cacheEnviornmentComparedict]) {
                [CFileHandle removeFileAtPath:configsCachePath];
                [CFileHandle removeFileAtPath:configsCacheComparePath];
                [CFileHandle copyItemAtPath:bundlePath toPath:configsCachePath];
                [CFileHandle copyItemAtPath:bundlePath toPath:configsCacheComparePath];
            }
        }
    }
}

- (void)synchronize
{
    NSMutableDictionary *dict = [_dict mutableCopy];
    [dict safeSetObject:_environmentName forKey:@"environment"];
    [dict safeSetObject:_apiBaseURLString forKey:@"apiBaseUrl"];
    [dict safeSetObject:_apiBasePathString forKey:@"apiBasePath"];
    [dict writeToFile:self.configsCachePath atomically:YES];
}

#endif

- (void)loadEnvironmentDict:(NSDictionary *)dict
{
    _environmentName = dict[@"environment"];

    _appName = dict[@"appName"];
    _appScheme = dict[@"appScheme"];
    _appChannel = dict[@"appChannel"];
    _mobileMarket = dict[@"mobileMarket"];
    _apiBaseURLString = dict[@"apiBaseUrl"];
    _apiBasePathString = dict[@"apiBasePath"];
    _apiRequestTimeout = [dict[@"apiRequestTimeout"] doubleValue];
    _jpAppKey = dict[@"jpAppKey"];
    _jpIsProduction = dict[@"jpIsProduction"];
    _talkingDataAppKey = dict[@"talkingDataAppKey"];
    _shareAppKey = dict[@"shareAppKey"];
    _sinaAppKey = dict[@"sinaAppKey"];
    _sinaAppSecret = dict[@"sinaAppSecret"];
    _qqAppId = dict[@"qqAppId"];
    _qqAppKey = dict[@"qqAppKey"];
    _wxAppId = dict[@"wxScheme"];
    _wxAppSecret = dict[@"wxAppSecret"];
    
    if ([_environmentName isEqualToString:MQ_ENV_DEV]) {
        _signKey = PROD_SIGN_KEY;
        _secondSignKey = PROD_SECOND_SIGN_KEY;
    } else if ([_environmentName isEqualToString:MQ_ENV_TEST]) {
        _signKey = TEST_SIGN_KEY;
        _secondSignKey = TEST_SECOND_SIGN_KEY;
    }

    else {
        _signKey = TEST_SIGN_KEY;
        _secondSignKey = TEST_SECOND_SIGN_KEY;
    }
}

- (NSString *)description
{
    return _desc;
}

- (NSString *)cnEnvironmentNameWithEnName:(NSString *)enName
{
    return @"生产环境";
}

@end
