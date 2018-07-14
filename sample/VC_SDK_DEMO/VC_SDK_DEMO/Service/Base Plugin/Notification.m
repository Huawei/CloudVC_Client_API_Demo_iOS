//
//  Notification.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "Notification.h"

#import "DataConferenceService.h"

@implementation Notification

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
               data:(void*)data
{
    if (self = [super init])
    {
        _msgId = msgId;
        _param1 = param1;
        _param2 = param2;
        _data = data;
    }
    return self;
}

@end


@implementation DataConfNotification

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
                        nValue2 :(TUP_ULONG)nValue2
                           pVoid:(void*)pVoid
                          nSize :(TUP_INT)nSize;
{
    if (self = [super init])
    {
        _confHandle = confHandle;
        _nType = nType;
        _nValue1 = nValue1;
        _nValue2 = nValue2;
        _pVoid = pVoid;
        _nSize = nSize;
    }
    return self;
}

@end
