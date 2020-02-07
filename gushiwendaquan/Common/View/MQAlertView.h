//
//  MQAlertView.h
//  MQKeep
//
//  Created by yangmengge on 2018/6/7.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MQAlertView;

typedef void(^MQAlertViewButtonBlock)(MQAlertView *alertView);

typedef NS_ENUM(NSInteger, MQAlertViewStyle)
{
    MQAlertSuccess,
    MQAlertError,
    MQAlertWarning,
    MQAlertContentSuccess,
    MQAlertContentError,
    MQAlertContentWarning,
    MQAlertInfo,  //没有图片
    MQAlertContentLeft, // 文案居左显示
};

@interface MQAlertView : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSAttributedString *titleTextAttributes;

@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSAttributedString *messageTextAttributes;

@property(nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIViewController *controller;

@property (assign, nonatomic) MQAlertViewStyle alertViewStyle;
@property (nonatomic, assign) BOOL isCustomStyle;
@property (nonatomic, assign) BOOL isShowCloseBtn;

- (instancetype)initwithMessage:(NSString *)message;
- (instancetype)initwithMessage:(NSString *)message style:(MQAlertViewStyle)style;
- (instancetype)initWithMessage:(NSString *)message controller:(UIViewController *)controller style:(MQAlertViewStyle)style;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message style:(MQAlertViewStyle)alertStyle;

//最多两个按钮
- (void)addButtonWithTitle:(NSString *)title block:(MQAlertViewButtonBlock)block;

- (void)show;
- (void)dismiss;
- (void)showWithTitle:(NSString *)title;

@end


@interface MQAlertViewFactory : NSObject

+ (MQAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (MQAlertView *)showPromptAlertViewWithMessage:(NSString *)message;

@end
