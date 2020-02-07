//
//  MQNavigationController.m
//  MQKeep
//
//  Created by yangmengge on 2018/5/13.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "MQNavigationController.h"
#import "MQBaseViewController.h"

@interface MQNavigationController ()

@end

@implementation MQNavigationController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    self.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // 自定义导航按钮而导致手势返回失效
    //
    // http://www.cnblogs.com/angzn/p/3696901.html
    //
    //
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

#pragma mark - Title style

- (void)commonInit
{
    //
    // IOS7导航栏适配
    // http://www.tuicool.com/articles/FFJv2eF
    //
    self.navigationBar.translucent = NO;
    //
    // 导航栏半透明在IOS7上，APP切入后台时体验不好（会变黑）
    //
    //#if ENABLE_TRANSLUCENT_BAR
    //    if (IS_OS_7_OR_LATER) {
    //        self.navigationBar.translucent = YES;
    //    }
    //#else
    //    self.navigationBar.translucent = NO;
    //#endif
    
    //
    [self setNavigationBarStyle];
}

- (void)setNavigationBarStyle
{
    UIFont *font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:25];
    self.navigationItem.title = @"";
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSFontAttributeName : font
                                     };
    [self.navigationBar setTitleTextAttributes:textAttributes];
    
    //改变bar 线条颜色
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setShadowImage:img];
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Hijack the push method to disable the gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //push出来的controller不显示tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    for (NSInteger i = 1; i < [viewControllers count]; i++) {
        UIViewController *wCon = [viewControllers objectAtIndex:i];
        wCon.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([navigationController.viewControllers count] == 1) {
        // Disable the interactive pop gesture in the rootViewController of navigationController
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        if ([viewController isKindOfClass:[MQBaseViewController class]]) {
            MQBaseViewController *bvc = (MQBaseViewController *)viewController;
            if (!bvc.enableInteractivePopGesture) {
                navigationController.interactivePopGestureRecognizer.enabled = NO;
                return;
            }else{
                navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
        }
        // Enable the interactive pop gesture
        //navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end
