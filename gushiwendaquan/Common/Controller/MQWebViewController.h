//
//  MQWebViewController.h
//  MQAI
//
//  Created by yang mengge on 15/1/23.
//  Copyright (c) 2015年 ymg. All rights reserved.
//


@interface MQWebViewController : MQBaseViewController

@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, assign) BOOL isFromStoryboard;
// 展示的url
@property (nonatomic, strong) NSString *url;
// 本地html名字
@property (nonatomic, strong) NSString *localHtml;
// 网页上要post过去的值
@property (nonatomic, strong) NSDictionary *postParams;
// 是否展示原生转标，默认YES
@property (nonatomic, assign) BOOL showNativeIndicator;

@property (nonatomic, copy) NSString *adbString;//传完整的路径
@property (nonatomic, copy) NSString *talkDataString;
@property (nonatomic, assign) BOOL backDirect;


//
- (void)loadWithURLString:(NSString *)urlString;

@end
