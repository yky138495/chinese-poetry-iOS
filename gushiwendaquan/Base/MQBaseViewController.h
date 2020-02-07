//
//  MQBaseViewController.h
//  MQKeep
//
//  Created by yangmengge on 2018/5/13.
//  Copyright © 2018年 MQAI. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MQ_BARBUTTON_ITEM_FRAME CGRectMake(0.f, 0.f, 25.f, 25.f)
#define MQ_VIEW_GUIDE_TIME 5.0     //蒙版显示的时间
#define MQ_PAGE_SIZE 1     //蒙版显示的时间

// 通知
extern NSString * const MQApplicationLogoutActionNotification;


// 左导航按钮返回类型
typedef enum : NSUInteger {
    MQLeftBarButtonBackToRoot,
    MQLeftBarButtonBackToPrevious,
    MQLeftBarButtonCloseToNormal,
    MQLeftBarButtonCloseRegister
    
} MQLeftBarButtonBackType;

// 右导航按钮动作类型
typedef enum : NSUInteger {
    MQRightBarButtonActionDismiss,
    MQRightBarButtonActionProblems,
} MQRightBarButtonActionType;


@interface MQBaseViewController : UIViewController

// 是否直接返回到root
@property (nonatomic, assign) BOOL backToRoot;
// 是否需要侧滑返回，默认YES
@property (nonatomic, assign) BOOL enableInteractivePopGesture;
// 是否隐藏导航栏
@property (nonatomic, assign) BOOL isHideNavigationBar;
// 返回到指定的上级控制器
@property (nonatomic, strong) UIViewController *backViewController;

// 是否加载过
@property (nonatomic, assign, readonly) BOOL isLoaded;
// 页面刷新
- (void)requestIndex;
- (void)setRefreshed;
- (void)setNeedsRefresh;

// 错误处理
- (void)handleInputError:(MQError *)error;
- (void)handleInputError:(MQError *)error withTitle:(NSString *)title;
- (void)handleRequestError:(MQError *)error;
- (void)handleRequestError:(MQError *)error withTitle:(NSString *)title;

// 初始化风格
- (void)setStyle;

// 初始化导航按钮
- (void)setNavigationBarButtonItems;

// 设置左导航按钮类型
- (void)setLeftBarButtonItem:(MQLeftBarButtonBackType)backType;

// 设置右导航按钮类型
- (void)setRightBarButtonItem:(MQRightBarButtonActionType)actionType;

//左导航按钮点击事件
- (void)backButtonClicked:(id)sender;

- (UIView *)creatNoDataScreenView;
- (UIView *)creatNoDataView:(NSString *)content;
- (UIView *)creatNoDataView:(CGRect)rect content:(NSString *)content;

- (void)tapBackground;

@end
