//
//  UIFont+MQAdditions.m
//  MQAI
//
//  Created by ymg on 15/1/26.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "UIFont+MQAdditions.h"

@implementation UIFont (MQAdditions)

+ (UIFont *)mqai_systemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    
    if (IS_STANDARD_IPHONE_6_PLUS) {
//        size = fontSize + 1;
    }
    
    if (!IS_IPHONE_6_OR_BIGGER) {
        size -= 1;
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)mqai_boldSystemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    
    if (IS_STANDARD_IPHONE_6_PLUS) {
//        size = fontSize + 1;
    }
    
    if (!IS_IPHONE_6_OR_BIGGER) {
        size -= 1;
    }
    
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)mqai_italicSystemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    
    if (IS_STANDARD_IPHONE_6_PLUS) {
//        size = fontSize + 1;
    }
    
    if (!IS_IPHONE_6_OR_BIGGER) {
        size -= 1;
    }
    
    return [UIFont italicSystemFontOfSize:size];
}

@end
