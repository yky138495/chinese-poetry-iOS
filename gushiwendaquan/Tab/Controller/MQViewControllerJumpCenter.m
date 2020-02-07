//
//  MQViewControllerJumpCenter.m
//  MQAI
//
//  Created by ymg on 15/1/28.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQViewControllerJumpCenter.h"
#import "MQWebViewController.h" // 网页

#import "AppDelegate.h"
// 网络请求
#import "MQTabContainerController.h"

#define MQ_SCHEMA_URL(_url)  ([@"MQAPP://" stringByAppendingString:_url])


@implementation MQViewControllerJumpCenter

IMP_SINGLETON(MQViewControllerJumpCenter);

//MQAPP://malldetail?productid='**'&title='**'

- (NSDictionary *)schemaDict
{
    return @{
             MQ_SCHEMA_URL(@"share"):@"shareAction",//分享
             };
}


/** 根据传入的url，控制url跳转 */
- (void)jumpWithOpenUrl:(NSString *)openUrl
{
    if (openUrl.length) {
        self.openUrl = openUrl;
        if ([openUrl hasPrefix:@"MQAPP://"]) {
            // 查询是否存在于我们的schema字典中，如果存在就执行相应的操作
            NSString *schema = openUrl;
            NSRange range = [schema rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                schema = [schema substringToIndex:range.location];
            }
            NSString *selName = [[self schemaDict] mqai_stringForKey:schema];
            
            if (selName.length) {
                SEL selector  = NSSelectorFromString(selName);
                if ([self respondsToSelector:selector]) {
                    MQ_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:selector];);
                }
            }
        } else if ([openUrl hasPrefix:@"http"]) {
            // 跳转到WebView页面
            MQWebViewController *ctrl = [MQWebViewController new];
            ctrl.url = openUrl;
            [self pushNewCtrl:ctrl];
        }
    }
}

- (void)jumpWithOpenUrlNotification:(NSNotification *)notification
{
    if (notification.object) {
        NSString *urlStr = @"";
        if ([notification.object isKindOfClass:[NSURL class]]) {
            urlStr = [(NSURL *)notification.object description];
        }
        if ([notification.object isKindOfClass:[NSString class]]) {
            urlStr = notification.object;
        }
        
    
        [self jumpWithOpenUrl:urlStr];
    }
}

/** 页面跳转 */
- (void)pushCtrl:(UIViewController *)ctrl
{
    UIViewController *topCtrl = [[MQAppHelper sharedInstance] topViewController];
    if (topCtrl.navigationController) {
  
        
        [topCtrl.navigationController pushViewController:ctrl animated:YES];
        if (topCtrl.navigationController.isNavigationBarHidden) {
            [topCtrl.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}

/** push一个新页面 */
- (void)pushNewCtrl:(UIViewController *)ctrl
{
    UIViewController *topCtrl = [self topCtrl];
    if (topCtrl.navigationController) {
        [topCtrl.navigationController pushViewController:ctrl animated:YES];
    }
}

/** present一个新页面 **/
- (void)presentNewCtrl:(UIViewController *)ctrl
{
    UIViewController *topCtrl = [self topCtrl];
    if (topCtrl.navigationController) {
        [topCtrl.navigationController presentViewController:ctrl animated:YES completion:nil];
    } else {
        [topCtrl presentViewController:ctrl animated:YES completion:nil];
    }
}

- (MQBaseViewController *)topCtrl
{
    return (MQBaseViewController *)[[MQAppHelper sharedInstance] topViewController];
}



#pragma mark - url 跳转控制

- (void)selectTabAction
{
    NSDictionary *params = [MQStringUtil paramsForUrl:self.openUrl];
    NSString *tabName = MQ_SAFE_STRING([params mqai_stringForKey:@"tab"]);
    NSUInteger tabIndex = 0;
  
    [[MQTabContainerController sharedInstance] selectTab:tabIndex complete:nil];
}

@end
