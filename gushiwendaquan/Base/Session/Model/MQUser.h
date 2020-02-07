//
//  MQUser.h
//  MQAI
//
//  Created by ymg on 15/2/10.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQBaseLogin : NSObject

// 用户ID
@property (nonatomic, copy) NSString *uid;
// 用户ID
@property (nonatomic, copy) NSString *custid;
// 用户名
@property (nonatomic, copy) NSString *userName;
// 真实姓名
@property (nonatomic, copy) NSString *realName;
// 手机号
@property (nonatomic, copy) NSString *mobile;
// 用户ID别名
@property (nonatomic, copy, readonly) NSString *aliasUid;

@end

/**
 *  用户对象模型（主要的私密信息，字段可能仅是MQLogin的一部分）
 */
@interface MQUser : NSObject<NSSecureCoding>

// 用户ID
@property (nonatomic, copy, readonly) NSString *ID;
// 用户ID
@property (nonatomic, copy, readonly) NSString *custID;
// 用户名称
@property (nonatomic, copy, readwrite) NSString *name;
// 手机号
@property (nonatomic, copy, readwrite) NSString *mobile;
// 真实姓名
@property (nonatomic, copy, readwrite) NSString *realName;
// 用户头像url
@property (nonatomic, copy, readwrite) NSString *headerUrl;
// 是否冻结
@property (nonatomic, assign, readwrite) BOOL isFrozen;
// 是否黑名单用户
@property (nonatomic, assign, readwrite) BOOL isInBlackList;
// 别名
@property (nonatomic, copy, readwrite) NSString *aliasUid;
// 别名是否绑定成功
@property (nonatomic, assign, readwrite) BOOL isBandAlias;

// 是否需要同步
@property (atomic, assign) BOOL needSync;

- (instancetype)initWithLogin:(MQBaseLogin *)login;

@end
