//
//  AppDelegate.m
//  gushiwendaquan
//
//  Created by yangmengge on 2019/2/20.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "AppDelegate.h"
#import "MQTabContainerController.h"
#import "TalkingData.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import <UMPush/UMessage.h>             // Push组件
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"
#import "MQViewControllerJumpCenter.h"
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库
#import <AVFoundation/AVFoundation.h>

NSString * const MQApplicationOpenURLNotification = @"MQApplicationOpenURLNotification";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    // 初始化环境变量
    
    application.statusBarStyle = UIStatusBarStyleDefault;
    application.statusBarHidden = NO;
    
    MQ_ENVIRONMENT_INIT;
    
    // 初始化观察
    [self initObservation];
    
    // 初始化会话
    [self initSession];
    
    // 初始化网络
    [self initNetworking];
    
 
    // 初始化缓存
    [self initURLCache];
    // 初始化统计
    [self initStatistics:launchOptions];
    
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    // 初始化分享
    // 设置主界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MQTabContainerController sharedInstance];
    [self.window makeKeyAndVisible];
    
    // 设置已启动过标志
    [[MQAppHelper sharedInstance] setEverLaunched:YES];
    //
    // 初始化消息推送
    [self initRemoteNotification:launchOptions];
    
    // APP未启动时，接到推送消息
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handlePushNotification:userInfo];
            });
        }
    }
    return YES;
}


#pragma mark - Init observation

- (void)initObservation
{
 
    [self initJPushNotifications];
    //观察OpenURL通知
    [[NSNotificationCenter defaultCenter] addObserver:[MQViewControllerJumpCenter sharedInstance]
                                             selector:@selector(jumpWithOpenUrlNotification:)
                                                 name:MQApplicationOpenURLNotification
                                               object:nil];
    
}

#pragma mark - Init session

- (void)initSession
{
   
}

#pragma mark - Init networking

- (void)initNetworking
{
    // 展示网络活动转标
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 开启网络变化侦听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Init caching

- (void)initURLCache
{
    NSURLCache *aURLCache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024
                                                          diskCapacity:20*1024*1024
                                                              diskPath:nil];
    [NSURLCache setSharedURLCache:aURLCache];
    
    // 接受默认的cookie政策
    NSHTTPCookieStorage *cook = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cook setCookieAcceptPolicy: NSHTTPCookieAcceptPolicyAlways];
}

#pragma mark - Init statistics

- (void)initStatistics:(NSDictionary *)launchOptions
{
    // 开启TalkingData异常自动捕获
    [TalkingData setExceptionReportEnabled:YES];
    // 开启TalkingData
    [TalkingData sessionStarted:@""
                  withChannelId:@"app store"];
    [UMConfigure initWithAppkey:@"" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    // Push组件基本功能配置
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    [UMessage setAutoAlert:NO];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户选择了接收Push消息
        }else{
            // 用户拒绝接收Push消息
        }
    }];
    
    
}


-(void)upStatistics:(NSDictionary *)launchOptions
{
    
}


#pragma mark - Init sharing


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidLogout:(NSNotification *)notification
{
    
}
#pragma mark - WX

- (void)initWX
{
  
    
}

#pragma mark - JPush Notifications

/** 添加极光推送相关通知 */
- (void)initJPushNotifications
{
    // 建立连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpSetupNotification:) name:kJPFNetworkDidSetupNotification object:nil];
    // 关闭连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpCloseNotification:) name:kJPFNetworkDidCloseNotification object:nil];
    // 注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpRegisterNotification:) name:kJPFNetworkDidRegisterNotification object:nil];
    // 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpLoginNotification:) name:kJPFNetworkDidLoginNotification object:nil];
    // 收到自定义消息（非APNS）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpReceiveMessageNotification:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    // 连接中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpConnectingNotification:) name:kJPFNetworkIsConnectingNotification object:nil];
    // 错误提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpServiceErrorNotification:) name:kJPFServiceErrorNotification object:nil];
    
}

/** 建立连接 */
- (void)jpSetupNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，建立连接。。。");
}

/** 关闭连接 */
- (void)jpCloseNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，关闭连接。。。");
}

/** 注册成功 */
- (void)jpRegisterNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，注册成功。。。");
}

/** 登录成功 */
- (void)jpLoginNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，登录成功。。。");
    [MQGlobalObject sharedInstance].JPushRegistrationID = [JPUSHService registrationID];

}

/** 收到自定义消息（非APNS） */
- (void)jpReceiveMessageNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，收到自定义消息。。。");
}

/** 连接中 */
- (void)jpConnectingNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，连接中。。。");
}

/** 错误提示 */
- (void)jpServiceErrorNotification:(NSNotification *)notification
{
    NSLog(@"极光推送，错误提示。。。");
}

#pragma mark - Init remote notification

- (void)initRemoteNotification:(NSDictionary*)appStartupLaunchOptions
{
    // 注册消息推送
    if (IS_OS_8_OR_LATER) {
        // 极光推送
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        // 极光推送
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    // 极光推送
    NSString *jpAppKey = @"0c7c3d1865f368194f572a06";
    BOOL jpIsProduction = YES;//[ENV.jpIsProduction boolValue];
    [JPUSHService setupWithOption:appStartupLaunchOptions appKey:jpAppKey channel:@"apple store" apsForProduction:jpIsProduction];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo forApplication:(UIApplication *)application
{
    [JPUSHService handleRemoteNotification:userInfo];
    [application setApplicationIconBadgeNumber:0];
    
    // 前台运行
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成对话框
        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *title = [userInfo objectForKey:@"title"];
        MQAlertView *alertView = [[MQAlertView alloc] initwithMessage:message];
        [alertView addButtonWithTitle:@"取消" block:^(MQAlertView *alertView) {
        }];
        [alertView addButtonWithTitle:@"查看" block:^(MQAlertView *alertView) {
            [self handlePushNotification:userInfo];
        }];
        [alertView showWithTitle:([title length] ? title : @"温馨通知")];
    } else if (application.applicationState == UIApplicationStateInactive) {
        [self handlePushNotification:userInfo];
    }
}



// APP在前台或者后台运行，接到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo forApplication:application];
}

/** ios7.0及以上调用此方法 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [self handleRemoteNotification:userInfo forApplication:application];
    completionHandler(UIBackgroundFetchResultNewData);
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 极光推送
    [JPUSHService registerDeviceToken:deviceToken];
    
    // app相关处理
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [MQAppHelper sharedInstance].deviceToken = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notificaiton with error: %@", error);
}

#pragma mark - Internal methods


// 处理推送消息
- (void)handlePushNotification:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo)) {
        NSString *toString = [userInfo objectForKey:@"action"];
        if (CHECK_VALID_STRING(toString)) {
            if (![toString hasPrefix:ENV.appScheme]) {
                toString = [ENV.appScheme stringByAppendingString:toString];
            }
            NSURL *url = [NSURL URLWithString:toString];
            if ([[url absoluteString] hasPrefix:ENV.appScheme]) {
            }
        }
    }
}

@end

@implementation UIApplication (MQAdditions)

- (UIViewController *)topViewController
{
    MQTabContainerController *containerCtrl = (MQTabContainerController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    if ([containerCtrl isKindOfClass:MQTabContainerController.class]) {
        return containerCtrl.currentNavigationController.viewControllers.lastObject;
    } else {
        return nil;
    }
}

@end
