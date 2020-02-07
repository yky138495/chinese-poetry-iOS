



//
//  Shijing.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "Shijing.h"

@implementation Shijing

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"paragraphs": @"content"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"paragraphs":[NSString class],
             };
}

@end
