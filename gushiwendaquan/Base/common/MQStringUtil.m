//
//  MQStringUtil.m
//  MQAI
//
//  Created by yang mengge on 15/1/5.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#import "MQStringUtil.h"
#import "RegexKitLite.h"

@implementation MQStringUtil

+ (NSString *)uuid
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidString;
}

+ (double) doubleMoneyFromString:(NSString *)money
{
    if(CHECK_VALID_STRING(money)){
        money = [money stringByReplacingOccurrencesOfRegex:@"," withString:@""];
        return [money doubleValue];
    } else{
        return 0.00;
    }
}

/**
 *判断字符串是否是汉字
 */
+ (BOOL)hasChinese:(NSString *)chineseStr
{
    if (CHECK_VALID_STRING(chineseStr)) {
        for (NSUInteger i = 0; i < chineseStr.length; i++) {
            NSString *subStr = [chineseStr substringWithRange:NSMakeRange(i, 1)];
            // UTF8编码：汉字占3个字节，英文字符占1个字节
            const char *cStr = [subStr UTF8String];
            if (strlen(cStr) == 3) {
                return YES;
            }
        }
    }
    return NO;
}

//+ (BOOL)isChinese:(NSString *)str
//{
//    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
//    return [predicate evaluateWithObject:str];
//}

/**
 *获取字符串中的汉字个数
 */
+ (NSInteger)chineseCountInString:(NSString *)str
{
    NSInteger count = 0;
    if (str && str.length > 0) {
        for (NSUInteger i = 0; i < str.length; i++) {
            NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
            if ([self hasChinese:subStr]) {
                count++;
            }
        }
    }
    return count;
}

+ (NSString *)formatString:(NSObject *)object
{
    if (object) {
        return object.description;
    }
    return @"";
}

/**
 * 格式化金额，后面自动不上两位小数，格式：000,000.00
 */
+ (NSString *)formatFloatMoney:(NSObject *)object
{
    NSString *money = [object description];
    if (money.length) {
        money = [money stringByReplacingOccurrencesOfRegex:@"[^-|^.|^\\d]" withString:@""];
        money = [NSString stringWithFormat:@"%.2f", money.doubleValue];
        return money;
    }
    return @"0.00";
}
/**
 * 格式化金额  三位加,号 精确到小数点两位
 */
+ (NSString *)formatMoney:(NSObject *)object
{
    if (object) {
        if ([object.description isEqualToString:@"0"] || [object.description isEqualToString:@""]) {
            return @"0.00";
        }
        NSMutableString *money = [NSMutableString stringWithString:[object.description stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        if (NSNotFound == [money rangeOfString:@","].location) {
            NSString *decimal = @"";
            NSRange dotRange = [money rangeOfString:@"."];
            if (NSNotFound != dotRange.location) {
                // 补齐
                NSInteger cnt = money.length - dotRange.location - 1;
                while (cnt++ < 2) {
                    [money appendString:@"0"];
                }
                decimal = [money substringWithRange:NSMakeRange(dotRange.location, 3)];
                money.string = [money substringToIndex:dotRange.location];
            }

            NSInteger length = money.length;
            NSInteger count = length / 3;
            if (length % 3 == 0) {
                count--;
            }
            for (NSInteger i = 1; i <= count; i++) {
                [money insertString:@"," atIndex:length - i*3];
            }
            [money appendString:decimal];
        }
        
        if ([object.description hasPrefix:@"-"]) {
            [money insertString:@"-" atIndex:0];
        }

        return money;
    }
    return @"0.00";
}

+ (NSString *)formatIntegerMoney:(NSObject *)object
{
    if (object) {
        if ([object.description isEqualToString:@"0"] || [object.description isEqualToString:@""]) {
            return @"0";
        }
        NSMutableString *money = [NSMutableString stringWithString:[object.description stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        if (NSNotFound == [money rangeOfString:@","].location) {
            NSString *decimal = @"";
            
            NSRange dotRange = [money rangeOfString:@"."];
            if (NSNotFound != dotRange.location) {
                return @"0";
            }
            NSInteger length = money.length;
            NSInteger count = length / 3;
            if (length % 3 == 0) {
                count--;
            }
            for (NSInteger i = 1; i <= count; i++) {
                [money insertString:@"," atIndex:length - i*3];
            }
            [money appendString:decimal];
        }
        
        if ([object.description hasPrefix:@"-"]) {
            [money insertString:@"-" atIndex:0];
        }
        
        return money;
    }
    return @"0";
}

+ (NSString *)formatMoneyYuan:(NSObject *)object
{
    NSString *formatMoney = [MQStringUtil formatMoney:object];
    NSMutableString *money = [NSMutableString stringWithString:formatMoney];
    [money appendString:@"元"];
    return money;
}

+ (NSMutableAttributedString *)attributedMoneyFromString:(NSString *)rawMoneyString
                                    integerAttributeDict:(NSDictionary *)integerAttributeDict
                                    decimalAttributeDict:(NSDictionary *)decimalAttributeDict
{
    NSString *formattedString = [self formatMoney:rawMoneyString];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:formattedString];
    
    NSRange dotRange = [formattedString rangeOfString:@"."];
    
    NSUInteger intergerLen = (dotRange.location == NSNotFound) ? [formattedString length] : dotRange.location;
    
    // 整数部分
    for (NSString *attributeName in [integerAttributeDict allKeys]) {
        [attriString addAttribute:attributeName
                            value:[integerAttributeDict objectForKey:attributeName]
                            range:NSMakeRange(0, intergerLen)];
    }
    
    // 小数部分（包括小数点）
    if (dotRange.location != NSNotFound) {
        for (NSString *attributeName in [decimalAttributeDict allKeys]) {
            [attriString addAttribute:attributeName
                                value:[decimalAttributeDict objectForKey:attributeName]
                                range:NSMakeRange(dotRange.location, [formattedString length] - dotRange.location)];
        }
    }
    
    return attriString;
}

+ (NSMutableAttributedString *)attributedStringFromRawText:(NSString *)needFormatString
                                   withSubstrAttributeDict:(NSDictionary *)subStringAtributeDict
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:needFormatString];
    if (CHECK_VALID_STRING(needFormatString) && CHECK_VALID_DICTIONARY(subStringAtributeDict)) {
        for (NSString *subString in [subStringAtributeDict allKeys]) {
            NSRange subStringRange = [needFormatString rangeOfString:subString];
            
            NSDictionary *attributeDict = [subStringAtributeDict objectForKey:subString];
            NSUInteger intergerLen = (subStringRange.location == NSNotFound) ? [needFormatString length] : subStringRange.location;
            for (NSString *attributeName in [attributeDict allKeys]) {
                [attriString addAttribute:attributeName
                                    value:[attributeDict objectForKey:attributeName]
                                    range:NSMakeRange(intergerLen, subStringRange.length)];
            }
        }
    }
    return attriString;
}


/**
 * 从加入,号的字符金额得到double
 */
+ (double)floatMoneyFromString:(NSString *)string
{
    if (CHECK_VALID_STRING(string)) {
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        return string.doubleValue;
    } else {
        return 0.00f;
    }
}

/**
 * 从加入,号的字符金额得到Integer
 */
+ (NSInteger)integerMoneyFromString:(NSString *)string
{
    if (CHECK_VALID_STRING(string)) {
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        return string.integerValue;
    } else {
        return 0;
    }
}

/**
 *判断字符串是否中文字符
 */
+ (BOOL) isChinese:(NSString *)validateString
{
//    return [MQStringUtil validateByRegex:@"^[\u4e00-\u9fa5]"];
    return [validateString isMatchedByRegex:@"^[\u4e00-\u9fa5]+$"];
}

/**
 *判断字符串是否包含指定范围的中文字符
 */
+ (BOOL) hasChineseWithMin:(NSString *)validateString min:(NSInteger)min max:(NSInteger)max
{
//    return [self validateByRegex:[NSString stringWithFormat:@"^[\u4e00-\u9fa5]{%ld,%ld}$", (long)min, (long)max]];
    return [validateString isMatchedByRegex:[NSString stringWithFormat:@"^[\u4e00-\u9fa5]{%ld,%ld}$", (long)min, (long)max]];
}

/**
 * 验证手机号码
 */
+ (BOOL)validateMobilePhoneNum:(NSString *)str
{
    BOOL isSuccess = NO;
    if (CHECK_VALID_STRING(str)) {
//        isSuccess = [MQStringUtil validateByRegex:@"^((13[0-9])|(14[5|7])|(15[0|1|2|3|5|6|7|8|9])|(17[6|7|8])|18[0-9])\\d{8}|(170[0|5|9]\\d{7})$"];
        //isSuccess = [str isMatchedByRegex:@"^((13[0-9])|(14[5|7])|(15[0|1|2|3|5|6|7|8|9])|(17[6|7|8])|18[0-9])\\d{8}|(170[0|5|9]\\d{7})$"];
        
        isSuccess = ([str isMatchedByRegex:@"^[0-9]*$"] && str.length == 11);

    }
    return isSuccess;
}

+ (BOOL)validateMobilePhoneLoose:(NSString *)str
{
    BOOL isSuccess = NO;
    if (CHECK_VALID_STRING(str)) {
        isSuccess = ([str isMatchedByRegex:@"^[0-9]*$"] && str.length == 11);
        
    }
    return isSuccess;
}

+ (BOOL)validateZipCode:(NSString *)str
{
    BOOL isSuccess = NO;
    if (CHECK_VALID_STRING(str)) {
        isSuccess = ([str isMatchedByRegex:@"^[0-9]*$"] && str.length == 6);
        
    }else{
        return YES;
    }
    return isSuccess;
}

+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger )value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/**
 * 从身份证获取省份
 */
+ (NSString *)getProviceFromidentityNumber:(NSString *)identityNumber
{
    NSDictionary *locationMapping =  @{
                                       @"11":@"北京",   @"12":@"天津",    @"13":@"河北",
                                       @"14":@"山西",   @"15":@"内蒙古",  @"21":@"辽宁",
                                       @"22":@"吉林",   @"23":@"黑龙江",  @"31":@"上海",
                                       @"32":@"江苏",   @"33":@"浙江",    @"34":@"安徽",
                                       @"35":@"福建",   @"36":@"江西",    @"37":@"山东",
                                       @"41":@"河南",   @"42":@"湖北",    @"43":@"湖南",
                                       @"44":@"广东",   @"45":@"广西",    @"46":@"海南",
                                       @"50":@"重庆",   @"51":@"四川",    @"52":@"贵州",
                                       @"53":@"云南",   @"54":@"西藏",    @"61":@"陕西",
                                       @"62":@"甘肃",   @"63":@"青海",    @"64":@"宁夏",
                                       @"65":@"新疆",   @"71":@"台湾",    @"81":@"香港",
                                       @"82":@"澳门",   @"91":@"国外"
                                       };
    //判断地区码
    NSString * provinceNum = [identityNumber substringToIndex:2];
    return [locationMapping objectForKey:provinceNum];
}

+ (BOOL)areaCode:(NSString *)code
{
    NSDictionary *locationMapping =  @{
                                       @"11":@"北京",   @"12":@"天津",    @"13":@"河北",
                                       @"14":@"山西",   @"15":@"内蒙古",  @"21":@"辽宁",
                                       @"22":@"吉林",   @"23":@"黑龙江",  @"31":@"上海",
                                       @"32":@"江苏",   @"33":@"浙江",    @"34":@"安徽",
                                       @"35":@"福建",   @"36":@"江西",    @"37":@"山东",
                                       @"41":@"河南",   @"42":@"湖北",    @"43":@"湖南",
                                       @"44":@"广东",   @"45":@"广西",    @"46":@"海南",
                                       @"50":@"重庆",   @"51":@"四川",    @"52":@"贵州",
                                       @"53":@"云南",   @"54":@"西藏",    @"61":@"陕西",
                                       @"62":@"甘肃",   @"63":@"青海",    @"64":@"宁夏",
                                       @"65":@"新疆",   @"71":@"台湾",    @"81":@"香港",
                                       @"82":@"澳门",   @"91":@"国外"
                                       };
    return [locationMapping objectForKey:code] == nil ? NO : YES;
}

/**
 * 验证身份证号码
 */
+ (BOOL)check18identityNumber:(NSString *)identityNumber
{
    /*
    if ([identityNumber length] != 18){
        return NO;
    }
    NSString *carid = identityNumber;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','x', '9', '8', '7', '6', '5', '4', '3', '2'};
    NSMutableString *mString = [NSMutableString stringWithString:identityNumber];
    if ([identityNumber length] == 15){
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            p += (pid[i]-48) * R[i];
        
        NSInteger o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince])
        return NO;
    
    //判断年月日是否有效
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil){
        return NO;
    }
    const char* PaperId  = [carid UTF8String];
    // 前17位必须为数字
    for (NSUInteger i=0; i<18; i++){
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) ){
            return NO;
        }
    }
    //验证最末的校验码
    long lSumQT = 0;
    for (int i=0; i<=16; i++){
        lSumQT += (PaperId[i]-48) * R[i];
    }
    return sChecker[lSumQT%11] != PaperId[17] ? NO : YES;*/

    BOOL flag;
    if (identityNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityNumber];
}

/**
 * 密码验证规则
 */
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

/**
 * 用户名验证规则
 */
+ (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    Boolean validateResult = [userNamePredicate evaluateWithObject:name];
    return validateResult;
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/**
 * 验证字符串是否为浮点数
 */
+ (BOOL)validateIsFloatNumberString:(NSString *)number
{
    NSScanner* scan = [NSScanner scannerWithString:number];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 * 判断字符串是否为整数
 */
+ (BOOL)validateIsIntegerNumberString:(NSString *)number
{
    NSScanner* scan = [NSScanner scannerWithString:number];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}
/**
 * 判断字符串是否为正整数
 */
+ (BOOL)validateIsPositiveNumberString:(NSString *)string
{
    BOOL isSuccess = NO;
    if (CHECK_VALID_STRING(string)) {
        isSuccess = [string isMatchedByRegex:@"^[0-9]*$"];
    }
    return isSuccess;
}

+ (BOOL)validateDate:(NSString *)dateString
{
    NSString *dateRegex = @"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:dateRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [regularexpression rangeOfFirstMatchInString:dateString options:NSMatchingReportProgress range:NSMakeRange(0, dateString.length)];

    if (range.location == 0
        && range.length == dateString.length)
    {
        return YES;
    }
    else
    {
        return NO;
    }

}


+ (NSString *)maskPhoneNumber:(NSString *)phoneNumber
{
    if (CHECK_VALID_STRING(phoneNumber)&& phoneNumber.length == 11) {
        NSMutableString *mutableString = [NSMutableString string];
        [mutableString appendString:[self getStringWithRange:phoneNumber Value1:0 Value2:3]];
        [mutableString appendString:@"****"];
        [mutableString appendString:[self getStringWithRange:phoneNumber Value1:7 Value2:4]];
        return mutableString;
    }else{
        return @"";
    }
}

/** 提取url中的参数 */
+ (NSDictionary *)paramsForUrl:(NSString *)url
{
    if (url.length) {
        NSRange range = [url rangeOfString:@"?"];
        if (NSNotFound != range.location) {
            NSString *paramStr = [url substringFromIndex:range.location+range.length];
            NSArray *paramArr = [paramStr componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *str in paramArr) {
                if (CHECK_VALID_STRING(str)) {
                    NSRange ran = [str rangeOfString:@"="];
                    NSString *key = [str substringToIndex:ran.location];
                    NSString *value = [str substringFromIndex:ran.location+ran.length];
                    value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [dict safeSetObject:value forKey:key];
                }
            }
            return dict;
        }
    }
    return nil;
}

+ (NSString *) getBirthdayByIdentityNum:(NSString*)entityNum
{
    NSRange rang = {6, 4};
    NSString* strYear = [entityNum substringWithRange:rang];
    rang.location = 10, rang.length =2;
    NSString* strMonth = [entityNum substringWithRange:rang];
    rang.location = 12;
    NSString* strDay = [entityNum substringWithRange:rang];
    return [NSString stringWithFormat:@"%@-%@-%@", strYear, strMonth, strDay];
}

+ (NSString *)currentTime
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/** 设置加息利率属性字符串 */
+ (NSMutableAttributedString *)formatRateString:(NSString *)rate addRateString:(NSString *)addRate rateFont:(UIFont *)rateFont addRateFont:(UIFont *)addRateFont symbolFont:(UIFont *)symbolFont
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[MQ_SAFE_STRING(rate) stringByAppendingString:MQ_SAFE_STRING(addRate)]];
    
    if (attrStr.length > 0) {
        
        NSString *regex = @"^[\\d.]$";
        BOOL isAdd = NO;
        
        for (int i = 0; i < attrStr.length; i++) {
            NSRange range = NSMakeRange(i, 1);
            id attrValue = nil;
            
            NSString *str = [attrStr.string substringWithRange:range];
            if ([str isMatchedByRegex:regex]) {
                attrValue = isAdd ? addRateFont : rateFont;
            } else {
                attrValue = symbolFont;
            }
            
            if (i == rate.length-1) {
                isAdd = YES;
            }
            
            [attrStr addAttribute:NSFontAttributeName value:attrValue range:range];
        }
    }
    
    return attrStr;
}

//
// Obfuscate / Encrypt a String (NSString)
// http://www.cnblogs.com/KiloNet/archive/2011/01/12/1823480.html
//
// Storing obfuscated secret keys in your iOS app
// http://www.splinter.com.au/2014/09/16/storing-secret-keys/
//
+ (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key
{
    // Create data object from the string
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [data bytes];
    
    // Get pointer to key data
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        // *dataPtr = *dataPtr++ ^ *keyPtr++;
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
