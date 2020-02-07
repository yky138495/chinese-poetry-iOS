//
//  MQTabContainerController.m
//  MQReader
//
//  Created by yangmengge on 2019/1/2.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import "MQTabContainerController.h"

#import "GSMeViewController.h"
#import "GSHomeViewController.h"
#import "MQNavigationController.h"

@interface MQTabContainerController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *tabNavsArr;
@property (nonatomic, copy)   NSString *mallURLStr;

@property (nonatomic, strong) MQNavigationController *homeNav;
@property (nonatomic, strong) MQNavigationController *accountNav;

@end

@implementation MQTabContainerController

IMP_SINGLETON(MQTabContainerController);

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    [self initNavigationController];
    
    self.homeNav.tabBarItem.tag = 0;
    self.accountNav.tabBarItem.tag = 1;
    self.tabNavsArr = [NSArray arrayWithObjects:self.homeNav,self.accountNav, nil];
    [self setViewControllers:self.tabNavsArr];
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#3B454E"]};
    NSDictionary *textSelectAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#268BEA"]};
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:textSelectAttributes forState:UIControlStateSelected];
}

- (void)showNormalTab
{
    self.accountNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[MQ_IMAGE(@"tab04_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[MQ_IMAGE(@"tab04") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.tabNavsArr = [NSArray arrayWithObjects:self.homeNav,self.accountNav, nil];
    [self setViewControllers:self.tabNavsArr];
    self.tabType = MQTabContainerNormal;
    
}

- (void)initNavigationController
{
    GSHomeViewController *homeController = [[GSHomeViewController alloc] init];
    GSMeViewController *meViewController = [[GSMeViewController alloc] init];
    
    self.homeNav = [[MQNavigationController alloc] initWithRootViewController:homeController];
    self.accountNav = [[MQNavigationController alloc] initWithRootViewController:meViewController];
    
    self.homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"古诗文" image:[MQ_IMAGE(@"novel_main_unselect.png") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[MQ_IMAGE(@"novel_main_select.png") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //
    self.accountNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[MQ_IMAGE(@"novel_my_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[MQ_IMAGE(@"novel_my_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)selectTab:(NSInteger)index complete:(void (^)(MQNavigationController *naviController))complete
{
    if (index == 1) {
        [self trySelectAccountTabWithComplete:complete index:index];
    }else{
        self.selectedIndex = index;
        if (complete) {
            complete([self.tabNavsArr safeObjectAtIndex:index]);
        }
    }
}

- (MQNavigationController *)currentNavigationController
{
    return [self.tabNavsArr safeObjectAtIndex:self.selectedIndex];
}

- (void)trySelectAccountTabWithComplete:(void (^)(MQNavigationController *naviController))complete index:(NSUInteger)index
{
   
        self.selectedIndex = index;
        if (complete) {
            complete([self.tabNavsArr safeObjectAtIndex:index]);
        }
}

- (void)loginNotificationAction:(NSNotification *)notification
{
    
}

- (void)logoutNotificationAction:(NSNotification *)notification
{
   
    
}

#pragma mark - Tabbar delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end

