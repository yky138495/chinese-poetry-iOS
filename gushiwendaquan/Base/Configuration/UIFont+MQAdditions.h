//
//  UIFont+MQAdditions.h
//  MQAI
//
//  Created by ymg on 15/1/26.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MQAdditions)

+ (UIFont *)mqai_systemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)mqai_boldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)mqai_italicSystemFontOfSize:(CGFloat)fontSize;

@end
