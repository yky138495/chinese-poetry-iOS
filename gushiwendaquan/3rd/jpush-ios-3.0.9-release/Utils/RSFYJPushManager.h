//
//  RSFYJPushManager.h
//  RSFYKeep
//
//  Created by yangmengge on 2018/6/7.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSFYJPushManager : NSObject

// 绑定极光
+ (void)bandJPush;

// 极光解绑
+ (void)unbandJPush;

@end
