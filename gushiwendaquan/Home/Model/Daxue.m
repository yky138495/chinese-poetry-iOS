//
//  Daxue.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "Daxue.h"

@implementation Daxue
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{
//             @"did": @"id"
//             };
//}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"paragraphs":[NSString class],
             };
}
@end
