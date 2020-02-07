//
//  MQUIDefine.h
//  MQAI
//
//  Created by ymg on 14/12/31.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#ifndef MQAI_MQUIDefine_h
#define MQAI_MQUIDefine_h

/**
 
 颜色说明：
 1.app常用颜色
 a.定义：见本文件，如MQ_COLOR_FONT_MAIN
 b.使用example：self.view.backgroundColor = MQ_COLOR_COMMON_BG;
 
 2.模块自定义颜色
 a.添加方法：所有皮肤目录下的color.plist文件中添加键值对，value用16进制颜色值。如key:mqai_color_borrow_label  value:#999999
 b.使用example：self.borrowLabel.textColor = MQ_COLOR(@"key:mqai_color_borrow_label");
 
 */


#include "MQThemeManager.h"
#import "UIFont+MQAdditions.h"
#define MQ_COLOR(colorKey)             [[MQThemeManager sharedInstance] colorWithKey:(colorKey)]
#define MQ_COLORWITHCODE(colorCode)    [[MQThemeManager sharedInstance] colorWithCode:(colorCode)]


//
// 常用颜色
//

// 通用颜色
#define MQ_COLOR_COMMON_BG             MQ_COLOR(@"mqai_color_common_bg")
#define MQ_COLOR_SEPARATOR             MQ_COLOR(@"mqai_color_separator")
#define MQ_COLOR_COMMON_WARM           MQ_COLOR(@"mqai_color_common_warm")
#define MQ_COLOR_COMMON_COOL           MQ_COLOR(@"mqai_color_common_cool")
#define MQ_COLOR_ERROR                 MQ_COLOR(@"mqai_color_error")
#define MQ_COLOR_SUCCESS               MQ_COLOR(@"mqai_color_success")

// 通用字体颜色
#define MQ_COLOR_FONT_DARK             MQ_COLOR(@"mqai_color_font_dark")
#define MQ_COLOR_FONT_MIDDLE           MQ_COLOR(@"mqai_color_font_middle")
#define MQ_COLOR_FONT_LIGHT            MQ_COLOR(@"mqai_color_font_light")
#define MQ_COLOR_FONT_WARM             MQ_COLOR(@"mqai_color_font_warm")
#define MQ_COLOR_FONT_COOL             MQ_COLOR(@"mqai_color_font_cool")
#define MQ_COLOR_FONT_PLACEHOLDER      MQ_COLOR(@"mqai_color_font_placeholder")

// 通用按钮颜色
#define MQ_COLOR_BUTTON_WARM           MQ_COLOR(@"mqai_color_button_warm")
#define MQ_COLOR_BUTTON_COOL           MQ_COLOR(@"mqai_color_button_cool")
#define MQ_COLOR_BUTTON_BORDER_GRAY    MQ_COLOR(@"mqai_color_button_border_gray")
#define MQ_COLOR_BUTTON_INACTIVE       MQ_COLOR(@"mqai_color_button_inactive")


//
// 常用字体
//

//L1字体，
#define MQ_FONT_L1_LARGER         [UIFont mqai_systemFontOfSize:(IS_IPHONE_6_OR_BIGGER?39.f:38.f)]
#define MQ_FONT_L1_LARGER_BOLD    [UIFont mqai_boldSystemFontOfSize:(IS_IPHONE_6_OR_BIGGER?39.f:38.f)]

#define MQ_FONT_L1         [UIFont mqai_systemFontOfSize:(IS_IPHONE_6_OR_BIGGER?29.f:28.f)]
#define MQ_FONT_L1_BOLD    [UIFont mqai_boldSystemFontOfSize:(IS_IPHONE_6_OR_BIGGER?29.f:28.f)]

//
#define MQ_FONT_L2         [UIFont mqai_systemFontOfSize:18.f]
#define MQ_FONT_L2_BOLD    [UIFont mqai_boldSystemFontOfSize:18.f]

//L3字体，
#define MQ_FONT_L3         [UIFont mqai_systemFontOfSize:16.f]
#define MQ_FONT_L3_BOLD    [UIFont mqai_boldSystemFontOfSize:16.f]

//L4字体，列表文案
#define MQ_FONT_L4         [UIFont mqai_systemFontOfSize:15.f]
#define MQ_FONT_L4_BOLD    [UIFont mqai_boldSystemFontOfSize:15.f]

//L5字体，标注文案 备注文案 段落文案等
#define MQ_FONT_L5         [UIFont mqai_systemFontOfSize:13.f]
#define MQ_FONT_L5_BOLD    [UIFont mqai_boldSystemFontOfSize:13.f]

//
// 通用布局
//

#define MQ_UI_MARGIN 15.f
#define MQ_UI_ICON_WIDTH 20.f
#define MQ_UI_BADGE_WIDTH 18.f
#define MQ_UI_AVATAR_WIDTH 64.f
#define MQ_UI_CORNER_RADIUS  3.f
#define MQ_UI_BORDER_WIDTH   1.f
#define MQ_UI_CONTROL_HEIGHT 44.f
#define MQ_UI_SEPERATOR_WIDTH 1.f
#define MQ_UI_BUTTON_TOP_MARGIN 20.f
// 分段控件
#define MQ_SEGMENTED_CONTROL_MARGIN 10.f
#define MQ_SEGMENTED_CONTROL_HEIGHT 35.f

// 表格控件
#define MQ_TABLE_VIEW_CELL_INSETS_LEFT    MQ_UI_MARGIN
#define MQ_TABLE_VIEW_CELL_INSETS_TOP     15.f
#define MQ_TABLE_VIEW_CELL_INSETS_RIGHT   MQ_TABLE_VIEW_CELL_INSETS_LEFT

#define MQ_TABLE_VIEW_CELL_HEIGHT (IS_IPHONE_6_OR_BIGGER?55.f:50.f)
#define MQ_TABLE_VIEW_CELL_LONG_HEIGHT 60.f

#define MQ_UI_SECTION_TITLE_HEIGHT 30.f
#define MQ_TABLE_VIEW_SECTION_HEADER_HEIGHT 15.f
#define MQ_TABLE_VIEW_CELL_IMAGE_WIDTH MQ_UI_ICON_WIDTH
#define MQ_TABLE_CLEAR_HEIGHT 0.0001f

#endif
