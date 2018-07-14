//
//  DataConfParam+StructParse.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "DataConfParam+StructParse.h"

@implementation DataConfParam (StructParse)

/**
 *This method is used to transform CONFCTRL_S_DATACONF_PARAMS data to DataConfParam data;
 *将CONFCTRL_S_DATACONF_PARAMS数据结构 转换成 DataConfParam实例
 *@param confParam CONFCTRL_S_DATACONF_PARAMS
 *@return DataConfParam
 */
+ (DataConfParam *)transformFromTupStruct:(CONFCTRL_S_DATACONF_PARAMS *)confParam {
    if (NULL == confParam)
    {
        return nil;
    }
    DataConfParam *params = [[DataConfParam alloc] init];
    params.confId = [NSString stringWithUTF8String:confParam->conf_id];
    params.hostKey = [NSString stringWithUTF8String:confParam->host_key];
    params.cryptKey = [NSString stringWithUTF8String:confParam->crypt_key];
    params.cmAddress = [NSString stringWithUTF8String:confParam->cm_address];
    params.siteUrl = [NSString stringWithUTF8String:confParam->site_url];
    params.siteId = [NSString stringWithUTF8String:confParam->site_id];
    params.serverIp = [NSString stringWithUTF8String:confParam->server_ip];
    params.userId = [NSString stringWithUTF8String:confParam->user_id];
    params.userName = [NSString stringWithUTF8String:confParam->user_name];
    params.userUri = [NSString stringWithUTF8String:confParam->user_uri];
    params.confName = [NSString stringWithUTF8String:confParam->conf_name];
    params.accessCode = [NSString stringWithUTF8String:confParam->access_code];
    params.partSecureConfNum = [NSString stringWithUTF8String:confParam->part_secure_conf_num];
    params.stgServerAddress = [NSString stringWithUTF8String:confParam->stg_server_address];
    params.sbcServerAddress = [NSString stringWithUTF8String:confParam->sbc_server_address];
    params.pinCode = [NSString stringWithUTF8String:confParam->pin_code];
    params.participantId = [NSString stringWithUTF8String:confParam->participant_id];
    params.userRole = confParam->user_role;
    params.M = confParam->M;
    params.T = confParam->T;
    
    return params;
}

@end
