//
//  MQFoundationAdditions.h
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//
#import <Foundation/Foundation.h>

//
// NSArray
//
@interface NSArray (Additions)

- (id)safeObjectAtIndex:(NSUInteger)index;
- (NSArray *)uniqueArray;

@end


//
// NSMutableArray
//
@interface NSMutableArray (Additions)

- (void)safeAddObject:(id)object;
- (void)safeAddNilObject;
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

@end


//
// NSMutableDictionary
//
@interface NSMutableDictionary (Additions)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)safeSetValue:(id)value forKey:(NSString *)key;

@end


//
// NSDictionary
//
@interface NSDictionary (Additions)

//stringForKey和sdk中名字冲突
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)mqai_stringForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/** 字段转换成Json字符串 */
- (NSString *)jsonString;
@end
