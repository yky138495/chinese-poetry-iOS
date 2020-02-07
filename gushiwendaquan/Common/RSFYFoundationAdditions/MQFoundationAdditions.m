//
//  MQFoundationAdditions.m
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQFoundationAdditions.h"


//
// NSArray
//
@implementation NSArray (Additions)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
#if DEBUG
        //NSAssert(NO, @"数组越界");
#endif
    }
    return nil;
}

- (NSArray *)uniqueArray
{
    NSMutableArray *uniqeArr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![uniqeArr containsObject:obj]) {
            [uniqeArr safeAddObject:obj];
        }
    }];
    return uniqeArr;
}

@end


//
// NSMutableArray
//
@implementation NSMutableArray (Additions)

- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    } else {
#if DEBUG
        //NSAssert(NO, @"不能添加nil Object");
#endif
    }
}

- (void)safeAddNilObject
{
    [self addObject:[NSNull null]];
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    } else {
#if DEBUG
        //NSAssert(NO, @"不能添加nil Object");
#endif
    }
}

@end



//
// NSMutableDictionary
//
@implementation NSMutableDictionary (Additions)

- (void)safeSetObject:(id)anObject forKey:(id)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    } else {

    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:value forKey:key];
    } else {

    }
}


@end

@implementation NSDictionary (Additions)

- (NSString *)stringForKey:(NSString *)key
{
    if (key) {
        NSObject *obj = [self objectForKey:key];
        if (obj) {
            return [obj description];
        }
    }
    return @"";
}

- (NSString *)mqai_stringForKey:(NSString *)key
{
    if (key) {
        NSObject *obj = [self objectForKey:key];
        if (obj) {
            return [obj description];
        }
    }
    return @"";
}

- (NSInteger)integerForKey:(NSString *)key
{
    if (key) {
        return [[self objectForKey:key] integerValue];
    }
    return 0;
}

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/** 字段转换成Json字符串 */
- (NSString *)jsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return @"";
}

//
// 修复JSON串中 中文字符 的控制台输出问题
// http://www.jianshu.com/p/b6bb983e39da
//

@end
