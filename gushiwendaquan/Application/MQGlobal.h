//
//  MQGlobal.h
//  MQKeep
//
//  Created by yangmengge on 2018/5/13.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQGlobal : NSObject

DEF_SINGLETON(MQGlobal);

@property (nonatomic, copy) NSString *boy_or_girl;

@end
