//
//  MQBaseViewController.m
//  MQKeep
//
//  Created by yangmengge on 2018/5/13.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "MQBaseViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "UIView+Toast.h"

NSString * const MQApplicationLogoutActionNotification = @"MQApplicationLogoutActionNotification";


@interface MQBaseViewController ()

@property (nonatomic, assign) BOOL refreshed;
@property (nonatomic, assign) BOOL needsRefresh;
@property (nonatomic, assign, readwrite) BOOL isLoaded;
@property (nonatomic, strong) MQNoDataView *noDataView;

- (void)refresh;

- (UIBarButtonItem *)backBarButtonItem;
- (UIBarButtonItem *)closeBarButtonItem;

@end

@implementation MQBaseViewController

#pragma mark - Init

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

#pragma mark - Navigation items

- (void)setBackToRoot:(BOOL)backToRoot
{
    if (_backToRoot != backToRoot) {
        _backToRoot = backToRoot;
        if (_backToRoot) {
            [self setLeftBarButtonItem:MQLeftBarButtonBackToRoot];
        } else {
            [self setLeftBarButtonItem:MQLeftBarButtonBackToPrevious];
        }
    }
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#383E4A"],NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f]}];
    
    if (self.isHideNavigationBar == NO) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            //改变bar 线条颜色
            CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
            CGContextFillRect(context, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.navigationController.navigationBar setShadowImage:img];
            [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        }
    }else{
        if (!self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    
    // 刷新时机
    if (!self.refreshed) {
        [self refresh];
    } else {
        if (self.needsRefresh) {
            self.needsRefresh = NO;
            [self refresh];
        }
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.enableInteractivePopGesture = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    [self setStyle];
    [self setNavigationBarButtonItems];
    
    // Do any additional setup after loading the view.
}

- (UIView *)creatNoDataScreenView
{
    UIView *nodataView = [self creatNoDataView:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) content:@""];
    return nodataView;
}

- (UIView *)creatNoDataView:(NSString *)content
{
    UIView *nodataView = [self creatNoDataView:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)  content:content];
    return nodataView;
}

- (UIView *)creatNoDataView:(CGRect)rect content:(NSString *)content
{
    UIView *footerView = [[UIView alloc] initWithFrame:rect];
    self.noDataView = [[MQNoDataView alloc]init];
    [footerView addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView);
        make.left.right.equalTo(footerView);
        make.bottom.equalTo(footerView).with.offset(-60);
    }];
    self.noDataView.title = content;
    return footerView;
}

- (void)tapBackground
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"%@ didReceiveMemoryWarning ####", self);
}

#pragma mark - Refresh

- (void)refresh
{
    [self requestIndex];
}

- (void)requestIndex
{
    // 由子类实现
}

- (void)setRefreshed
{
    self.isLoaded = YES;
    self.refreshed = YES;
}

- (void)setNeedsRefresh
{
    self.needsRefresh = YES;
}

#pragma mark - Style

- (void)setStyle
{
    // 背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IS_OS_7_OR_LATER) {
        self.edgesForExtendedLayout = (UIRectEdgeAll&~UIRectEdgeTop);
    }
}

#pragma mark - Set button items

- (void)setNavigationBarButtonItems
{
    if (self.presentingViewController ||
        self.navigationController.presentingViewController) {
        [self setLeftBarButtonItem:MQLeftBarButtonCloseRegister];
        if ([self.navigationController.viewControllers count] > 1) {
            [self setLeftBarButtonItem:MQLeftBarButtonBackToPrevious];
        }
    } else {
        if ([self.navigationController.viewControllers count] > 1) {
            [self setLeftBarButtonItem:MQLeftBarButtonBackToPrevious];
        }
    }
}

- (void)setLeftBarButtonItem:(MQLeftBarButtonBackType)backType
{
    switch (backType) {
        case MQLeftBarButtonCloseToNormal:
            self.navigationItem.leftBarButtonItem = [self closeToNormalButtonItem];
            break;
        case MQLeftBarButtonBackToPrevious:
            self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
            break;
        case MQLeftBarButtonCloseRegister:
            self.navigationItem.leftBarButtonItem = [self closeBarButtonItem];
            break;
        default:
            break;
    }
}

- (void)setRightBarButtonItem:(MQRightBarButtonActionType)actionType;
{
    switch (actionType) {
        case MQRightBarButtonActionDismiss:
            self.navigationItem.rightBarButtonItem = [self closeBarButtonItem];
            break;
        default:
            break;
    }
}

#pragma mark - Button items

- (UIBarButtonItem *)backBarButtonItem
{
    UIButton *wBarBtn = [[UIButton alloc] init];
    wBarBtn.frame = MQ_BARBUTTON_ITEM_FRAME;
    [wBarBtn setImage:MQ_IMAGE(@"back") forState:UIControlStateNormal];
    [wBarBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * wBarItem = [[UIBarButtonItem alloc] initWithCustomView:wBarBtn];
    return wBarItem;
}

- (UIBarButtonItem *)closeBarButtonItem
{
    UIButton *wBarBtn = [[UIButton alloc] init];
    wBarBtn.frame = MQ_BARBUTTON_ITEM_FRAME;
    [wBarBtn setImage:MQ_IMAGE(@"back") forState:UIControlStateNormal];
    [wBarBtn addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * wBarItem = [[UIBarButtonItem alloc] initWithCustomView:wBarBtn];
    return wBarItem;
}

- (UIBarButtonItem *)closeToNormalButtonItem
{
    UIButton *wBarBtn = [[UIButton alloc] init];
    wBarBtn.frame = MQ_BARBUTTON_ITEM_FRAME;
    [wBarBtn setImage:MQ_IMAGE(@"back.png") forState:UIControlStateNormal];
    [wBarBtn addTarget:self action:@selector(closeToNomalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * wBarItem = [[UIBarButtonItem alloc] initWithCustomView:wBarBtn];
    return wBarItem;
}


#pragma mark - Button actions

- (void)rootButtonClicked:(id)sender
{
    //
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)backButtonClicked:(id)sender
{
    if (self.backViewController) {
        [self.navigationController popToViewController:self.backViewController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeButtonClicked:(id)sender
{
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)closeToNomalButtonClicked:(id)sender
{
}
#pragma mark - Error handlers


- (void)handleInputError:(MQError *)error
{
    [self handleInputError:error withTitle:NSLocalizedString(@"MQInputErrorMessage", @"输入错误")];
}

- (void)handleInputError:(MQError *)error withTitle:(NSString *)title
{
    if (error) {
        NSString *alertString = title;
        if (error.localizedMessage && error.localizedMessage.length>0) {
            alertString = error.localizedMessage;
        }
        
        if (CHECK_VALID_STRING(title)) {
            [self.view makeToast:alertString];
        }
    }
}

- (void)handleRequestError:(MQError *)error
{
    [self handleRequestError:error withTitle:NSLocalizedString(@"MQServiceErrorMessage", @"服务故障")];
}

- (void)handleRequestError:(MQError *)error withTitle:(NSString *)title
{
    if (error) {
        // 网络连通故障
        if (error.code == MQNSURLErrorDomainConnectErrorCode) {
            // 报错频控
            static NSDate *_theLastErrorTime = nil;
            if (_theLastErrorTime &&
                [[NSDate date] timeIntervalSinceDate:_theLastErrorTime] < 10.f)
                return;
            _theLastErrorTime = [NSDate date];
            //
            [JDStatusBarNotification showWithStatus:@"网络不给力，请稍后再试" dismissAfter:2.f styleName:JDStatusBarStyleWarning];
        }
        // 后台校验错误
        else if (error.code == MQBackendFailureErrorCode) {
            [self handleInputError:error withTitle:@"服务失败"];
        } else if (error.code == MQBackendFrozenAccountErrorCode) {
            [self handleFrozenAccountError:error];
        }else if (error.code == MQBackendServiceDownErrorCode) {
            
        }else if(error.code == MQResponseVerifySignatureErrorCode || error.code == MQAccountReLoginErrorCode){
            __block NSString *alertString = @"登录过期，请重新登录。";
            if (error.localizedMessage && error.localizedMessage.length>0) {
                alertString = error.localizedMessage;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow makeToast:alertString];
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:MQApplicationLogoutActionNotification object:@"0"];
        }else if (error.code != MQNSURLErrorDomainCancelErrorCode) {
            // 其他服务故障，忽略网络中断错误
            //            [JDStatusBarNotification showWithStatus:error.localizedMessage dismissAfter:2.f styleName:JDStatusBarStyleWarning];
        }
    }
}

- (void)handleFrozenAccountError:(MQError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app conformsToProtocol:@protocol(MQAppExtensionProtocol)]) {
        id<MQAppExtensionProtocol> appExt = (id<MQAppExtensionProtocol>)app;
        if ([appExt respondsToSelector:@selector(handleFrozenAccount:)]) {
            [appExt handleFrozenAccount:error];
        }
    }
}

@end
