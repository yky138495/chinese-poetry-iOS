//
//  MQViewControllerJumpCenter.h
//  MQAI
//
//  Created by ymg on 15/1/28.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
=
 */

@interface MQViewControllerJumpCenter : NSObject

DEF_SINGLETON(MQViewControllerJumpCenter);

@property (nonatomic, strong) NSString *openUrl;

- (NSDictionary *)schemaDict;

/** 根据传入的url，控制url跳转 */
- (void)jumpWithOpenUrl:(NSString *)openUrl;
- (void)jumpWithOpenUrlNotification:(NSNotification *)notification;

@end
