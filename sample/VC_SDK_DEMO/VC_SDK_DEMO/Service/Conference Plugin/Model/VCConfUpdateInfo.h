//
//  VCConfUpdateInfo.h
//  VC_SDK_DEMO
//
//  Created by 毛建成 on 2017/12/29.
//  Copyright © 2017年 cWX160907. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import "HuaweiSDKService/tup_confctrl_def.h"

@interface VCConfUpdateInfo : NSObject
@property(nonatomic, assign) int ucM;
@property(nonatomic, assign) int ucT;

@property(nonatomic, copy) NSString* aucName;
@property(nonatomic, copy) NSString* aucNumber;

@property(nonatomic, assign) int udwUnJoinReason;

@property(nonatomic, assign) int uwAutoViewSeq;
@property(nonatomic, assign) int uwAutoBroadSeq;

@property(nonatomic, assign) int ucAutoView;
@property(nonatomic, assign) int ucAutoBroad;
@property(nonatomic, assign) int ucSiteNum;
@property(nonatomic, assign) int ucIsUsed;
@property(nonatomic, assign) int ucJoinConf;
@property(nonatomic, assign) int ucType;
@property(nonatomic, assign) int ucIsPSTN;
@property(nonatomic, assign) int ucGetName;
@property(nonatomic, assign) int ucGetNumber;
@property(nonatomic, assign) int ucMute;
@property(nonatomic, assign) int ucSilent;
@property(nonatomic, assign) int ucReqTalk;
@property(nonatomic, assign) int ucTPMain;
@property(nonatomic, assign) int ucScreenNum;
@property(nonatomic, assign) int ucHasRefresh;
@property(nonatomic, assign) int ucChair;
@property(nonatomic, assign) int ucLocalMute;

@property(nonatomic, assign) BOOL isChair;
@property(nonatomic, assign) BOOL isSpeaking;
@property(nonatomic, assign) VC_ATTENDEE_UPDATE_E updateType;

@property (nonatomic, copy) NSString *userID; //用户id
@property (nonatomic, assign) DataConfAttendeeMediaState dataState; //数据会议状态
@property (nonatomic, assign) DATACONF_USER_ROLE_TYPE dataRole; //数据会议角色

+(VCConfUpdateInfo *)returnVCConfInfoWith:(TE_ATTENDEE_DATA_IN_LIST *)attendeeList;
@end

@interface ConfCtrlSpeaker : NSObject
@property (nonatomic, copy) NSString *number; //发言人号码
@property (nonatomic, assign) BOOL is_speaking; //是否在发言
@property (nonatomic, assign) int speaking_volume; //发言音量
@end
