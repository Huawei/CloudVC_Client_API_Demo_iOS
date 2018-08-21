//
//  NetworkUtils.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import "VCReachability.h"
#import "Defines.h"

@interface NetworkUtils : NSObject
/**
 NetworkUtils instance
 
 @return NetworkUtils value
 */
+(instancetype)shareInstance;
/**
 get current network state
 
 @return NetworkStatus value
 */
-(NetworkStatus)getCurrentNetworkStatus;

@end
