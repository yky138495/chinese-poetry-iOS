//
//  MQUserInfo.h
//  MQAI
//
//  Created by ymg on 15/2/10.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  用户自定义信息对象
 */
@interface MQUserInfo : NSObject<NSSecureCoding>

// 是否需要同步
@property (atomic, assign) BOOL needSync;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

//
// 线程安全的
//
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(id)key;
- (void)clear;

@end
