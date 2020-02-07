//
//  MTLModel+MQAdditions.m
//  MQAI
//
//  Created by ymg on 15/5/3.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MTLModel+MQAdditions.h"

@implementation MTLModel (MQAdditions)

//
// Invoked by setValue:forKey: when it’s given a nil value for a scalar value (such as an int or float).
//
// http://www.iwangke.me/2014/10/13/Why-Changba-iOS-choose-Mantle/
//
- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}

@end
