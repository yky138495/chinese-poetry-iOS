//
//  MQTabContainerController.h
//  MQReader
//
//  Created by yangmengge on 2019/1/2.
//  Copyright © 2019 yangmengge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MQTabContainerNormal,
    MQTabContainerRed,
} MQTabContainerType;


@interface MQTabContainerController : UITabBarController


DEF_SINGLETON(MQTabContainerController);

@property (nonatomic, assign) MQTabContainerType  tabType;
@property (nonatomic, strong, readonly) MQNavigationController *currentNavigationController;

- (void)selectTab:(NSInteger)index complete:(void (^)(MQNavigationController *naviController))complete;

- (void)showNormalTab;

@end

NS_ASSUME_NONNULL_END
