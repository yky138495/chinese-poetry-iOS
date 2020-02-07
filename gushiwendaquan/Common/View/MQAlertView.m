//
//  MQAlertView.m
//  MQKeep
//
//  Created by yangmengge on 2018/6/7.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import "MQAlertView.h"
#import "UIImage+Additions.h"

#define AlertScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static UIWindow *_alertWindow = nil;

@interface MQAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *buttonBlockArray;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIScrollView *labelScrollView;
@property (nonatomic, assign) CGFloat offsetHeight;
@property (nonatomic, strong) NSMutableArray *buttonTitleArray;


@end

@implementation MQAlertView

- (instancetype)initwithMessage:(NSString *)message
{
    return [self initWithTitle:@"" message:message style:MQAlertInfo];
}

- (instancetype)initwithMessage:(NSString *)message style:(MQAlertViewStyle)style
{
    return [self initWithTitle:@"" message:message style:style];
}

- (instancetype)initWithMessage:(NSString *)message controller:(UIViewController *)controller style:(MQAlertViewStyle)style
{
    self = [self initWithTitle:@"" message:message style:style];
    if (self) {
        self.controller = controller;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    return [self initWithTitle:title message:message style:MQAlertInfo];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(MQAlertViewStyle)alertStyle;
{
    self = [super init];
    if (self) {
        
        if (_alertWindow == nil) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_alertWindow addGestureRecognizer:tap];
        self.rootViewController = [[UIViewController alloc] init];
        _alertWindow.rootViewController = self.rootViewController;
        self.backgroundColor = [UIColor whiteColor];
        self.center = _alertWindow.center;
        [self.rootViewController.view addSubview:self];
        self.rootViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = 4.0f;
        
        self.title = title;
        self.message = message;
        
        self.alertViewStyle = alertStyle;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.text = self.title;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 100;
        self.messageLabel.text = self.message;
        [self addSubview:self.messageLabel];
        
        self.buttonArray = [[NSMutableArray alloc] init];
        self.buttonBlockArray = [[NSMutableArray alloc] init];
        self.buttonTitleArray = [[NSMutableArray alloc] init];
        
        self.layer.masksToBounds = YES;
        
        self.labelScrollView = [UIScrollView new];
        
        [self addSubview:self.labelScrollView];
        
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)relayoutViews
{
    [self layoutTitleLabel];
    [self layoutContentView];
    [self layoutButtons];
    [self layoutSelf];
    if (self.isShowCloseBtn) {
        [self createCloseBtn];
    }
}

- (void)layoutTitleLabel
{
    WS(alertself);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertself).with.offset(20);
        make.centerX.equalTo(alertself);
        make.width.equalTo(@150);
    }];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = MQ_FONT_L2;
    self.titleLabel.textColor = MQ_COLOR_FONT_DARK;
    
    NSString *str = @"";
    if (self.titleTextAttributes) {
        str = self.titleTextAttributes.string;
        self.titleLabel.attributedText = self.titleTextAttributes;
    } else {
        str = self.title;
        self.titleLabel.text = self.title;
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(290-MQ_UI_MARGIN*2, LINE_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    self.offsetHeight +=  rect.size.height + 22;
}

- (void) layoutMessageLabel
{
    self.messageLabel.frame = CGRectMake(0, 0, AlertScreenWidth - 120, 1);
    [self.messageLabel sizeToFit];
    
    CGRect rect = self.messageLabel.frame;
    WS(alertself);
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.centerX.equalTo(alertself);
        make.width.equalTo(@(rect.size.width));
        make.height.equalTo(@(rect.size.height));
    }];
    
    self.offsetHeight += rect.size.height;
}


- (void)layoutContentView
{
    WS(alertself);
    if (self.contentView) {
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertself.titleLabel.mas_bottom);
            make.centerX.equalTo(alertself);
            make.width.equalTo(alertself);
            make.height.equalTo(@(alertself.contentView.frame.size.height));
        }];
        self.offsetHeight +=  self.contentView.frame.size.height + 2;
    } else {
        self.contentView = [[UIView alloc] init];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertself.messageLabel.mas_bottom).with.offset(10);
            make.centerX.equalTo(alertself);
            make.width.equalTo(@1);
            make.height.equalTo(@1);
        }];
        self.offsetHeight +=  1;
    }
}

- (void)layoutContentLable
{
    self.labelScrollView.showsHorizontalScrollIndicator = NO;
    self.labelScrollView.showsVerticalScrollIndicator = NO;
    
    NSAttributedString *attributedText = self.contentLabel.text ? [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:@{NSFontAttributeName: self.titleLabel.font}] : nil;
    CGRect lableRect = [attributedText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, LINK_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    WS(alertself);
    if (self.contentLabel) {
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.numberOfLines = 0;
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setAlignment:NSTextAlignmentJustified];
        ps.lineHeightMultiple = 1.5f;
        ps.firstLineHeadIndent = 0.1f;
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:ps};
        NSMutableAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithString:self.contentLabel.text attributes:attribs];
        
        
        self.contentLabel.attributedText = attributedText;
        self.labelScrollView.scrollEnabled = YES;
        
        if (lableRect.size.height > 300) {
            
            [self.labelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertself.contentView.mas_bottom).with.offset(5);
                make.left.equalTo(alertself).with.offset(15);
                make.right.equalTo(alertself).with.offset(-15);
                make.height.equalTo(@300);
            }];
            
            [self.labelScrollView addSubview:self.contentLabel];
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(alertself.labelScrollView);
                make.width.equalTo(alertself.labelScrollView);
            }];
            
        } else {
            
            self.labelScrollView.scrollEnabled = NO;
            [self.labelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertself.contentView.mas_bottom).with.offset(10);
                make.left.equalTo(alertself).with.offset(15);
                make.right.equalTo(alertself).with.offset(-15);
                make.height.equalTo(@(lableRect.size.height));
            }];
            
            [self.labelScrollView addSubview:self.contentLabel];
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertself.labelScrollView);
                make.left.equalTo(alertself).with.offset(15);
                make.right.equalTo(alertself).with.offset(-15);
                make.height.equalTo(@(lableRect.size.height));
            }];
        }
    } else {
        
        [self.labelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertself.contentView.mas_bottom).with.offset(10);
            make.left.equalTo(alertself).with.offset(15);
            make.right.equalTo(alertself).with.offset(-15);
            make.height.equalTo(@(1));
        }];
        
        
    }
    
}

- (void)layoutButtons
{
    WS(alertself);
    NSInteger buttonCount = self.buttonArray.count;
    if (buttonCount == 1) {
        UIButton *button = self.buttonArray.firstObject;
        [button setBackgroundColor:MQ_COLOR_FONT_COOL];
        [button setTitleColor:MQ_COLORWITHCODE(@"#FFFFFF") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:MQ_COLORWITHCODE(@"#FFFFFF")] forState:UIControlStateHighlighted];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertself.contentView.mas_bottom).with.offset(5);
            make.left.right.equalTo(alertself);
            make.height.equalTo(@46);
        }];
    } else  {
        
        UIButton *button1 = self.buttonArray.firstObject;
        if (button1 == nil) {
            
            button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setTitle:@"取消" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button1];
        }
        
        [button1 setTitleColor:MQ_COLORWITHCODE(@"#5462EB") forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageWithColor:MQ_COLORWITHCODE(@"#FFFFFF")] forState:UIControlStateHighlighted];
        
        UIButton *button2 = self.buttonArray.lastObject;
        
        if (button2 == nil) {
            
            button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button2 setTitle:@"确定" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button2];
            [self addSubview:button2];
            
        }
        [button2 setTitleColor:MQ_COLORWITHCODE(@"#5462EB") forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageWithColor:MQ_COLORWITHCODE(@"#FFFFFF")] forState:UIControlStateHighlighted];
        
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertself.contentView.mas_bottom).with.offset(5);
            make.left.equalTo(alertself).with.offset(0);
            make.right.equalTo(button2.mas_left).with.offset(0);
            make.height.equalTo(@44);
        }];
        
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(button1);
            make.top.equalTo(button1);
            make.right.equalTo(alertself).with.offset(0);
            make.height.equalTo(@44);
        }];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = MQ_COLORWITHCODE(@"#EEEEEE");
        [self addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button1.mas_top).with.offset(-1);
            make.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = MQ_COLORWITHCODE(@"#EEEEEE");
        [self addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.height.equalTo(button1);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            
        }];
    }
    self.offsetHeight += 45 + 2;
}

- (void)layoutSelf
{
    WS(alertself);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertself.rootViewController.view);
        make.width.equalTo(alertself.rootViewController.view).dividedBy(4.f/3.f);
        make.height.equalTo(@(self.offsetHeight));
    }];
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self addSubview:_contentView];
}


- (void)setTitleTextAttributes:(NSAttributedString *)titleTextAttributes
{
    _titleTextAttributes = titleTextAttributes;
    self.titleLabel.attributedText = titleTextAttributes;
}


- (void)setMessageTextAttributes:(NSAttributedString *)messageTextAttributes
{
    _messageTextAttributes = messageTextAttributes;
    self.messageLabel.attributedText = messageTextAttributes;
}

- (void)tapAction
{
    [_alertWindow endEditing:YES];
}

#pragma mark - 增加一个按钮的方法
- (void)addButtonWithTitle:(NSString *)title block:(MQAlertViewButtonBlock)block
{
    
    if (CHECK_VALID_STRING(title)) {
        
        [self.buttonTitleArray safeAddObject:title];
    } else {
        NSAssert(NO, @"title 不能为空");
    }
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArray addObject:button];
    button.layer.masksToBounds = YES;
    
    button.tag = self.buttonArray.count;
    
    if (block) {
        [self.buttonBlockArray safeAddObject:[block copy]];
    } else {
        [self.buttonBlockArray safeAddObject:[NSNull null]];
    }
    
    [self addSubview:button];
}
- (void)buttonClick:(UIButton *)sender
{
    @try {
        if (self.buttonBlockArray && [self.buttonBlockArray isKindOfClass:[NSArray class]] && [self.buttonBlockArray count]) {
            
            NSInteger buttonTag = sender.tag;
            MQAlertViewButtonBlock block = [self.buttonBlockArray safeObjectAtIndex:buttonTag-1];
            if (block && ![block isEqual:[NSNull null]]) {
                block(self);
            }
            if (!self.isCustomStyle) {
                [self dismiss];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"MQAlertView buttonClick exception: %@",exception);
    } @finally {
        [self dismiss];
    }
}

- (void)createCloseBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:MQ_IMAGE(@"Common/button_close.png") forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-12);
    }];
}

- (void)performAnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.25;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.01],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [self.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.rootViewController.view.layer addAnimation:fadeInAnimation forKey:@"opacity"];
}

#pragma mark - 展示和关闭的方法

- (void)show
{
    [self showWithTitle:@"提示"];
}

- (void)showWithTitle:(NSString *)title
{
    self.title = title;
    
    if (!CHECK_VALID_ARRAY(self.buttonTitleArray)) {
        self.buttonTitleArray = [[NSMutableArray alloc] init];
        [self.buttonTitleArray safeAddObject:@"取消"];
        [self.buttonTitleArray safeAddObject:@"确认"];
    }
    
    if (self.isCustomStyle){
        [self relayoutViews];
        [_alertWindow makeKeyAndVisible];
    }else{
        [self showAlertController];
    }
}

/** 系统弹窗 */
- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (CHECK_VALID_ARRAY(self.buttonTitleArray)) {
        for (NSString *btnTitle in self.buttonTitleArray) {
            [alertView addButtonWithTitle:btnTitle];
        }
    }
    alertView.delegate = self;
    [alertView show];
}

- (void)showAlertController
{
    if (IS_OS_8_OR_LATER && self.controller) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];
        if (CHECK_VALID_ARRAY(self.buttonTitleArray)) {
            for (NSInteger index = 0; index < self.buttonTitleArray.count; index++) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:self.buttonTitleArray[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MQAlertViewButtonBlock block = [self.buttonBlockArray safeObjectAtIndex:index];
                    
                    if (block && ![block isEqual:[NSNull null]]) {
                        block(self);
                    }
                }];
                
                [alertCtrl addAction:action];
            }
        }
        
        if (self.alertViewStyle == MQAlertContentLeft) {
            [self listAlertControllerView:alertCtrl.view];
        }
        
        [self.controller presentViewController:alertCtrl animated:YES completion:nil];
    } else {
        [self showAlertView];
    }
}

- (void)listAlertControllerView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            if ([label.text isEqualToString:self.message]) {
                switch (self.alertViewStyle) {
                    case MQAlertContentLeft:
                        label.textAlignment = NSTextAlignmentLeft;
                        break;
                    default:
                        break;
                }
                return;
            }
        }
        if (subView.subviews.count > 0) {
            [self listAlertControllerView:subView];
        }
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MQAlertViewButtonBlock block = [self.buttonBlockArray safeObjectAtIndex:buttonIndex];
    
    if (block && ![block isEqual:[NSNull null]]) {
        block(self);
    }
}

- (void)dismiss
{
    _alertWindow.windowLevel = -100;
    _alertWindow = nil;
    
}

@end


@implementation MQAlertViewFactory

+ (MQAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    MQAlertView *alertView = [[MQAlertView alloc] initWithTitle:@"" message:message style:MQAlertContentWarning];
    [alertView addButtonWithTitle:@"确定" block:^(MQAlertView *alertView) {
        [alertView dismiss];
    }];
    
    [alertView show];
    
    return alertView;
}

+ (MQAlertView *)showPromptAlertViewWithMessage:(NSString *)message
{
    return [self showAlertViewWithTitle:[MQAppHelper sharedInstance].appBundleName message:message];
}

@end

