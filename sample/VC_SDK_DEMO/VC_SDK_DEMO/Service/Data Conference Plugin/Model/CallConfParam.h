//
//  CallConfParam.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import "call_def.h"

@interface CallConfParam : NSObject

@property (nonatomic, assign) unsigned int ulConfID;    // conf ID
@property (nonatomic, assign) unsigned int ulCallID;    // call ID
@property (nonatomic, assign) CALL_E_CONF_ROLE enRole;  // roll
@property (nonatomic, copy) NSString *acDataConfID;     // data conference ID
@property (nonatomic, copy) NSString *acAuthKey;        // authorize key
@property (nonatomic, copy) NSString *acPassCode;       // pass Code
@property (nonatomic, copy) NSString *acCmAddr;         // Cm Address
@property (nonatomic, copy) NSString *acGroupUri;       // group uri
@property (nonatomic, copy) NSString *acExtConfType;    // conference type
@property (nonatomic, copy) NSString *acCharman;        // charman
@property (nonatomic, copy) NSString *bP2PDataConf;     // bp2p data conference

@end
