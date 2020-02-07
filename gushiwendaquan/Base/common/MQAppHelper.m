//
//  MQAppHelper.m
//  MQAI
//
//  Created by ymg on 14/12/16.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQAppHelper.h"

//
#define MQ_APP_DEVICE_TOKEN_KEY @"MQ_APP_DEVICE_TOKEN_KEY"
#define MQ_APP_EVER_LAUNCHED_KEY @"MQ_APP_EVER_LAUNCHED_KEY"
#define MQ_APP_LAUNCH_VERSION_KEY @"MQ_APP_LAUNCH_VERSION_KEY"


@implementation MQAppHelper

IMP_SINGLETON(MQAppHelper);

-(void)setDeviceToken:(NSString *)deviceToken
{
    if (![_deviceToken isEqualToString:deviceToken]) {
        _deviceToken = [deviceToken copy];
        if (_deviceToken) {
            [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:MQ_APP_DEVICE_TOKEN_KEY];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MQ_APP_DEVICE_TOKEN_KEY];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationLandscapeLeft == orientation) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (UIInterfaceOrientationLandscapeRight == orientation) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

+ (NSString *)bundleSeedID
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge __strong id)kSecClassGenericPassword, kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge __strong id)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

@end

@implementation MQAppHelper (AppInfo)

- (NSString *)appName
{
    return [NSString stringWithFormat:@"%@ %@", [self appBundleName], [self appVersion]];
}

- (NSString *)appBundleName
{
    NSString* bundelName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] description];
    if(bundelName == nil) {
        bundelName = @"";
    }
    return bundelName;
}

- (NSString *)appBundleID
{
    NSString* bundelId = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] description];
    if(bundelId == nil) {
        bundelId = @"";
    }
    return bundelId;
}

- (NSString *)appVersion
{
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if(shortVersion == nil) {
        shortVersion = @"";
    }
    return shortVersion;
}

- (NSString *)appFullVersion
{
    NSString* version = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] description];
    if(version == nil) {
        version = @"";
    }
    return version;
}

@end


@implementation MQAppHelper (Launch)

- (BOOL)isFirstLaunch
{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:MQ_APP_LAUNCH_VERSION_KEY];
    if ([version isEqualToString:[self appVersion]]) {
        return NO;
    }
    return YES;
}

- (BOOL)isEverLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:MQ_APP_EVER_LAUNCHED_KEY];
}

- (void)setFirstLaunch:(BOOL)firstLaunch
{
    [self setEverLaunched:(!firstLaunch)];
}

- (void)setEverLaunched:(BOOL)everLaunched
{
    [[NSUserDefaults standardUserDefaults] setBool:everLaunched forKey:MQ_APP_EVER_LAUNCHED_KEY];
    if (everLaunched) {
        [[NSUserDefaults standardUserDefaults] setObject:[self appVersion] forKey:MQ_APP_LAUNCH_VERSION_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MQ_APP_LAUNCH_VERSION_KEY];
    }
    if (![[NSUserDefaults standardUserDefaults] synchronize]) {
        NSLog(@"setEverLaunched synchronize failed");
    }
}

@end

@implementation MQAppHelper (ViewController)

- (UIViewController *)topViewController
{
    UIViewController *rootCtrl = [[UIApplication sharedApplication].windows.firstObject rootViewController];
    
    if ([[UIApplication sharedApplication] conformsToProtocol:@protocol(MQAppExtensionProtocol)]) {
        id<MQAppExtensionProtocol> appExt = (id<MQAppExtensionProtocol>)[UIApplication sharedApplication];
        if ([appExt respondsToSelector:@selector(topViewController)]) {
            UIViewController *topCtrl = [appExt topViewController];
            return [self topViewController:topCtrl];
        }
    }
    
    return [self topViewController:rootCtrl];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end
