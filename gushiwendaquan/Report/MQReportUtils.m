//
//  MQReportUtils.m
//  MQAI
//
//  Created by Tove on 16/4/6.
//  Copyright © 2016年 ymg. All rights reserved.
//

#import "MQReportUtils.h"
#import "TalkingData.h"

@implementation MQReportUtils

#pragma mark - 页面统计
/// !!!: talkdata 统计的都是事件
+ (void)trackStateWithName:(NSString *)name
{
    if (name.length) {
        [TalkingData trackEvent:name];
    }
}

@end
