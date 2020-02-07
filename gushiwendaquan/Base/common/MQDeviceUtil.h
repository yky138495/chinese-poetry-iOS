//
//  MQDeviceUtil.h
//  FreeLoan
//
//  Created by chennan on 14-7-23.
//  Copyright (c) 2014年 shtel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQDeviceUtil : NSObject

+ (NSString *) macString;
+ (NSString *) idfaString;
+ (NSString *) idfvString;
+ (NSString *) deviceInfoString;
+ (NSString *) mqai_ipString;
+ (NSString *) mqai_WifiName;
+ (NSString *)mqai_networkType;

@end
