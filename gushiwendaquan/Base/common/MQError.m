//
//  MQError.m
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQError.h"


//
NSString * const MQErrorDomain = @"MQErrorDomain";
NSString * const MQUnknownErrorMessage = @"MQUnknownErrorMessage";
NSString * const MQErrorMessageErrorKey = @"MQErrorMessageErrorKey";


@implementation MQError

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    NSString *message = MQ_ERROR_MESSAGE_FROM_CODE(code);
    if (!message) {
        message = [dict objectForKey:MQErrorMessageErrorKey];
        if (!message) {
            message = MQUnknownErrorMessage;
            NSLog(@"Unknown error code %lld", (long long)code);
        }
    }
    
    NSMutableDictionary *errorDict = nil;
    if (dict) {
        errorDict = [dict mutableCopy];
    } else {
        errorDict = [[NSMutableDictionary alloc] init];
    }
    if (![errorDict objectForKey:MQErrorMessageErrorKey]) {
        [errorDict setObject:message forKey:MQErrorMessageErrorKey];
    }
    
    MQError *error = [super errorWithDomain:domain code:code userInfo:errorDict];
    return error;
}

- (NSString *)message
{
    return [self.userInfo objectForKey:MQErrorMessageErrorKey];
}

- (NSString *)localizedMessage
{
    return NSLocalizedString(self.message, self.message);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"domain: %@, code: %d, message: '%@'", self.domain, (int)self.code, [self message]];
}

@end
