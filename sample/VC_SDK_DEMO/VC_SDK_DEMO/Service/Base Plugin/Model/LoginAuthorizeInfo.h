//
//  LoginAuthorizeInfo.h
//  VC_SDK_DEMO
//
//  Created by 毛建成 on 2017/12/21.
//  Copyright © 2017年 cWX160907. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuaweiSDKService/login_def.h"

@interface LoginAuthorizeInfo : NSObject

@property (nonatomic, copy)NSString *ipAddress;                        // ip address
@property (nonatomic, copy)NSString *loginAccount;
@property (nonatomic, copy)NSString *loginName;
@property (nonatomic, copy)NSString *loginPwd;
@property (nonatomic, copy)NSString *serverAddress;
@property (nonatomic, copy)NSString *proxyAddress;
@property (nonatomic, assign)int port;
@property (nonatomic, copy)NSString *smcUrl;
@property (nonatomic, copy)NSString *selfNum;
@property (nonatomic, copy)NSString *currentToken;
@property (nonatomic, assign)int networkType;
@property (nonatomic, assign)LOGIN_E_DEPLOY_MODE deployMode;
@property (nonatomic, copy)NSString *confServerAddress;
@property (nonatomic, assign)int confPort;
@end
