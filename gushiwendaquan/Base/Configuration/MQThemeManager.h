//
//  MQThemeManager.h
//  MQAI
//
//  Created by ymg on 14/12/13.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

/**
 使用说明：
 1.添加图片，在所有皮肤下（Themes）添加图片
 2.使用example：self.successImage.image = MQ_IMAGE(@"Borrow/ok_green.png");
 */
#define MQ_IMAGE(imageKey) [UIImage imageNamed:(imageKey)]

#import <Foundation/Foundation.h>


@interface MQThemeManager : NSObject

@property (nonatomic,copy) NSString *currentThemeName;
@property (nonatomic,strong) NSMutableDictionary *themesDictionary;

DEF_SINGLETON(MQThemeManager);

+ (UIImage *)imageNamed:(NSString *)imageName;
- (UIColor *)colorWithKey:(NSString *)colorKey;

/**
 * 根据颜色代码值生成Color
 * @param colorCode 颜色代码<br>
 *              dcdcdc: r:dc, g:dc, b:dc<br>
 *              #dcdcdc: r:dc, g:dc, b:dc<br>
 *              ffdcdcdc: a:ff, r:dc, g:dc, b:dc<br>
 *              #ffdcdcdc: a:ff, r:dc, g:dc, b:dc<br>
 *              fdcdcdc: a:f, r:dc, g:dc, b:dc<br>
 *              #fdcdcdc: a:f, r:dc, g:dc, b:dc<br>
 */
- (UIColor *)colorWithCode:(NSString *)colorCode;


@end
