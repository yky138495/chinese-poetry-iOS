//
//  MQStringUtil.h
//  MQAI
//
//  Created by yang mengge on 15/1/5.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MQ_SAFE_STRING(_string) [MQStringUtil formatString:_string]

@interface MQStringUtil : NSObject
/*
 * 生成UUID
 */
+ (NSString *)uuid;
/**
 * 将带逗号的金额转换成double类型的金额
 */
+ (double) doubleMoneyFromString:(NSString *)money;

//+(BOOL)isChinese;//判断是否是纯汉字
/**
 *判断字符串是否是汉字
 */
+ (BOOL)hasChinese:(NSString *)chineseStr;
/**
 *获取字符串中的汉字个数
 */
+ (NSInteger)chineseCountInString:(NSString *)str;
+ (NSString *)formatFloatMoney:(NSObject *)object;

/**
 *获取数据中的字符串，nil返回空字符串
 */
+ (NSString *)formatString:(NSObject *)object;
/**
 * 格式化金额  三位加,号 精确到小数点两位
 */
+ (NSString *)formatMoney:(NSObject *)object;
/**
 * 格式化整型金额  三位加,号
 */
+ (NSString *)formatIntegerMoney:(NSObject *)object;
/**
 * 格式化金额  三位加,号 精确到小数点两位, 带“元”
 */
+ (NSString *)formatMoneyYuan:(NSObject *)object;
/**
 * 从加入,号的字符金额得到double
 */
+ (double)floatMoneyFromString:(NSString *)string;
/**
 * 从加入,号的字符金额得到Integer
 */
+ (NSInteger)integerMoneyFromString:(NSString *)string;
/**
 * 从11位电话号码中获得如111****1111掩码形式
 */
+ (NSString *)maskPhoneNumber:(NSString *)phoneNumber;
/**
 *  用属性字符串格式化原始金额（不带,号分割的金额字符串）
 *
 *  @param rawMoneyString       原始金额字符串，不带逗号分割
 *  @param integerAttributeDict 整数部分属性字符串设置
 *  @param decimalAttributeDict 小数部分属性字符串设置，包括小数点
 *
 *  @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)attributedMoneyFromString:(NSString *)rawMoneyString
                                    integerAttributeDict:(NSDictionary *)integerAttributeDict
                                    decimalAttributeDict:(NSDictionary *)decimalAttributeDict;
/**
 *判断字符串是否包含指定范围的中文字符
 */
+ (BOOL) hasChineseWithMin:(NSString *)validateString min:(NSInteger)min max:(NSInteger)max;
/**
 *判断字符串是否中文字符
 */
+ (BOOL) isChinese:(NSString *)validateString;
/**
 * 验证手机号码
 */
+ (BOOL )validateMobilePhoneNum:(NSString *)str;
/**
 * 验证手机号码是否为11位数字
 */
+ (BOOL)validateMobilePhoneLoose:(NSString *)str;
/**
 * 验证邮政编码是否为6位数字
 */
+ (BOOL)validateZipCode:(NSString *)str;
/**
 * 从身份证获取省份
 */
+ (NSString *)getProviceFromidentityNumber:(NSString *)identityNumber;
/**
 * 验证身份证号码 包括校验最后一位
 */
+ (BOOL) check18identityNumber:(NSString *)identityNumber;
/**
 * 密码验证规则
 */
+ (BOOL) validatePassword:(NSString *)passWord;
/**
 * 用户名验证规则
 */
+ (BOOL) validateUserName:(NSString *)name;
/**
 * 邮件地址验证规则
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 * 判断字符串是否为浮点数
 */
+ (BOOL)validateIsFloatNumberString:(NSString *)number;

/**
 * 判断字符串是否为整数
 */
+ (BOOL)validateIsIntegerNumberString:(NSString *)number;
/**
 * 判断字符串是否为正整数
 */
+ (BOOL)validateIsPositiveNumberString:(NSString *)string;
/**
 * 判断日期格式是否正确  2008-08-08
 */
+ (BOOL)validateDate:(NSString *)dateString;
/** 提取url中的参数 */
+ (NSDictionary *)paramsForUrl:(NSString *)url;
/**
 * 身份证号码中获取生日  2008-08-08
 */
+ (NSString *)getBirthdayByIdentityNum:(NSString*)entityNum;

/**
 * 获取设备当前时间 格式： yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)currentTime;

/** 设置加息利率属性字符串 */
+ (NSMutableAttributedString *)formatRateString:(NSString *)rate addRateString:(NSString *)addRate rateFont:(UIFont *)rateFont addRateFont:(UIFont *)addRateFont symbolFont:(UIFont *)symbolFont;

+ (NSMutableAttributedString *)attributedStringFromRawText:(NSString *)needFormatString
                                   withSubstrAttributeDict:(NSDictionary *)subStringAtributeDict;

// Obfuscate / Encrypt a String (NSString)
+ (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key;

@end
