//
//  DataParamSipInfo.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import "HuaweiSDKService/call_def.h"

@interface DataParamSipInfo : NSObject
@property (nonatomic, assign)unsigned int confId; //会议id
@property (nonatomic, assign)unsigned int callId; //呼叫id
@property (nonatomic, assign)unsigned int role; //与会者角色
@property (nonatomic, copy)NSString *dataConfId; //数据会议id
@property (nonatomic, copy)NSString *authKey; //鉴权钥匙
@property (nonatomic, copy)NSString *passCode; //密码
@property (nonatomic, copy)NSString *confUrl; //会议服务器url
@property (nonatomic, copy)NSString *dataConfUrl; //数据会议服务器url
@property (nonatomic, copy)NSString *dataRandom; //数据会议随机数
@property (nonatomic, copy)NSString *confCtrlRandom; //回控随机数

+ (instancetype)paraseFromInfoStruct:(CALL_S_DATACONF_PARAM *)param;

@end
