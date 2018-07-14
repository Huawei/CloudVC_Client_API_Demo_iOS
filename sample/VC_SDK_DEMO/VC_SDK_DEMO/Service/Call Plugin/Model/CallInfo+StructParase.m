//
//  CallInfo+StructParase.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//
#import "CallInfo+StructParase.h"

@implementation CallInfo (StructParase)

/**
 *This method is used to parse C struct CALL_S_CALL_INFO to instance of class CallInfo
 *将头文件的结构体CALL_S_CALL_INFO转换为类CallInfo的实例
 */
+ (CallInfo *)transfromFromCallInfoStract:(CALL_S_CALL_INFO *)callInfo
{
    if (NULL == callInfo)
    {
        return nil;
    }
    CALL_S_CALL_STATE_INFO callStateInfo = callInfo->stCallStateInfo;
    CallStateInfo *stateInfo = [[CallStateInfo alloc]init];
    stateInfo.callId = callStateInfo.ulCallID;
    stateInfo.callType = (TUP_CALL_TYPE)callStateInfo.enCallType;
    stateInfo.callState = (CallState)callStateInfo.enCallState;
    if (0 < strlen(callStateInfo.acTelNum))
    {
        stateInfo.callNum = [NSString stringWithUTF8String:callStateInfo.acTelNum];
    }
    else if (0 < strlen(callStateInfo.acDisplayName))
    {
        stateInfo.callNum = [NSString stringWithUTF8String:callStateInfo.acDisplayName];
    }
    else
    {
        stateInfo.callNum = @"";
    }
    if (0 < strlen(callStateInfo.acDisplayName))
    {
        stateInfo.callName = [NSString stringWithUTF8String:callStateInfo.acDisplayName];
    }
    stateInfo.reasonCode = callStateInfo.ulReasonCode;
    
    CallInfo *info = [[CallInfo alloc]init];
    info.isFocus = callInfo->bIsFocus;
    info.stateInfo = stateInfo;
    info.orientType = callInfo->ulOrientType;
    if (0 < strlen(callInfo->acTelNumTel))
    {
        info.telNumTel = [NSString stringWithUTF8String:callInfo->acTelNumTel];
    }
    if (0 < strlen(callInfo->acServerConfID))
    {
        info.serverConfId = [NSString stringWithUTF8String:callInfo->acServerConfID];
    }
    info.confMediaType = callInfo->ulConfMediaType;
    return info;
}

@end
