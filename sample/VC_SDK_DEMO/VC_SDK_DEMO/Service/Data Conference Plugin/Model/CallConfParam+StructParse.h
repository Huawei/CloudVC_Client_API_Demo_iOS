//
//  CallConfParam+StructParse.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "CallConfParam.h"
#import "HuaweiSDKService/call_def.h"

@interface CallConfParam (StructParse)

/**
 *This method is used to transform CALL_S_DATACONF_PARAM data to CallConfParam data;
 *将CALL_S_DATACONF_PARAM数据结构 转换成 CallConfParam实例
 *@param confParam CALL_S_DATACONF_PARAM
 *@return CallConfParam
 */
+ (CallConfParam *)transformFromTupStruct:(CALL_S_DATACONF_PARAM *)confParam;

@end
