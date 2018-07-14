//
//  LoginServerInfo+uportalInfo.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "LoginServerInfo+uportalInfo.h"

@implementation LoginServerInfo (uportalInfo)

/**
 *This method is used to transform struct LOGIN_S_ACCESS_SERVER to instance of LoginServerInfo
 *将结构体LOGIN_S_ACCESS_SERVER转换为LoginServerInfo实例
 @param accessServer LOGIN_S_ACCESS_SERVER
 @return 实例
 */
-(instancetype)initWithAccessServer:(LOGIN_S_ACCESS_SERVER *)accessServer
{
    LoginServerInfo *loginAccessServer = [[LoginServerInfo alloc] init];
    loginAccessServer.serverName = [NSString stringWithUTF8String:accessServer->server_name];
    loginAccessServer.sipUri = [NSString stringWithUTF8String:accessServer->sip_uri];
    loginAccessServer.svnUri = [NSString stringWithUTF8String:accessServer->svn_uri];
    loginAccessServer.httpsproxyUri = [NSString stringWithUTF8String:accessServer->httpsproxy_uri];
    loginAccessServer.eserverUri = [NSString stringWithUTF8String:accessServer->eserver_uri];
    loginAccessServer.confUri = [NSString stringWithUTF8String:accessServer->conf_uri];
    loginAccessServer.maaUri = [NSString stringWithUTF8String:accessServer->maa_uri];
    loginAccessServer.msParamUri = [NSString stringWithUTF8String:accessServer->ms_param_uri];
    loginAccessServer.msParamPathUri = [NSString stringWithUTF8String:accessServer->ms_param_path_uri];
    loginAccessServer.eabUri = [NSString stringWithUTF8String:accessServer->eab_uri];
    loginAccessServer.prophotoUri = [NSString stringWithUTF8String:accessServer->prophoto_uri];
    loginAccessServer.stgAccount = [NSString stringWithUTF8String:accessServer->stg_info.account];
    loginAccessServer.stgPwd = [NSString stringWithUTF8String:accessServer->stg_info.password];
    loginAccessServer.stgUri = [NSString stringWithUTF8String:accessServer->stg_info.stg_uri];
    loginAccessServer.sipStgUri = [NSString stringWithUTF8String:accessServer->stg_info.sip_stg_uri];
    loginAccessServer.maaStgUri = [NSString stringWithUTF8String:accessServer->stg_info.maa_stg_uri];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i =0; i<LOGIN_D_MAX_MS_NUM; i++)
    {
        NSString *str = [NSString stringWithUTF8String:accessServer->ms_uri[i]];
        if (!str && [str length]>0)
        {
            [mutArray addObject:str];
        }
    }
    self.msUri = [NSArray arrayWithArray:mutArray];
    return loginAccessServer;
}
@end
