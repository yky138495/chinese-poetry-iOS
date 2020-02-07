//
//  MQUserInfo.m
//  MQAI
//
//  Created by ymg on 15/2/10.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQUserInfo.h"


@interface MQUserInfo ()

@property (nonatomic, strong) NSMutableDictionary *userDict;

@end


@implementation MQUserInfo

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (!dict) {
            self.userDict = [[NSMutableDictionary alloc] init];
        } else {
            self.userDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        }
        _needSync = YES;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userDict = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:@"userDict"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userDict forKey:@"userDict"];
}

#pragma mark - Operations

- (id)objectForKey:(NSString *)key
{
    return [self.userDict objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [self.userDict safeSetObject:object forKey:key];
    self.needSync = YES;
}

- (void)removeObjectForKey:(id)key
{
    [self.userDict removeObjectForKey:key];
    self.needSync = YES;
}

- (void)clear
{
    [self.userDict removeAllObjects];
}

@end
