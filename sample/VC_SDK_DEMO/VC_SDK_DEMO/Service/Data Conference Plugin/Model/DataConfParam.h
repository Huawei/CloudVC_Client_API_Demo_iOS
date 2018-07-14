//
//  DataConfParam.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>

@interface DataConfParam : NSObject

@property (nonatomic, copy)NSString *confId;             // conference Id
@property (nonatomic, copy)NSString *hostKey;            // host key
@property (nonatomic, copy)NSString *cryptKey;           // crypt key
@property (nonatomic, copy)NSString *cmAddress;          // cm address
@property (nonatomic, copy)NSString *siteUrl;            // site url
@property (nonatomic, copy)NSString *siteId;             // site Id
@property (nonatomic, copy)NSString *serverIp;           // service Ip
@property (nonatomic, copy)NSString *userId;             // user Id
@property (nonatomic, copy)NSString *userName;           // user Name
@property (nonatomic, copy)NSString *userUri;            // user uri
@property (nonatomic, copy)NSString *confName;           // conference name
@property (nonatomic, copy)NSString *accessCode;         // access code
@property (nonatomic, copy)NSString *partSecureConfNum;  // part secure conference number
@property (nonatomic, copy)NSString *stgServerAddress;   // stg serviece address
@property (nonatomic, copy)NSString *sbcServerAddress;   // sbc service address
@property (nonatomic, copy)NSString *pinCode;            // ping code
@property (nonatomic, copy)NSString *participantId;      // participant Id
@property (nonatomic, assign)int userRole;               // user role
@property (nonatomic, assign)int M;                      // M numbre
@property (nonatomic, assign)int T;                      // T number

@end
