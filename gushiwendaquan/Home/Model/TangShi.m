//
//  TangShi.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/21.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "TangShi.h"

@implementation TangShi

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"strainsArray": @"strains"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"paragraphs":[NSString class],
             @"strainsArray":[NSString class],
             };
}


@end
