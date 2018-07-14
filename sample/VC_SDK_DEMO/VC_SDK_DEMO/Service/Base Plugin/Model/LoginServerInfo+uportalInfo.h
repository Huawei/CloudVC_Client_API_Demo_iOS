//
//  LoginServerInfo+uportalInfo.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "LoginServerInfo.h"
#import "login_def.h"
@interface LoginServerInfo (uportalInfo)

/**
 This method is used to init LoginServerInfo.
 初始化LoginServerInfo

 @param accessServer LOGIN_S_ACCESS_SERVER
 @return 实例
 */
-(instancetype)initWithAccessServer:(LOGIN_S_ACCESS_SERVER *)accessServer;

@end
