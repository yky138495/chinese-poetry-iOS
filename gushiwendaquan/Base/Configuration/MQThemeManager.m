//
//  MQThemeManager.m
//  MQAI
//
//  Created by ymg on 14/12/13.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import "MQThemeManager.h"

@implementation MQThemeManager

static NSMutableDictionary *_defaultColorDictionary = nil;
static NSMutableDictionary *_currentColorDictionary = nil;

IMP_SINGLETON(MQThemeManager);

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"plist"];
        self.themesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        self.currentThemeName = @"default";
        
        if (!_defaultColorDictionary) {
            _defaultColorDictionary = [[NSMutableDictionary alloc] initWithDictionary:[self loadColorsByTheme:@"default"]];
        }
        
        //暂时只有default的风格
        _currentColorDictionary = [_defaultColorDictionary copy];
    }
    
    return self;
}

- (NSMutableDictionary *)loadColorsByTheme:(NSString *)themeName
{
    NSString *curTempPath = [self.themesDictionary objectForKey:themeName];
    NSString* curWholePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:curTempPath];
    NSString* curColorFile = [[NSBundle bundleWithPath:curWholePath] pathForResource:@"Color/colors" ofType:@"plist"];
    return [NSMutableDictionary dictionaryWithContentsOfFile:curColorFile];
}

- (UIColor *)colorWithKey:(NSString *)colorKey
{
    return [self colorWithCode:_currentColorDictionary[colorKey]];
}


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
- (UIColor *)colorWithCode:(NSString *)colorCode {
    NSString *cString = [[colorCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理

    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return nil;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] > 8)//去头非十六进制，返回白色
        return nil;
    
    //分别取ARGB的值
    NSRange range;
    range.location = 0;
    range.length = 0;
    
    NSString *aString = @"ff";
    if (cString.length > 6) {
        range.length = (cString.length==7)? 1 : 2;
        aString = [cString substringWithRange:range];
    }
    
    range.location = range.length;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location += 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location += 2;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int a, r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

//获取当前主题下的相应图片信息
+ (UIImage *)imageNamed:(NSString *)imageName
{
    UIImage *wImage = [MQThemeManager imageWithPath:imageName byThemeName:[MQThemeManager sharedInstance].currentThemeName];
    if (!wImage) {
        wImage = [UIImage imageNamed:imageName];
    }
    return wImage;
}

+ (UIImage *)imageWithPath:(NSString *)imageName byThemeName:(NSString *)themeName
{
    UIImage *wImg = nil;
    NSString *curThemePath = [[MQThemeManager sharedInstance].themesDictionary objectForKey:themeName];
    NSString *curWholePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:curThemePath];

    if (curWholePath.length > 0)
    {
        wImg = [UIImage imageWithContentsOfFile:[curWholePath stringByAppendingPathComponent:imageName]];
    }
    return wImg;
}




@end
