//
//  MQLog.h
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>


//
// MQ日志宏
//
// OC版
#define MQ_E(format, ...) DDLogError((format), ##__VA_ARGS__)
#define MQ_W(format, ...) DDLogWarn((format), ##__VA_ARGS__)
#define MQ_I(format, ...) DDLogInfo((format), ##__VA_ARGS__)
#define MQ_V(format, ...) DDLogVerbose((format), ##__VA_ARGS__)
// C版
#define MQ_CE(format, ...) DDLogCError((format), ##__VA_ARGS__)
#define MQ_CW(format, ...) DDLogCWarn((format), ##__VA_ARGS__)
#define MQ_CI(format, ...) DDLogCInfo((format), ##__VA_ARGS__)
#define MQ_CV(format, ...) DDLogCVerbose((format), ##__VA_ARGS__)


// 初始化日志系统
#define MQ_LOG_INIT [MQLog sharedInstance]

// 设置LOG级别（目前直接使用DDLog定义的宏，如LOG_LEVEL_VERBOSE等）
#define MQ_LOG_SET_LEVEL(level) static const int ddLogLevel = level


@interface MQLog : NSObject

DEF_SINGLETON(MQLog);

@property (nonatomic, assign) BOOL enableConsoleLogger;
@property (nonatomic, assign) BOOL enableFileLogger;

@end
