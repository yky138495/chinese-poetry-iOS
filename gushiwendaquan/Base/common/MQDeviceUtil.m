//
//  MQDeviceUtil.m
//  FreeLoan
//
//  Created by chennan on 14-7-23.
//  Copyright (c) 2014年 shtel. All rights reserved.
//

#import "MQDeviceUtil.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

//device info
#include <sys/utsname.h>

#import<SystemConfiguration/CaptiveNetwork.h>
#import<CoreFoundation/CoreFoundation.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation MQDeviceUtil

+ (NSString *) macString {
     
	int 				mib[6];
	size_t 				len;
	char 				*buf;
	unsigned char	 	*ptr;
	struct if_msghdr 	*ifm;
	struct sockaddr_dl 	*sdl;
     
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
     
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return NULL;
	}
     
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return NULL;
	}
     
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return NULL;
	}
     
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		free(buf);
		return NULL;
	}
     
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
//	NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *macString = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
    
	return macString;
}

+ (NSString *) idfaString {
     
      NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
      [adSupportBundle load];
     
      if (adSupportBundle == nil) {
            return @"";
          }
      else{
           
            Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
           
            if(asIdentifierMClass == nil){
                  return @"";
                }
            else{
                 
                 //for no arc
                  //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
                  //for arc
                  ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
                 
                  if (asIM == nil) {
                        return @"";
                      }
                  else{
                       
                        if(asIM.advertisingTrackingEnabled){
                              return [asIM.advertisingIdentifier UUIDString];
                            }
                        else{
                              return [asIM.advertisingIdentifier UUIDString];
                            }
                      }
                }
          }
}

+ (NSString *) idfvString {
      if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
            return [[UIDevice currentDevice].identifierForVendor UUIDString];
          }
     
      return @"";
}

+ (NSString *)deviceInfoString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * strModel = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{
                          @"Watch1,1" : @"Apple Watch",
                          @"Watch1,2" : @"Apple Watch",
                          
                          @"iPod1,1" : @"iPod touch 1",
                          @"iPod2,1" : @"iPod touch 2",
                          @"iPod3,1" : @"iPod touch 3",
                          @"iPod4,1" : @"iPod touch 4",
                          @"iPod5,1" : @"iPod touch 5",
                          @"iPod7,1" : @"iPod touch 6",
                          
                          @"iPhone1,1" : @"iPhone 1G",
                          @"iPhone1,2" : @"iPhone 3G",
                          @"iPhone2,1" : @"iPhone 3GS",
                          @"iPhone3,1" : @"iPhone 4 (GSM)",
                          @"iPhone3,2" : @"iPhone 4",
                          @"iPhone3,3" : @"iPhone 4 (CDMA)",
                          @"iPhone4,1" : @"iPhone 4S",
                          @"iPhone5,1" : @"iPhone 5",
                          @"iPhone5,2" : @"iPhone 5",
                          @"iPhone5,3" : @"iPhone 5c",
                          @"iPhone5,4" : @"iPhone 5c",
                          @"iPhone6,1" : @"iPhone 5s",
                          @"iPhone6,2" : @"iPhone 5s",
                          @"iPhone7,1" : @"iPhone 6 Plus",
                          @"iPhone7,2" : @"iPhone 6",
                          @"iPhone8,1" : @"iPhone 6s",
                          @"iPhone8,2" : @"iPhone 6s Plus",
                          
                          @"iPhone8,4" : @"iPhone SE",
                          @"iPhone9,1" : @"iPhone 7",
                          @"iPhone9,3" : @"iPhone 7",
                          @"iPhone9,2" : @"iPhone 7 Plus",
                          @"iPhone9,4" : @"iPhone 7 Plus",
                          @"iPhone10,1" : @"iPhone 8",
                          @"iPhone10,4" : @"iPhone 8",
                          @"iPhone10,2" : @"iPhone 8 Plus",
                          @"iPhone10,3" : @"iPhone X",
                          @"iPhone10,6" : @"iPhone X",

                          @"iPad1,1" : @"iPad 1",
                          @"iPad2,1" : @"iPad 2 (WiFi)",
                          @"iPad2,2" : @"iPad 2 (GSM)",
                          @"iPad2,3" : @"iPad 2 (CDMA)",
                          @"iPad2,4" : @"iPad 2",
                          @"iPad2,5" : @"iPad mini 1",
                          @"iPad2,6" : @"iPad mini 1",
                          @"iPad2,7" : @"iPad mini 1",
                          @"iPad3,1" : @"iPad 3 (WiFi)",
                          @"iPad3,2" : @"iPad 3 (4G)",
                          @"iPad3,3" : @"iPad 3 (4G)",
                          @"iPad3,4" : @"iPad 4",
                          @"iPad3,5" : @"iPad 4",
                          @"iPad3,6" : @"iPad 4",
                          @"iPad4,1" : @"iPad Air",
                          @"iPad4,2" : @"iPad Air",
                          @"iPad4,3" : @"iPad Air",
                          @"iPad4,4" : @"iPad mini 2",
                          @"iPad4,5" : @"iPad mini 2",
                          @"iPad4,6" : @"iPad mini 2",
                          @"iPad4,7" : @"iPad mini 3",
                          @"iPad4,8" : @"iPad mini 3",
                          @"iPad4,9" : @"iPad mini 3",
                          @"iPad5,1" : @"iPad mini 4",
                          @"iPad5,2" : @"iPad mini 4",
                          @"iPad5,3" : @"iPad Air 2",
                          @"iPad5,4" : @"iPad Air 2",
                          
                          @"i386" : @"Simulator x86",
                          @"x86_64" : @"Simulator x64",
                          };
    return [dic objectForKey:strModel];
}

+ (NSString *) mqai_ipString
{
    NSString *IPAddress;
    struct ifaddrs *Interfaces;
    struct ifaddrs *Temp;
    struct sockaddr_in *s4;
    char buf[64];
    
    if (!getifaddrs(&Interfaces))
    {
        Temp = Interfaces;
        while(Temp != NULL)
        {
            //TODO
            if(Temp->ifa_addr->sa_family == AF_INET)
            {
                if([[NSString stringWithUTF8String:Temp->ifa_name] isEqualToString:@"pdp_ip0"])
                {
                    s4 = (struct sockaddr_in *)Temp->ifa_addr;
                    
                    if (inet_ntop(Temp->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL) {
                        IPAddress = nil;
                    } else {
                        IPAddress = [NSString stringWithUTF8String:buf];
                    }
                }
            }
            Temp = Temp->ifa_next;
        }
    }
    freeifaddrs(Interfaces);
    if (IPAddress == nil || IPAddress.length <= 0) {
        return @"";
    }
    return IPAddress;
}

+ (NSString *) mqai_WifiName
{
    NSString *wifiName = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
        CFRelease(myArray);
        NSLog(@"wifiName:%@", wifiName);
    }
    return wifiName;

}

+ (NSString *)mqai_networkType
{
    @try {
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            return @"NotReachable";
        }
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
            return @"WiFi";
        }
        CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus  = [telephonyInfo currentRadioAccessTechnology];
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
            return @"4G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"] ||
            [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
            return @"2G";
        }
        return @"";
    } @catch (NSException *exception) {
        return @"";
    }
}

@end
