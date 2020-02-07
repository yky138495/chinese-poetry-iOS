//
//  MQError.h
//  MQAI
//
//  Created by ymg on 14/12/14.
//  Copyright (c) 2014年 ymg. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// 构造MQ错误对象
//
#define MQ_ERROR(errorCode) [MQError errorWithDomain:MQErrorDomain code:(errorCode) userInfo:nil]
#define MQ_ERROR_USERINFO(errorCode,_userInfo) [MQError errorWithDomain:MQErrorDomain code:(errorCode) userInfo:_userInfo]
#define MQ_ERROR_MESSAGE(errorCode, message) MQ_ERROR_USERINFO((errorCode),([NSDictionary dictionaryWithObject:(message) forKey:@"MQErrorMessageErrorKey"]))


// HTTP状态码基数
#define MQ_ERROR_HTTP_STATUS_CODE_BASE 10000


//
// MQ错误码
//
typedef NS_ENUM(NSInteger, MQErrorCode) {
    //
    // 错误码可以根据范围隔离开，比如
    //
    // 1 - 10000 预留给服务器端
    //
    MQBackendSuccessErrorCode = 100,
    MQBackendFailureErrorCode = 200, // 弱提示
    MQBackendFailureAlertErrorCode = 201, // 强提示
    MQBackendAbnormalErrorCode = 300,
    MQBackendBuyInsufficientErrorCode = 301, //购买时产品剩余额度不足错误
    MQBackendServiceDownErrorCode = 400, // 后台服务停止工作或者不能访问
    MQBackendVerifySignatureErrorCode = 401,
    MQBackendFrozenAccountErrorCode = 601, // 冻结账户
    MQBackendBlacklistAccountErrorCode = 602, // 黑名单账户
    MQAccountReLoginErrorCode = 604, // 重新登录

    
    // 10001    网络通讯错误
    
    /**
     *  NSURLErrorDomain 
     * http://blog.csdn.net/brewdon/article/details/8886760
     *
     */
    MQNSURLErrorDomainErrorCode = 10001,
    
    /**
     *  NSURLErrorDomain
     * 网络连通性相关错误
     *
     * NSURLErrorTimedOut = -1001,
     * NSURLErrorCannotFindHost = -1003,
     * NSURLErrorCannotConnectToHost = -1004,
     * NSURLErrorNetworkConnectionLost = -1005,
     * NSURLErrorDNSLookupFailed = -1006,
     * NSURLErrorNotConnectedToInternet = -1009,
     */
    MQNSURLErrorDomainConnectErrorCode = 10002,
    /*
     * 网络中断
     * NSURLErrorCancelled = -999
    */
    MQNSURLErrorDomainCancelErrorCode = 10003,
    
    // 10099 - 11999 HTTP错误
    
    
    // 12001    响应数据验签失败
    MQResponseVerifySignatureErrorCode = 12001,
    
    // 12002    Mantle转换错误
    MQMTLJSONAdaptorErrorCode = 12002,
    
    
    // 12099 - 12199 表示XXXX
    
    
    // 13001 - 13999  表示 输入数据校验错误
    
    MQInputUserNameEmptyErrorCode = 13001,
    MQInputUserNameFormatErrorCode = 13002,
    MQInputPasswordEmptyErrorCode = 13003,
    MQInputPasswordFormatErrorCode = 13004,
    MQInputEmailAddressEmptyErrorCode = 13005,
    MQInputEmailAddressFormatErrorCode = 13006,
    MQInputIDNumberEmptyErrorCode = 13007,
    MQInputIDNumberFormatErrorCode = 13008,
    MQInputMobilePhoneNumberFormatErrorCode = 13009,
    MQInputMobilePhoneNumberEmptyErrorCode = 13010,
    MQInputMoneyNumberEmptyErrorCode = 13011,
    MQInputMoneyNumberFormatErrorCode = 13012,
    MQInputBankCardNumberEmptyErrorCode = 13013,
    MQInputBankCardNumbeFormatErrorCode = 13014,
    MQInputCityEmptyErrorCode = 13015,
    MQInputCityFormatErrorCode = 13016,
    MQInputDateEmptyErrorCode = 13017,
    MQInputDateFormatErrorCode = 13018,
    MQInputRealNameEmptyErrorCode = 13019,
    MQInputRealNameFormatErrorCode = 13020,

//-----------提现
    MQInputOpenNameEmptyErrorCode = 13021,  // 开户名
    MQInputOpenNameNameFormatErrorCode = 13022,
    MQInputBranchEmptyErrorCode = 13023,  // 开户支行
    MQInputBranchFormatErrorCode = 13024,

    
    //注册登录
    MQInputPasswordFormatSexErrorCode = 13026,
    MQInputPasswordFormatTwentyErrorCode = 13027,
    MQInputPhoneEmptyErrorCode = 13028,
    MQInputPhoneFormatTwentyErrorCode = 13030,
    MQInputPasswordIsEmptyErrorCode = 13029,
    MQInputRePasswordNoEqualErrorCode = 13025,
    
    
    
    
//-----------验证账户
    MQInputAccountNameEmptyErrorCode = 13031,  // 账户名
    MQInputAccountNameFormatErrorCode = 13032,

//-----------绑定电子邮箱
    MQInputOldEmailAddressEmptyErrorCode = 13041,
    MQInputOldEmailAddressFormatErrorCode = 13042,
    MQInputNewEmailAddressEmptyErrorCode = 13043,
    MQInputNewEmailAddressFormatErrorCode = 13044,

//-----------修改登录密码
    MQInputCurrentPasswordEmptyErrorCode = 13051,
    MQInputCurrentPasswordFormatErrorCode = 13052,
    MQInputNewPasswordEmptyErrorCode = 13053,
    MQInputNewPasswordFormatErrorCode = 13054,
    MQInputConfirmPasswordEmptyErrorCode = 13055,
    MQInputConfirmPasswordFormatErrorCode = 13056,




//-----------个人信息
    MQInputitleEmptyErrorCode = 13061,//称谓
    MQInpuEducationalEmptyErrorCode = 13062,//学历
    MQInpuLiveTypeEmptyErrorCode = 13063,//居住类型
    
    MQInpuTimeLaterNowErrorCode = 13065,
    MQInpuTimeBeforeStartErrorCode = 13066,
  
    MQInputLiveAddressEmptyErrorCode = 13068, //居住地址
    MQInputCredentialsAddressEmptyErrorCode = 13069, //证件地址
    MQInputCensusAddressErrorEmptyCode = 13070, //户籍地址
    MQInputDetailAddressErrorEmptyCode = 13071, //详细街道地址
    MQInputDetailAddressFormatErrorCode = 13071,


//-----------联系人信息
    MQInpuMaritalStatusEmptyErrorCode = 13081,//婚姻状况


//-----------我要借款
     //-----净值贷
    MQInputLoanTitleEmptyErrorCode = 13091,//借款标题
    MQInputLoanTitleFormatErrorCode = 13092,
    MQInputLoanAmountEmptyErrorCode = 13093,//借款金额
    MQInputLoanAmountFormatErrorCode = 13094,
    MQInputLoanAPREmptyErrorCode = 13095,//年利率
    MQInputLoanAPRFormatErrorCode = 13096,
    MQInputLoanDescriptionEmptyErrorCode = 13097,//借款描述 MonthlyIncome
    MQInputLoanDescriptionFormatErrorCode = 13098,
      //-----薪金贷
    MQInputLoanMonthlyIncomeEmptyErrorCode = 13099,//月均收入
    MQInputLoanMonthlyIncomeFormatErrorCode = 13100,

//-----------意见反馈
    MQInputFeedbackEmptyErrorCode = 13111,//意见反馈
    MQInputFeedbackFormatErrorCode = 13112,
    
    //-----验证码
    MQInputVerificationCodeEmptyErrorCode = 13113,
    //-----不是原手机号码
    MQInputSelfPhoneNumberFormatErrorCode = 13114,
    //-----验证码不匹配
    MQInputVerificationCodeFormatErrorCode = 13115,
    
    //-----------个人资料
    //详细信息
    MQInputPDetailIdAddressChooseErrorCode = 13116,
    MQInputPDetailIdAddressEmptyErrorCode = 13117,
    MQInputPDetailIdAddressFormatErrorCode = 13118,
    MQInputPDetailLiveAddressChooseErrorCode = 13119,
    MQInputPDetailLiveAddressEmptyErrorCode = 13120,
    MQInputPDetailLiveAddressFormatErrorCode = 13121,
    //联系人信息
    MQInputPDetailImmediateContact1NameEmptyErrorCode = 13122,
    MQInputPDetailImmediateContact1RelationshipChooseErrorCode = 13123,
    MQInputPDetailImmediateContact1PhoneEmptyErrorCode = 13124,
    MQInputPDetailContactNameFormatErrorCode = 13125,
    MQInputPDetailContactPhoneFormatErrorCode = 13126,
    
    // -----------------------------------
    //
    //薪金贷借款金额超出范围
    MQInputSalaryBorrowAmountErrorCode = 13400,
    MQInputLoanDurationEmptyErrorCode = 13401,
    
    MQInputServicePasswordErrorCode = 13402,//

    // -----------------------------------
    // 选择错误
    MQChooseErrorCode = 14001, // 选择错误
    MQChooseEmptyErrorCode = 14002, // 未选择任何项
    // -----------------------------------
    //收货地址
    MQAddressNameEmptyErrorCode = 14100,
    MQAddressNameLimitErrorCode = 14101,
    MQAddressPhoneEmptyErrorCode = 14102,
    MQAddressPhoneLimitErrorCode = 14103,
    MQAddressCodeLimitErrorCode = 14104,
    MQAddressDetailEmptyErrorCode = 14105,
    MQAddressDetailLimitErrorCode = 14106,

    
    //-----------借款信息
    MQInputBorrowingAmountEmptyErrorCode = 13151,
    MQInputBorrowingAmountPositiveFormatErrorCode = 13152,
    MQInputBorrowingAmountSectionFormatErrorCode = 13153,
    MQInputBorrowingTitleEmptyErrorCode = 13154,
    MQInputBorrowingTitleFormatErrorCode = 13155,
    MQInputBorrowingPurposeEmptyErrorCode = 13156,// 借款用途
    MQInputBorrowingPurposeFormatErrorCode = 13157,
    
    //工作信息
    MQInputWorkInfoPhoneFormatFormatErrorCode = 13158,
    MQInputWorkInfoEntryFormatFormatErrorCode = 13159,

    
    //活动
    MQInputExperienceCardEmptyErrorCode = 13171,//体验卡
    MQInputExperienceCardErrorCode = 13172,//
    
    //我的投资
    MQInputTradePasswordEmptyErrorCode = 13181,//

    
    //姓名格式错误
    MQInputRealnameErrorCode = 13200,
    MQInputNetworthBorrowTitleErrorCode = 13201,
    MQInputBorrowDescripErrorCode = 13202,
    MQInputBorrowAmountErrorCode = 13203,
    
    MQInputUnPositiveNumberErrorCode = 13204,
    
    //信用卡
    MQInputCreditBankCardNumberEmptyErrorCode = 13300,
    MQInputCreditBankCardNumbeFormatErrorCode = 13301,

    
    MQInputCommonErrorCodeStart = 13900,
    MQInputCommonEmptyErrorCode = MQInputCommonErrorCodeStart + 1, //不能为空
    MQInputCommonNumberErrorCode = MQInputCommonErrorCodeStart + 2, //要求是数字
    MQInputCommonIntegerNumberErrorCode = MQInputCommonErrorCodeStart + 2, //要求是整数
    MQInputCommonIsChineseErrorCode = MQInputCommonErrorCodeStart + 3, //要求是中文
    MQInputCommonErrorCodeEnd = 13999,
    
    
    MQInternalErrorCode = 99998, // 内部错误
    MQUnknownErrorCode = 99999,  // 未知错误
};


//
// MQ错误码表
//
#define MQ_ERROR_MESSAGE_DICT  @{ \
    @(MQBackendSuccessErrorCode): @"MQBackendSuccessErrorCode", \
    @(MQBackendFailureErrorCode): @"MQBackendFailureErrorCode", \
    @(MQBackendFailureAlertErrorCode): @"MQBackendFailureAlertErrorCode", \
    @(MQBackendAbnormalErrorCode): @"MQBackendAbnormalErrorCode", \
    @(MQBackendBuyInsufficientErrorCode):@"MQBackendBuyInsufficientErrorCode", \
    @(MQBackendVerifySignatureErrorCode): @"MQBackendVerifySignatureErrorCode", \
    @(MQBackendFrozenAccountErrorCode): @"MQBackendFrozenAccountErrorCode", \
    @(MQAccountReLoginErrorCode): @"MQAccountReLoginErrorCode", \
    @(MQBackendBlacklistAccountErrorCode): @"MQBackendBlacklistAccountErrorCode", \
    @(MQNSURLErrorDomainErrorCode): @"MQNSURLErrorDomainErrorCode", \
    @(MQNSURLErrorDomainConnectErrorCode): @"MQNSURLErrorDomainConnectErrorCode", \
    @(MQNSURLErrorDomainCancelErrorCode): @"MQNSURLErrorDomainCancelErrorCode", \
    @(MQResponseVerifySignatureErrorCode): @"MQResponseVerifySignatureErrorCode", \
    @(MQMTLJSONAdaptorErrorCode): @"MQMTLJSONAdaptorErrorCode", \
    @(MQInputUserNameEmptyErrorCode): @"MQInputUserNameEmptyErrorCode", \
    @(MQInputUserNameFormatErrorCode): @"MQInputUserNameFormatErrorCode", \
    @(MQInputPasswordEmptyErrorCode): @"MQInputPasswordEmptyErrorCode", \
    @(MQInputPasswordFormatErrorCode): @"MQInputPasswordFormatErrorCode", \
    @(MQInputEmailAddressEmptyErrorCode): @"MQInputEmailAddressEmptyErrorCode", \
    @(MQInputEmailAddressFormatErrorCode): @"MQInputEmailAddressFormatErrorCode", \
    @(MQInputIDNumberEmptyErrorCode): @"MQInputIDNumberEmptyErrorCode", \
    @(MQInputIDNumberFormatErrorCode): @"MQInputIDNumberFormatErrorCode", \
    @(MQInputMobilePhoneNumberFormatErrorCode): @"MQInputMobilePhoneNumberFormatErrorCode", \
    @(MQInputMobilePhoneNumberEmptyErrorCode): @"MQInputMobilePhoneNumberEmptyErrorCode", \
    @(MQInputMoneyNumberEmptyErrorCode): @"MQInputMoneyNumberEmptyErrorCode", \
    @(MQInputMoneyNumberFormatErrorCode): @"MQInputMoneyNumberFormatErrorCode", \
    @(MQInputBankCardNumberEmptyErrorCode): @"MQInputBankCardNumberEmptyErrorCode", \
    @(MQInputBankCardNumbeFormatErrorCode): @"MQInputBankCardNumbeFormatErrorCode", \
    @(MQInputCityEmptyErrorCode): @"MQInputCityEmptyErrorCode", \
    @(MQInputCityFormatErrorCode): @"MQInputCityFormatErrorCode", \
    @(MQInputDateEmptyErrorCode): @"MQInputDateEmptyErrorCode", \
    @(MQInputDateFormatErrorCode): @"MQInputDateFormatErrorCode", \
    @(MQInputRealNameEmptyErrorCode): @"MQInputRealNameEmptyErrorCode", \
    @(MQInputRealNameFormatErrorCode): @"MQInputRealNameFormatErrorCode", \
    @(MQInputOpenNameEmptyErrorCode): @"MQInputOpenNameEmptyErrorCode", \
    @(MQInputOpenNameNameFormatErrorCode): @"MQInputOpenNameNameFormatErrorCode", \
    @(MQInputBranchEmptyErrorCode): @"MQInputBranchEmptyErrorCode", \
    @(MQInputBranchFormatErrorCode): @"MQInputBranchFormatErrorCode", \
    @(MQInputAccountNameEmptyErrorCode): @"MQInputAccountNameEmptyErrorCode", \
    @(MQInputAccountNameFormatErrorCode): @"MQInputAccountNameFormatErrorCode", \
    @(MQInputOldEmailAddressEmptyErrorCode): @"MQInputOldEmailAddressEmptyErrorCode", \
    @(MQInputOldEmailAddressFormatErrorCode): @"MQInputOldEmailAddressFormatErrorCode", \
    @(MQInputNewEmailAddressEmptyErrorCode): @"MQInputNewEmailAddressEmptyErrorCode", \
    @(MQInputNewEmailAddressFormatErrorCode): @"MQInputNewEmailAddressFormatErrorCode", \
    @(MQInputCurrentPasswordEmptyErrorCode): @"MQInputCurrentPasswordEmptyErrorCode", \
    @(MQInputCurrentPasswordFormatErrorCode): @"MQInputCurrentPasswordFormatErrorCode", \
    @(MQInputNewPasswordEmptyErrorCode): @"MQInputNewPasswordEmptyErrorCode", \
    @(MQInputNewPasswordFormatErrorCode): @"MQInputNewPasswordFormatErrorCode", \
    @(MQInputConfirmPasswordEmptyErrorCode): @"MQInputConfirmPasswordEmptyErrorCode", \
    @(MQInputConfirmPasswordFormatErrorCode): @"MQInputConfirmPasswordFormatErrorCode", \
    @(MQInputBorrowingAmountEmptyErrorCode): @"MQInputBorrowingAmountEmptyErrorCode", \
    @(MQInputBorrowingAmountPositiveFormatErrorCode): @"MQInputBorrowingAmountPositiveFormatErrorCode", \
    @(MQInputBorrowingAmountSectionFormatErrorCode):@"MQInputBorrowingAmountSectionFormatErrorCode",  \
    @(MQInputBorrowingTitleEmptyErrorCode): @"MQInputBorrowingTitleEmptyErrorCode", \
    @(MQInputBorrowingTitleFormatErrorCode): @"MQInputBorrowingTitleFormatErrorCode", \
    @(MQInputBorrowingPurposeEmptyErrorCode): @"MQInputBorrowingPurposeEmptyErrorCode", \
    @(MQInputBorrowingPurposeFormatErrorCode): @"MQInputBorrowingPurposeFormatErrorCode", \
    @(MQInputitleEmptyErrorCode): @"MQInputitleEmptyErrorCode", \
    @(MQInpuEducationalEmptyErrorCode): @"MQInpuEducationalEmptyErrorCode", \
    @(MQInpuLiveTypeEmptyErrorCode): @"MQInpuLiveTypeEmptyErrorCode", \
    @(MQInpuTimeLaterNowErrorCode):@"MQInpuTimeLaterNowErrorCode",\
    @(MQInpuTimeBeforeStartErrorCode):@"MQInpuTimeBeforeStartErrorCode",\
    @(MQInputLiveAddressEmptyErrorCode): @"MQInputLiveAddressEmptyErrorCode", \
    @(MQInputCredentialsAddressEmptyErrorCode): @"MQInputCredentialsAddressEmptyErrorCode", \
    @(MQInputCensusAddressErrorEmptyCode): @"MQInputCensusAddressErrorEmptyCode", \
    @(MQInputDetailAddressErrorEmptyCode): @"MQInputDetailAddressErrorEmptyCode", \
    @(MQInputDetailAddressFormatErrorCode): @"MQInputDetailAddressFormatErrorCode", \
    @(MQInpuMaritalStatusEmptyErrorCode): @"MQInpuMaritalStatusEmptyErrorCode", \
    @(MQInputLoanTitleEmptyErrorCode): @"MQInputLoanTitleEmptyErrorCode", \
    @(MQInputLoanTitleFormatErrorCode): @"MQInputLoanTitleFormatErrorCode", \
    @(MQInputLoanAmountEmptyErrorCode): @"MQInputLoanAmountEmptyErrorCode", \
    @(MQInputLoanAmountFormatErrorCode): @"MQInputLoanAmountFormatErrorCode", \
    @(MQInputLoanAPREmptyErrorCode): @"MQInputLoanAPREmptyErrorCode", \
    @(MQInputLoanAPRFormatErrorCode): @"MQInputLoanAPRFormatErrorCode", \
    @(MQInputLoanDescriptionEmptyErrorCode): @"MQInputLoanDescriptionEmptyErrorCode", \
    @(MQInputLoanDescriptionFormatErrorCode): @"MQInputLoanDescriptionFormatErrorCode", \
    @(MQInputLoanMonthlyIncomeEmptyErrorCode): @"MQInputLoanMonthlyIncomeEmptyErrorCode", \
    @(MQInputLoanMonthlyIncomeFormatErrorCode): @"MQInputLoanMonthlyIncomeFormatErrorCode", \
    @(MQInputFeedbackEmptyErrorCode): @"MQInputFeedbackEmptyErrorCode", \
    @(MQInputFeedbackFormatErrorCode): @"MQInputFeedbackFormatErrorCode", \
    @(MQInputVerificationCodeEmptyErrorCode): @"MQInputVerificationCodeEmptyErrorCode", \
    @(MQInputSelfPhoneNumberFormatErrorCode): @"MQInputSelfPhoneNumberFormatErrorCode", \
    @(MQInputVerificationCodeFormatErrorCode): @"MQInputVerificationCodeFormatErrorCode", \
    @(MQInputPDetailIdAddressChooseErrorCode): @"MQInputPDetailIdAddressChooseErrorCode", \
    @(MQInputPDetailIdAddressEmptyErrorCode): @"MQInputPDetailIdAddressEmptyErrorCode", \
    @(MQInputPDetailIdAddressFormatErrorCode): @"MQInputPDetailIdAddressFormatErrorCode", \
    @(MQInputPDetailLiveAddressChooseErrorCode): @"MQInputPDetailLiveAddressChooseErrorCode", \
    @(MQInputPDetailLiveAddressEmptyErrorCode): @"MQInputPDetailLiveAddressEmptyErrorCode", \
    @(MQInputPDetailLiveAddressFormatErrorCode): @"MQInputPDetailLiveAddressFormatErrorCode", \
    @(MQInputPDetailImmediateContact1NameEmptyErrorCode): @"MQInputPDetailImmediateContact1NameEmptyErrorCode", \
    @(MQInputPDetailImmediateContact1RelationshipChooseErrorCode): @"MQInputPDetailImmediateContact1RelationshipChooseErrorCode", \
    @(MQInputPDetailImmediateContact1PhoneEmptyErrorCode): @"MQInputPDetailImmediateContact1PhoneEmptyErrorCode", \
    @(MQInputPDetailContactNameFormatErrorCode): @"MQInputPDetailContactNameFormatErrorCode", \
    @(MQInputPDetailContactPhoneFormatErrorCode): @"MQInputPDetailContactPhoneFormatErrorCode", \
    @(MQInputSalaryBorrowAmountErrorCode): @"MQInputSalaryBorrowAmountErrorCode", \
    @(MQInputLoanDurationEmptyErrorCode): @"MQInputLoanDurationEmptyErrorCode", \
    @(MQInputServicePasswordErrorCode): @"MQInputServicePasswordErrorCode", \
    @(MQUnknownErrorCode): @"MQUnknownErrorMessage",\
    @(MQInputExperienceCardEmptyErrorCode):@"MQInputExperienceCardEmptyErrorCode",\
    @(MQInputExperienceCardErrorCode):@"MQInputExperienceCardErrorCode",\
    @(MQAddressNameEmptyErrorCode):@"MQAddressNameEmptyErrorCode",\
    @(MQAddressNameLimitErrorCode):@"MQAddressNameLimitErrorCode",\
    @(MQAddressPhoneEmptyErrorCode):@"MQAddressPhoneEmptyErrorCode",\
    @(MQAddressPhoneLimitErrorCode):@"MQAddressPhoneLimitErrorCode",\
    @(MQAddressCodeLimitErrorCode):@"MQAddressCodeLimitErrorCode",\
    @(MQAddressDetailEmptyErrorCode):@"MQAddressDetailEmptyErrorCode",\
    @(MQAddressDetailLimitErrorCode):@"MQAddressDetailLimitErrorCode",\
    @(MQInputWorkInfoPhoneFormatFormatErrorCode):@"MQInputWorkInfoPhoneFormatFormatErrorCode",\
    @(MQInputWorkInfoEntryFormatFormatErrorCode):@"MQInputWorkInfoEntryFormatFormatErrorCode",\
    @(MQInputPasswordFormatSexErrorCode):@"MQInputPasswordFormatSexErrorCode",\
    @(MQInputPasswordFormatTwentyErrorCode):@"MQInputPasswordFormatTwentyErrorCode",\
    @(MQInputUnPositiveNumberErrorCode):@"MQInputUnPositiveNumberErrorCode",\
    @(MQInputCreditBankCardNumberEmptyErrorCode):@"MQInputCreditBankCardNumberEmptyErrorCode",\
    @(MQInputCreditBankCardNumbeFormatErrorCode):@"MQInputCreditBankCardNumbeFormatErrorCode",\
} \

//
#define MQ_ERROR_MESSAGE_FROM_CODE(errorCode) [MQ_ERROR_MESSAGE_DICT objectForKey:@(errorCode)]


// MQ的Error域
extern NSString * const MQErrorDomain;


/**
 *  MQError
 */
@interface MQError : NSError

// 错误码
@property (nonatomic, assign, readonly) MQErrorCode errorCode;

// 错误信息
@property (nonatomic, strong, readonly) NSString *message;

// 本地化的错误信息
@property (nonatomic, strong, readonly) NSString *localizedMessage;


@end
