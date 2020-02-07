//
//  MQSession.h
//  MQAI
//
//  Created by ymg on 14/12/31.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQUser.h"
#import "MQUserInfo.h"

#define MQ_SESSION_KEY_BACKUP_USER_ID          @"MQ_SESSION_KEY_BACKUP_USER_ID"
#define MQ_SESSION_KEY_INVITEE_FIRST_LOGIN          @"MQ_SESSION_KEY_INVITEE_FIRST_LOGIN"
#define MQ_SESSION_KEY_INVITEE_FIRST_REGISTER          @"MQ_SESSION_KEY_INVITEE_FIRST_REGISTER"
#define MQ_SESSION_KEY_BACKUP_USER_PHONE          @"MQ_SESSION_KEY_BACKUP_USER_PHONE"
#define MQ_SESSION_KEY_BACKUP_USER_REALNAME          @"MQ_SESSION_KEY_BACKUP_USER_REALNAME"
#define MQ_SESSION_KEY_USER_CHANGE          @"MQ_SESSION_KEY_USER_CHANGE"
#define MQ_SESSION_KEY_HASREALNAME         @"hasRealNameIdentified"
#define MQ_SESSION_KEY_MOBILE          @"mobile"

// 通知
extern NSString * const MQApplicationLoginNotification;

/**
 *  登录会话对象
 */
@interface MQSession : NSObject <NSSecureCoding>

// 用户ID
@property (nonatomic, copy, readonly) NSString *userID;
// 用户ID
@property (nonatomic, copy, readonly) NSString *custID;
// 用户对象
@property (nonatomic, strong) MQUser *user;
// 自定义用户数据
@property (nonatomic, strong, readonly) MQUserInfo *userInfo;

// 会话ID(其实是deviceToken)
@property (nonatomic, copy) NSString *sessionID;

// 其实是sessionID
@property (nonatomic, copy) NSString *realSessionID;

// 会话创建时间
@property (nonatomic, assign) NSInteger createTime;
// 是否需要同步
@property (atomic, assign) BOOL needSync;


// 登录态检查
- (BOOL)isLogin;
// 退出登录态
- (void)logout;


// 操作userInfo
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(id)key;
- (void)clearUserInfo;


// 初始化方法
- (instancetype)initWithUser:(MQUser *)user;
- (instancetype)initWithUser:(MQUser *)user userInfo:(MQUserInfo *)userInfo;
- (instancetype)initWithSessionID:(NSString *)sessionID
                    realSessionID:(NSString *)realSessionID
                       createTime:(NSInteger)createTime
                             user:(MQUser *)user
                         userInfo:(MQUserInfo *)userInfo;

@end
