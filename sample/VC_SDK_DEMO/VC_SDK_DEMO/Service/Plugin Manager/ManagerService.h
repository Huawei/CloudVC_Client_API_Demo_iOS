//
//  ManagerService.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import "CallInterface.h"
#import "LoginInterface.h"
#import "ConferenceInterface.h"
#import "DataConferenceInterface.h"

typedef enum : NSUInteger {
    TUP_LOGIN_SERVICE,
    TUP_CONFERENCE_SERVICE,
    TUP_DATA_CONFERENCE_SERVICE,
    TUP_CALL_SERVICE
} TUP_SERVICE_TYPE;

@interface ManagerService : NSObject

+(id<LoginInterface>)loginService;

+(id<CallInterface>)callService;

+(id<ConferenceInterface>)confService;

+(id<DataConferenceInterface>)dataConfService;

/**
 load all service
 
 @return BOOL
 */
+(BOOL)loadAllService;


+(BOOL)loadService:(TUP_SERVICE_TYPE)serviceType;

/**
 release service
 
 @return BOOL
 */
+(BOOL)unLoadService;


@end
