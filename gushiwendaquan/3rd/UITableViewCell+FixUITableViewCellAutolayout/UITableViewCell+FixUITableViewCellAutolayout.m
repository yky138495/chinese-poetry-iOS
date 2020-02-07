//
//  UITableViewCell+FixUITableViewCellAutolayout.m
//  RSFYLoan
//
//  Created by ymg on 15/3/27.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "UITableViewCell+FixUITableViewCellAutolayout.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation UITableViewCell (FixUITableViewCellAutolayout)

//
// IOS6.x上UITableViewCell的自动布局有问题
//
// Apparently, UITableViewCell's layoutSubviews implementation does not call super, which is a problem with auto layout.
//
// 参考：
// http://stackoverflow.com/questions/12610783/auto-layout-still-required-after-executing-layoutsubviews-with-uitableviewcel
//
+ (void)load
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.99f) {
        Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
        method_exchangeImplementations(existing, new);
    }
}

- (void)_autolayout_replacementLayoutSubviews
{
    [super layoutSubviews];
    [self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
    [super layoutSubviews];
}

@end
