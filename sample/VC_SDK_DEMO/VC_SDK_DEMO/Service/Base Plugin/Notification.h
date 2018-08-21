//
//  Notification.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import "HuaweiSDKService/tup_def.h"
#import "HuaweiSDKService/tup_confctrl_def.h"
#import "HuaweiSDKService/tup_confctrl_interface.h"
#import "HuaweiSDKService/tup_conf_baseapi.h"

@interface Notification : NSObject
@property (nonatomic, assign)TUP_UINT32 msgId;    // the message ID
@property (nonatomic, assign)TUP_UINT32 param1;   // the parameter 1
@property (nonatomic, assign)TUP_UINT32 param2;   // the parameter 2
@property (nonatomic, assign)void *data;          // the message to attach data

/**
 * This method is used to init Notification.
 * 初始化Notification
 *@param msgId TUP_UINT32
 *@param param1 TUP_UINT32
 *@param param2 TUP_UINT32
 *@param data void*
 *@return Notification
 */
- (id)initWithMsgId:(TUP_UINT32)msgId
             param1:(TUP_UINT32)param1
             param2:(TUP_UINT32)param2
               data:(void*)data;

@end

@interface DataConfNotification : NSObject
@property (nonatomic, assign) CONF_HANDLE confHandle;     // the conference handle
@property (nonatomic, assign) TUP_INT nType;              // the message or event notification type
@property (nonatomic, assign) TUP_UINT nValue1;           // parameter 1
@property (nonatomic, assign) TUP_ULONG nValue2;          // parameter 2
@property (nonatomic, assign) void* pVoid;                // the message structure is returned
@property (nonatomic, assign) TUP_INT nSize;              // the length of the pvoid to point to the content

/**
 * This method is used to init data DataConfNotification
 * 初始化DataConfNotification
 *@param confHandle CONF_HANDLE
 *@param nType TUP_INT
 *@param nValue1 TUP_UINT
 *@param nValue2 TUP_ULONG
 *@param pVoid void*
 *@param nSize TUP_INT
 *@return DataConfNotification
 */
- (id)initWithDataConfConfHandle:(CONF_HANDLE)confHandle
                           nType:(TUP_INT)nType
                         nValue1:(TUP_UINT)nValue1
                         nValue2:(TUP_ULONG)nValue2
                           pVoid:(void*)pVoid
                           nSize:(TUP_INT)nSize;

@end
