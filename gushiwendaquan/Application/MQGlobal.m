//
//  MQGlobal.m
//  MQKeep
//
//  Created by yangmengge on 2018/5/13.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "MQGlobal.h"

@implementation MQGlobal

IMP_SINGLETON(MQGlobal);

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认
        self.boy_or_girl = @"boy";
    }
    return self;
}

@end
