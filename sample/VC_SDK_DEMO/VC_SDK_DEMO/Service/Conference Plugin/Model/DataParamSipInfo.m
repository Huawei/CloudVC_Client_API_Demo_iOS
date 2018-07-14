//
//  DataParamSipInfo.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//
#import "DataParamSipInfo.h"

@implementation DataParamSipInfo

/**
 *This method is used to parse C struct CALL_S_DATACONF_PARAM to instance of class DataParamSipInfo
 *将头文件的结构体CALL_S_DATACONF_PARAM转换为类DataParamSipInfo的实例
 */
+ (instancetype)paraseFromInfoStruct:(CALL_S_DATACONF_PARAM *)param
{
    DataParamSipInfo *sipInfo = [[DataParamSipInfo alloc] init];
    sipInfo.confId = param->ulConfID;
    sipInfo.callId = param->ulCallID;
    sipInfo.role = param->enRole;
    sipInfo.dataConfId = [NSString stringWithUTF8String:param->acDataConfID];
    sipInfo.authKey = [NSString stringWithUTF8String:param->acAuthKey];
    sipInfo.passCode = [NSString stringWithUTF8String:param->acPassCode];
    if (sipInfo.passCode.length == 0) {
        sipInfo.passCode = [NSString stringWithUTF8String:param->acDataRandom];
    }
    sipInfo.confUrl = [NSString stringWithUTF8String:param->acConfUrl];
    sipInfo.dataConfUrl = [NSString stringWithUTF8String:param->acDataConfUrl];
    sipInfo.dataRandom = [NSString stringWithUTF8String:param->acDataRandom];
    sipInfo.confCtrlRandom = [NSString stringWithUTF8String:param->acConfctrlRandom];
    return sipInfo;
}

@end
