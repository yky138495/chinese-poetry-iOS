//
//  MQWebViewController.m
//  MQAI
//
//  Created by yang mengge on 15/1/23.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQWebViewController.h"
#import "MQViewControllerJumpCenter.h"
#import <StoreKit/StoreKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MQTabContainerController.h"

@protocol MQWebViewControllerExportMethod <JSExport>


@end

@interface MQWebViewController () <UIWebViewDelegate, SKStoreProductViewControllerDelegate,MQWebViewControllerExportMethod>

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) BOOL isShowShare; // 是否显示分享
@property (nonatomic, assign) BOOL didAppear;
@property (nonatomic, assign) BOOL willJump;
@property (nonatomic, strong) UIView *leftBarView;
@property (nonatomic, strong) UIButton *backBarBtn;
@property (nonatomic, strong) UIButton *barClose;

@end

@implementation MQWebViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.showNativeIndicator = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleStr = self.title;
    self.currentURL = [NSURL URLWithString:self.url];
    [self initView];
    [self createLeftBarButton];
}

- (void)requestIndex
{
    self.myWebView.delegate = self;
    [self doLoadWithURL:self.currentURL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.didAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myWebView stopLoading];
    self.myWebView.delegate = nil;
}

- (void) initView
{
    self.myWebView = [[UIWebView alloc] init];
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.myWebView.backgroundColor = MQ_COLOR_COMMON_BG;
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    @weakify(self);
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.width.height.equalTo(self.view);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [self.myWebView stopLoading];
    self.myWebView.delegate = nil;
    self.myWebView = nil;
}

#pragma mark -

- (void)loadWithURLString:(NSString *)urlString
{
    [self doLoadWithURL:[NSURL URLWithString:urlString]];
}

- (void)doLoadWithURL:(NSURL *)url
{
    [self webView:self.myWebView enableGL:NO];
    if (url) {
        NSLog(@"Start loading url: %@", url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:60.f];
        if (self.postParams) {
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[[self formatPostBody] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [self.myWebView loadRequest:request];
        
    } else if (self.localHtml && self.localHtml.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.localHtml ofType:nil];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }
}

#pragma mark -

- (NSString *) formatPostBody
{
    if (self.postParams) {
        NSMutableString *body = [NSMutableString string];
        if (self.postParams.count > 0) {
            int i = 0;
            for (NSString *key in self.postParams) {
                if (i > 0) {
                    [body appendString:@"&"];
                }
                [body appendString:[NSString stringWithFormat:@"%@=%@", key, [self stringForKey:key]]];
                i++;
            }
        }
        return body;
    }
    return @"";
}

- (NSString *)stringForKey:(NSString *)key
{
    if (key) {
        NSObject *obj = [self.postParams objectForKey:key];
        if (obj) {
            return [obj description];
        }
    }
    return @"";
}

#pragma mark - actions

- (void)backButtonClicked:(id)sender
{
    // 若正在进行scheme跳转，则禁止后退操作
    if (self.willJump) {
        return;
    }
    if (self.backDirect) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([self.myWebView canGoBack]) {
            self.barClose.hidden = NO;
            [self.myWebView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (![self.myWebView canGoBack]) {
        self.myWebView.scrollView.scrollEnabled = NO;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (_showNativeIndicator) {
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self isStoreURL:request.URL]) {
        [self showStoreProductInApp:request.URL];
        
        return NO;
    }
    if ([request.URL.description hasPrefix:ENV.appScheme]) {
        // 视图还未展示时，延迟0.5秒再进行push操作
        self.willJump = YES;
        if (self.didAppear) {
            [[MQViewControllerJumpCenter sharedInstance] jumpWithOpenUrl:request.URL.description];
            self.willJump = NO;
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[MQViewControllerJumpCenter sharedInstance] jumpWithOpenUrl:request.URL.description];
                // 考虑进push动画本身的时间，确保在这个过程中用户无法进行back操作
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.willJump = NO;
                });
            });
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_showNativeIndicator) {
    }
    //JS上下文
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //设置js内的方法为本身的方法
    context[@"mqai_jsinterface"] = self;
    self.myWebView.scrollView.scrollEnabled = YES;
    
    NSString *docTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([webView canGoBack]) {
        self.title = docTitle;
    } else {
        self.title = self.titleStr.length ? self.titleStr:docTitle;
    }
    self.currentURL = webView.request.URL;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)createLeftBarButton
{
    self.leftBarView = [UIView new];
    self.backBarBtn = [[UIButton alloc]init];
    self.barClose = [[UIButton alloc]init];
    [self.leftBarView addSubview:self.backBarBtn];
    [self.leftBarView addSubview:self.barClose];
    self.barClose.hidden = YES;

    self.leftBarView.frame = CGRectMake(0, 0, 70, 40);
    self.backBarBtn.frame = CGRectMake(0, 7.5, 25.f, 25.f);
    self.barClose.frame = CGRectMake(30, 0, 40, 40);

    [self.backBarBtn setImage:MQ_IMAGE(@"back.png") forState:UIControlStateNormal];
    [self.backBarBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.barClose setTitleColor:MQ_COLORWITHCODE(@"#584BFF") forState:UIControlStateNormal];
    self.barClose.titleLabel.font = MQ_FONT_L4;
    [self.barClose setTitle:@"关闭" forState:UIControlStateNormal];
    [self.barClose addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem.customView = self.leftBarView;
}

- (void)closeButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paradiseRightButtonClick:(id)sender
{
    @try {
        [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"alertWindow();"]];
    }
    @catch (NSException *exception) {
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self backButtonClicked:nil];
    }];
}

- (BOOL)isStoreURL:(NSURL *)url
{
    if (url) {
        BOOL result = [url.description rangeOfString:@"itunes.apple.com"].location != NSNotFound;
        return result;
    }
    
    return NO;
}

- (NSString *)appIDFromURL:(NSURL *)url
{
    NSString *appID = @"";
    if (url) {
        NSString *urlStr = url.description;
        NSRange startRange = [urlStr rangeOfString:@"/id"];
        NSRange endRange = [urlStr rangeOfString:@"?"];
        NSInteger startLoc = startRange.location + startRange.length;
        NSInteger endLoc = (endRange.location==NSNotFound?urlStr.length:endRange.location);
        appID = [urlStr substringWithRange:NSMakeRange(startLoc, endLoc-startLoc)];
    }
    
    return appID;
}

- (void)showStoreProductInApp:(NSURL *)url{
    
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    
    if (isAllow != nil) {
        _showNativeIndicator = NO;
        
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        [sKStoreProductViewController.view setFrame:CGRectMake(0, 200, 320, 200)];
        [sKStoreProductViewController setDelegate:self];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:[self appIDFromURL:url]}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    
                                                    if (result) {
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                    }else{
                                                        NSLog(@"error:%@",error);
                                                    }
                                                }];
    }else{
        //低于iOS6的系统版本没有这个类,不支持这个功能
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - MQWebViewControllerExportMethod

- (void)openWeChat
{
    NSString *str =@"weixin://";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)backToHome
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[MQTabContainerController sharedInstance] selectTab:0 complete:nil];
    });
}

/**
 *  从JavaScript接收一个值
 */
- (void)loginAction
{
   
    dispatch_async(dispatch_get_main_queue(), ^{
    
    });
}

- (void)gotoNativeApply:(NSString *)pid
{

    dispatch_async(dispatch_get_main_queue(),^{

    });
}

//进入后台 Crash 修复
typedef void (*CallFuc)(id, SEL, BOOL);
typedef BOOL (*GetFuc)(id, SEL);
-(BOOL)webView:(UIWebView*)view enableGL:(BOOL)bEnable
{
    BOOL bRet = NO;
    do
    {
        Ivar internalVar = class_getInstanceVariable([view class], "_internal");
        if (!internalVar)
        {
            NSLog(@"enable GL _internal invalid!");
            break;
        }
        
        UIWebViewInternal* internalObj = object_getIvar(view, internalVar);
        Ivar browserVar = class_getInstanceVariable(object_getClass(internalObj), "browserView");
        if (!browserVar)
        {
            NSLog(@"enable GL browserView invalid!");
            break;
        }
        
        id webbrowser = object_getIvar(internalObj, browserVar);
        Ivar webViewVar = class_getInstanceVariable(object_getClass(webbrowser), "_webView");
        if (!webViewVar)
        {
            NSLog(@"enable GL _webView invalid!");
            break;
        }
        
        id webView = object_getIvar(webbrowser, webViewVar);
        if (!webView)
        {
            NSLog(@"enable GL webView obj nil!");
        }
        
        if(object_getClass(webView) != NSClassFromString(@"WebView"))
        {
            NSLog(@"enable GL webView not WebView!");
            break;
        }
        
        SEL selector = NSSelectorFromString(@"_setWebGLEnabled:");
        IMP impSet = [webView methodForSelector:selector];
        CallFuc func = (CallFuc)impSet;
        if (func) {
            func(webView, selector, bEnable);
        }
        
        SEL selectorGet = NSSelectorFromString(@"_webGLEnabled");
        IMP impGet = [webView methodForSelector:selectorGet];
        GetFuc funcGet = (GetFuc)impGet;
        BOOL val = YES;
        if (funcGet) {
            val = funcGet(webView, selector);
        }
        bRet = (val == bEnable);
        
    }while(NO);
    
    return bRet;
}

@end
