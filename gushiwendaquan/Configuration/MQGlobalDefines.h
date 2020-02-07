//
//  MQGlobalDefines.h
//  MQAI
//
//  Created by ymg on 15/2/5.
//  Copyright (c) 2015年 ymg. All rights reserved.
//

#ifndef MQAI_MQGlobalDefines_h
#define MQAI_MQGlobalDefines_h

//
// 其他定义参加MQGeneralDefines.h
//
//
#if DEBUG
#define MQ_ENVIRONMENT_DEFAULT @[\
                                    \
                                    ]
#else
#define MQ_ENVIRONMENT_DEFAULT @[]
#endif

#endif
