//
//  MQUser.m
//  MQAI
//
//  Created by ymg on 15/2/10.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQUser.h"

@implementation MQBaseLogin

@end

@implementation MQUser

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithLogin:(MQBaseLogin *)login
{
    self = [super init];
    if (self) {
        _ID = login.uid;
        _custID = login.custid;
        _name = login.userName;
        _mobile = login.mobile;
        _realName = login.realName;
        _aliasUid = login.aliasUid;
        _isBandAlias = NO;
        _needSync = YES;
        _isFrozen = NO;
        _isInBlackList = NO;
    }
    return self;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _ID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"ID"];
        _custID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"custID"];
        _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _mobile = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"mobile"];
        _realName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"realName"];
        _isFrozen = [aDecoder decodeBoolForKey:@"isFrozen"];
        _isInBlackList = [aDecoder decodeBoolForKey:@"isInBlackList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.custID forKey:@"custID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeBool:self.isFrozen forKey:@"isFrozen"];
    [aCoder encodeBool:self.isInBlackList forKey:@"isInBlackList"];
}

#pragma mark - 

- (void)setRealName:(NSString *)realName
{
    if (_realName != realName) {
        if (![_realName isEqualToString:realName]) {
            _realName = realName;
            _needSync = YES;
        }
    }
}

- (void)setMobile:(NSString *)mobile
{
    if (_mobile != mobile) {
        if (![_mobile isEqualToString:mobile]) {
            _mobile = mobile;
            _needSync = YES;
        }
    }
}

- (void)setIsFrozen:(BOOL)isFrozen
{
    if (_isFrozen != isFrozen) {
        _isFrozen = isFrozen;
        _needSync = YES;
    }
}

- (void)setIsInBlackList:(BOOL)isInBlackList
{
    if (_isInBlackList != isInBlackList) {
        _isInBlackList = isInBlackList;
        _needSync = YES;
    }
}

@end
