//
//  CallConfParam+StructParse.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "CallConfParam+StructParse.h"

@implementation CallConfParam (StructParse)
/**
 *This method is used to transform CALL_S_DATACONF_PARAM data to CallConfParam data;
 *将CALL_S_DATACONF_PARAM数据结构 转换成 CallConfParam实例
 *@param confParam CALL_S_DATACONF_PARAM
 *@return CallConfParam
 */
+ (CallConfParam *)transformFromTupStruct:(CALL_S_DATACONF_PARAM *)confParam {
    if (NULL == confParam)
    {
        return nil;
    }
    CallConfParam *params = [[CallConfParam alloc] init];
    params.acAuthKey = [NSString stringWithUTF8String:confParam->acAuthKey];
    params.acCharman = [NSString stringWithUTF8String:confParam->acCharman];
    params.acDataConfID = [NSString stringWithUTF8String:confParam->acDataConfID];
    params.acPassCode = [NSString stringWithUTF8String:confParam->acPassCode];
    params.acCmAddr = [NSString stringWithUTF8String:confParam->acCmAddr];
    params.acGroupUri = [NSString stringWithUTF8String:confParam->acGroupUri];
    params.acExtConfType = [NSString stringWithUTF8String:confParam->acExtConfType];
    params.bP2PDataConf = [NSString stringWithUTF8String:&confParam->bP2PDataConf];
    params.ulConfID = confParam->ulConfID;
    params.ulCallID = confParam->ulCallID;
    params.enRole = confParam->enRole;
    
    return params;
}
@end
