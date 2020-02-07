//
//  MQSession.m
//  MQAI
//
//  Created by ymg on 14/12/31.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQSession.h"


NSString * const MQApplicationLoginNotification = @"MQApplicationLoginNotification";


@interface MQSession ()

@property (nonatomic, assign) BOOL login;
@property (nonatomic, strong, readwrite) MQUserInfo *userInfo;

- (BOOL)checkLogin;

@end


@implementation MQSession

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - Init

- (instancetype)init
{
    return [self initWithUser:nil];
}

- (instancetype)initWithUser:(MQUser *)user
{
    return [self initWithUser:user userInfo:nil];
}

- (instancetype)initWithUser:(MQUser *)user userInfo:(MQUserInfo *)userInfo
{
    return [self initWithSessionID:nil realSessionID:nil createTime:0 user:user userInfo:userInfo];
}

- (instancetype)initWithSessionID:(NSString *)sessionID
                    realSessionID:(NSString *)realSessionID
                       createTime:(NSInteger)createTime
                             user:(MQUser *)user
                         userInfo:(MQUserInfo *)userInfo
{
    self = [super init];
    if (self) {
        //
        self.user = user;
        if (userInfo) {
            self.userInfo = userInfo;
        } else {
            self.userInfo = [[MQUserInfo alloc] init];
        }
        self.login = [self checkLogin];
        //
        if (sessionID) {
            self.sessionID = sessionID;
            self.createTime = createTime;
        } else {
            self.sessionID = [[[MQStringUtil uuid] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
            self.createTime = [[NSDate date] timeIntervalSince1970];
            _needSync = YES;
            NSLog(@"Session %@ created at %@", self.sessionID, [NSDate dateWithTimeIntervalSince1970:self.createTime]);
        }
        if (realSessionID) {
            self.realSessionID = realSessionID;
        } else {
            self.realSessionID = @"";
        }
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _user = [aDecoder decodeObjectOfClass:[MQUser class] forKey:@"user"];
        _userInfo = [aDecoder decodeObjectOfClass:[MQUserInfo class] forKey:@"userInfo"];
        _sessionID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sessionID"];
        _realSessionID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"realSessionID"];
        _createTime = [aDecoder decodeIntegerForKey:@"createTime"];
        _login = [self checkLogin];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
    [aCoder encodeObject:self.sessionID forKey:@"sessionID"];
    [aCoder encodeObject:self.realSessionID forKey:@"realSessionID"];
    [aCoder encodeInteger:self.createTime forKey:@"createTime"];
}

#pragma mark - Operations

- (NSString *)userID
{
    return self.user.ID;
}

- (NSString *)custID
{
    return self.user.custID;
}

// 重设用户
- (void)setUser:(MQUser *)user
{
    if (_user != user) {
        _user = user;
        self.login = [self checkLogin];
        if (_login) {
            // 登录通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MQApplicationLoginNotification
                                                                object:user];
        }
    }
}

- (void)setSessionID:(NSString *)sessionID
{
    if (_sessionID != sessionID) {
        _sessionID = sessionID;
        _needSync = YES;
    }
}

- (void)setRealSessionID:(NSString *)realSessionID
{
    if (_realSessionID != realSessionID) {
        _realSessionID = realSessionID;
    }
}

- (void)setCreateTime:(NSInteger)createTime
{
    if (_createTime != createTime) {
        _createTime = createTime;
        _needSync = YES;
    }
}

- (BOOL)isLogin
{
    return _login;
}

- (BOOL)checkLogin
{
    return [self.userID length];
}

- (void)logout
{
    self.user = nil;
    _login = NO;
    _needSync = YES;
}

- (id)objectForKey:(NSString *)key
{
    return [self.userInfo objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    return [self.userInfo setObject:object forKey:key];
}

- (void)removeObjectForKey:(id)key
{
    return [self.userInfo removeObjectForKey:key];
}

- (void)clearUserInfo
{
    [self.userInfo clear];
}

@end
