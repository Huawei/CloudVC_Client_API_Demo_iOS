//
//  TUPChatMsg.h
//  TUP_Mobile_DataConference_Demo
//
//  Created by lwx308413 on 16/11/23.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tup_def.h"
#import "tup_conf_otherdef.h"

@interface TUPChatMsg : NSObject

@property (nonatomic,assign) TUP_UINT32 nFromUserid;
@property (nonatomic,assign) TUP_UINT32 nMsgLen;
@property (nonatomic,assign) TUP_INT nMsgType;
@property (nonatomic,assign) TUP_INT nFromGroupID;
@property (nonatomic,assign) TUP_UINT32 userId;
@property (nonatomic,assign) TUP_UINT16 nSequenceNmuber;
@property (nonatomic,assign) TUP_INT64 time;
@property (nonatomic, copy) NSString *lpMsg;
@property (nonatomic, copy) NSString *fromUserName;


@end
