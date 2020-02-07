//
//  MQLog.m
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQLog.h"


@interface MQLog ()

@property (nonatomic, strong) DDFileLogger *fileLogger;

@end


@implementation MQLog

IMP_SINGLETON(MQLog);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableConsoleLogger = YES;
        self.enableFileLogger = YES;
    }
    return self;
}

- (void)setEnableConsoleLogger:(BOOL)enableConsoleLogger
{
    if (enableConsoleLogger != _enableConsoleLogger) {
        if (enableConsoleLogger) {
            // 实例化 Lumberjack
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        } else {
            [DDLog removeLogger:[DDTTYLogger sharedInstance]];
            [[DDTTYLogger sharedInstance] setColorsEnabled:NO];
        }
        _enableConsoleLogger = enableConsoleLogger;
    }
}

- (void)setEnableFileLogger:(BOOL)enableFileLogger
{
    if (enableFileLogger != _enableFileLogger) {
        if (enableFileLogger) {
            self.fileLogger = [[DDFileLogger alloc] init];
            self.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
            self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
            [DDLog addLogger:self.fileLogger];
        } else {
            [DDLog removeLogger:self.fileLogger];
        }
        _enableFileLogger = enableFileLogger;
    }
}

@end
