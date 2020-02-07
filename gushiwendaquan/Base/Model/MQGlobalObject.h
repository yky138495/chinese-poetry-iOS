//
//  MQGlobalObject.h
//  MQAI
//
//  Created by ymg on 15/2/28.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQGlobalObject : NSObject

DEF_SINGLETON(MQGlobalObject);

// 官网地址
@property (nonatomic, copy) NSString *siteUrlString;

//是否是新手
@property (nonatomic, assign) BOOL isTiroUser;
// 进入后台时的时间值
@property (nonatomic, strong) NSDate *enterBackgroundTime;
// JPush RegistrationID
@property (nonatomic, copy) NSString *JPushRegistrationID;

@end
