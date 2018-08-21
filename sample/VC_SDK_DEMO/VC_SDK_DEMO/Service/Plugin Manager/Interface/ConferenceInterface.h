//
//  ConferenceInterface.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#ifndef ConferenceInterface_h
#define ConferenceInterface_h

#import "Defines.h"

extern NSString *const CONFERENCE_END_NOTIFY;
extern NSString *const CONFERENCE_CONNECT_NOTIFY;

@class TupCallNotifications,ConfMember,TUPConferenceNotifications,ECConfInfo,ECCurrentConfInfo;
@protocol ConferenceServiceDelegate <NSObject>
@required


/**
 * This method is used to deel Conference event callback
 * 会议事件回调
 *@param ecConfEvent           Indicates EC_CONF_E_TYPE enum value
 *                             会议事件类型
 *@param resultDictionary      result value
 *                             回调信息集
 */
-(void)ecConferenceEventCallback:(EC_CONF_E_TYPE)ecConfEvent result:(NSDictionary *)resultDictionary;

@end

@protocol ConferenceInterface <NSObject>

/**
 *Indicates conference service delegate
 *会议业务代理
 */
@property (nonatomic ,assign)id<ConferenceServiceDelegate> delegate;

/**
 *Indicates whether have joined data conf
 *判断是否加入数据会议
 */
@property (nonatomic, assign) BOOL isJoinDataConf;

/**
 *Indicates whether xxxx
 *判断是否一次会议中是否是第一次跳转界面
 */
@property (nonatomic, assign) BOOL isFirstJumpToRunningView;

/**
 *Indicates whether have joined attendee array
 *与会者列表数组
 */
@property (nonatomic, strong) NSMutableArray *haveJoinAttendeeArray;     //current conference'attendees

/**
 *Indicates conf type enum
 *会议类型枚举
 */
@property (nonatomic, assign) EC_CONF_TOPOLOGY_TYPE uPortalConfType;

/**
 *Indicates self join conf number
 *自己加入会议的号码
 */
@property (nonatomic, copy) NSString *selfJoinNumber;                    //self join Number in current conference

/**
 *Indicates data conf param url dictionary
 *数据会议参数词典
 */
@property (nonatomic, strong) NSMutableDictionary *dataConfParamURLDic;  // Dic record dataConfParamUrl

/**
 * This method is used to dealloc conference params
 * 销毁会议参数信息
 */
-(void)restoreConfParamsInitialValue;

/**
 * This method is used to get current conference detail information
 * 获取当前会议详细信息
 *@return ECCurrentConfInfo        Indicates current conference detail information, see ECCurrentConfInfo
 *                                 会议详情
 */
-(ECCurrentConfInfo *)getCurrentConfDetailInfo;

/**
 * This method is used to set conference server params
 * 设置会议服务器信息
 *@param address server address
 *@param port server port
 *@param token get token from uportal login
 */
-(void)configConferenceCtrlWithServerAddress:(NSString *)address port:(int)port networkType:(int)networkType;

/*
 set auth code
 @param account auth account
 @param pwd auth password
 */
-(void)configConferenceAuthCode:(NSString *)account pwd:(NSString *)password;

/**
 * This method is used to set token
 * 设置鉴权token
 *@param token get token from uportal login
 *@return YES or NO
 */
-(BOOL)configToken:(NSString *)token;

/**
 * This method is used to create conference
 * 创会
 *@param attendeeArray one or more attendees
 *@param mediaType EC_CONF_MEDIATYPE value
 *@return YES or NO
 */
-(BOOL)createConferenceWithAttendee:(NSArray *)attendeeArray mediaType:(EC_CONF_MEDIATYPE)mediaType subject:(NSString *)subject startTime:(NSDate *)startTime confLen:(int)confLen password:(NSString *)password;

/**
 * This method is used to create conference handle
 * 创建会议句柄
 *@param confId conference id
 *@return YES or NO
 */
-(BOOL)createConfHandle:(NSString *)confId;

/**
 * This method is used to join conference
 * 加入会议
 *@param confInfo conference
 *@param attendeeArray attendees
 *@return YES or NO
 */
-(BOOL)joinConference:(ECConfInfo *)confInfo attendee:(NSArray *)attendeeArray;

/**
 * This method is used to get conference detail info
 * 获取会议详细信息
 *@param confId conference id
 *@param pageIndex pageIndex default 1
 *@param pageSize pageSize default 10
 *@return YES or NO
 */
-(BOOL)obtainConferenceDetailInfoWithConfId:(NSString *)confId Page:(int)pageIndex pageSize:(int)pageSize;

/**
 * This method is used to get conference list
 * 获取会议列表
 *@param pageIndex pageIndex default 1
 *@param pageSize pageSize default 10
 *@return YES or NO
 */
-(BOOL)obtainConferenceListWithPageIndex:(int)pageIndex pageSize:(int)pageSize;

/**
 * This method is used to access conference
 * 接入预约会议
 *@param confDetailInfo ECConfInfo value
 *@return YES or NO
 */
-(unsigned int)accessReservedConference:(ECConfInfo *)confDetailInfo;

/**
 * This method is used to add attendee to conference
 * 添加与会者到会议中
 @param attendeeArray attendees
 @return YES or NO
 */
-(BOOL)confCtrlAddAttendeeToConfercene:(NSString *)attendeeNum;

/**
 * This method is used to remove attendee
 * 移除与会者
 *@param attendeeNumber attendee number
 *@return YES or NO
 */
-(BOOL)confCtrlRemoveAttendeeM:(int)ucM T:(int)ucT;

/**
 * This method is used to hang up attendee
 * 挂断与会者
 *@param M
 *@param T
 *@return YES or NO
 */
-(BOOL)confCtrlHangUpAttendeeM:(int)ucM T:(int)ucT;

/**
 * This method is used to recall attendee
 * 重呼与会者
 *@param M
 *@param T
 *@return YES or NO
 */
-(BOOL)confCtrlRecallAttendeeM:(int)ucM T:(int)ucT;

/**
 * This method is used to leave conference
 * 离开会议
 *@return YES or NO
 */
-(BOOL)confCtrlLeaveConference;

/**
 * This method is used to end conference (chairman)
 * 结束会议
 *@return YES or NO
 */
-(BOOL)confCtrlEndConference;

/**
 * This method is used to lock conference (chairman)
 * 主席锁定会场
 *@param isLock YES or NO
 *@return YES or NO
 */
-(BOOL)confCtrlLockConference:(BOOL)isLock;

/**
 * This method is used to mute attendee (chairman)
 * 主席闭音与会者
 *@param attendeeNumber attendee number
 *@param isMute YES or NO
 *@return YES or NO
 */
-(BOOL)confCtrlMuteAttendeeM:(int)ucM T:(int)ucT isMute:(BOOL)isMute;

/**
 * This method is used to upgrade audio conference to data conference
 * 语音会议升级为数据会议
 *@param hasVideo whether the conference has video
 *@return YES or NO
 */
-(BOOL)confCtrlVoiceUpgradeToDataConference:(BOOL)hasVideo;

/**
 * This method is used to release chairman right (chairman)
 * 释放主席权限
 *@param chairNumber chairman number in conference
 *@return YES or NO
 */
- (BOOL)confCtrlReleaseChairman:(NSString *)chairNumber;

/**
 * This method is used to request chairman right (Attendee)
 * 申请主席权限
 *@param chairPwd chairman password
 *@param newChairNumber attendee's number in conference
 *@return YES or NO
 */
- (BOOL)confCtrlRequestChairman:(NSString *)chairPwd number:(NSString *)newChairNumber;

/**
 * This method is used to judge whether is uportal mediax conf
 * 判断是否为mediax下的会议
 */
- (BOOL)isUportalMediaXConf;

/**
 * This method is used to judge whether is uportal smc conf
 * 判断是否为smc下的会议
 */
- (BOOL)isUportalSMCConf;

/**
 * This method is used to set conf mode
 * 设置会议模式
 */
- (void)setConfMode:(EC_CONF_MODE)mode;

/**
 * This method is used to boardcast attendee
 * 广播与会者
 */
- (void)boardcastAttendeeM:(int)ucM T:(int)ucT  isBoardcast:(BOOL)isBoardcast;

/**
 * This method is used to watch attendee
 * 观看与会者
 */
- (void)watchAttendeeM:(int)ucM T:(int)ucT;

/**
 *This method is used to obtain media type
 */
-(int)obtainMediaType;

/**
 postpone conf
 @param postpone conf time
 */
- (BOOL)confCtrlPostponeConf:(NSString*)postponeTime;

@end

#endif /* ConferenceInterface_h */


