//
//  DataConferenceInterface.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#ifndef DataConferenceInterface_h
#define DataConferenceInterface_h

#import "Defines.h"

@class ChatMsg;
@protocol DataConferenceServiceDelegate <NSObject>

@optional
/**
 * This method is used to deel data conference event callback
 * 数据会议回调事件
 *@param conferenceEvent  : TUP_CONFERENCE_EVENT_TYPE enum value
 *@param resultDictionary : result dictionary
 */
-(void)dataConferenceEventCallback:(TUP_DATA_CONFERENCE_EVENT_TYPE)conferenceEvent result:(NSDictionary *)resultDictionary;

@end

@protocol DataConferenceChatMessageDelegate <NSObject>

/**
 * This method is used to deel with receiving chat message
 * 收到聊天信息，进行处理
 */
- (void)didReceiveChatMessage:(ChatMsg *)chatMessage;

@end

extern NSString *const TUP_DATACONF_CALLBACK_TYPE_KEY;
extern NSString *const TUP_DATACONF_CALLBACK_RESULT_KEY;

@class DataConfNotification, ConfCameraInfo, DataConfParam;
@protocol DataConferenceInterface <NSObject>

/**
 *Indicates data conference service delegate
 *数据会议业务代理
 */
@property (nonatomic ,weak) id<DataConferenceServiceDelegate> delegate;

/**
 *Indicates data conference chat service delegate
 *数据会议中文字聊天业务代理
 */
@property (nonatomic, weak) id<DataConferenceChatMessageDelegate> chatDelegate;

/**
 *Indicates data conference chat service delegate
 *数据会议中文字聊天业务代理
 */
@property (nonatomic, assign) BOOL isJoinDataConference;

/**
 *Indicates local camera informations
 *本地摄像头信息
 */
@property (nonatomic, strong) NSMutableArray *localCameraInfos;

/**
 *Indicates remote camera informations
 *远端摄像头信息
 */
@property (nonatomic, strong) NSMutableArray *remoteCameraInfos;

/**
 *Indicates current camera informations
 *当前摄像头信息
 */
@property (nonatomic, strong) ConfCameraInfo *currentCameraInfo;

/**
 *Indicates whether show the data bfcp page
 *是否数据bfcp页面开启
 */
@property (nonatomic, assign) BOOL isDataBFCPShow;

/**
 * This method is used to close data conference, must be chairman
 * 主席结束数据会议
 @return BOOL
 */
-(BOOL)closeDataConference;

/**
 * This method is used to kick out user (chairman)
 * 主席剔除与会者
 *@param userId userId
 *@return YES or NO
 */
-(BOOL)kickoutUser:(int)userId;

/**
 * This method is used to handle application resign active
 * 处理应用退出事件
 */
-(void)handleUIApplicationWillResignActiveNotification;

/**
 * This method is used to handle application did become active
 * 处理应用开启事件
 */
- (void)handleUIApplicationDidBecomeActiveNotification;

/**
 * This method is used to config data conference vedio view
 * 配置数据会议本段及远端的视图
 *@param localView Local vedio view
 *@param remoteView Remote vedio view
 @return BOOL
 */
-(BOOL)configDataConfLocalView:(id)localView remoteView:(id)remoteView;

/**
 * This method is used to leave data conference
 * 退出数据会议
 @return BOOL
 */
-(BOOL)leaveDataConference;

/**
 * This method is used to detach video view
 * 端口视频流传输
 *@param cameraInfo ConfCameraInfo value
 *@return YES is success, No is fail
 */
- (BOOL)detachVideoView:(ConfCameraInfo*)cameraInfo;

/**
 * This method is used to send message to all user
 * 发送信息给所有人
 *@param message message
 *@return YES is success, No is fail
 */
-(BOOL)sendIMMessageToAll:(NSString *)message;

/**
 * This method is used to set other user role (chairman)
 * 主席设置与会者角色
 *@param userId userId
 *@param userRole DATACONF_USER_ROLE_TYPE value
 *@return YES or NO
 */
-(BOOL)setRoleToUser:(unsigned int)userId role:(DATACONF_USER_ROLE_TYPE)userRole;

/**
 * This method is used to select camera to watch
 * 选择要光看的摄像头
 *@param cameraInfo ConfCameraInfo value
 */
-(void)selectedCameraInfoToWatch:(ConfCameraInfo *)cameraInfo;

/**
 * This method is used to create data conference
 * 创建数据会议
 *@param dataConfParams TUPDataConfParams value
 *@return YES or NO
 */
-(BOOL)createDataConfObjectWithParams:(DataConfParam *)dataConfParams;

/**
 * This method is used to notify user open camera
 * 打开摄像头
 @param isOpenVideo YES or NO
 @param userId userId
 @return YES or NO
 */
//-(BOOL)confVideoNotifyOpenVideo:(BOOL)isOpenVideo userId:(int)userId;


/**
 * This method is used to open local camera
 * 打开本地摄像头
 @return YES or NO
 */
- (BOOL)openLocalCamera;

/**
 * This method is used to close local camera
 * 关闭本地摄像头
 *@return YES or NO
 */
-(BOOL)closeLocalCamera;

/**
 * This method is used to switch local camera
 * 转换本地摄像头
 *@return YES or NO
 */
- (BOOL)switchLocalCamera;

/**
 * This method is used to play BFCP video view (BFCP by data channel)
 * 播放BFCP视频视图
 @param bfcpVideoView EAGLView value (openGLDataConfView)
 */
- (void)playBfcpVideoView:(id)bfcpVideoView;

/**
 * This method is used to stop data conference BFCP video view showing
 * 暂停BFCP视频视图
 */
- (void)stopBfcpVideoView;

/**
 This method is used to send chat message in data conference.
 在数据会议中发送聊天信息
 *@param message chat message body.
 *@param username mine name in data conference
 *@param userId at p2p chat it represents receiver's user id, at public chat it's ignored
 *@return YES or NO. See call back didReceiveChatMessage:
 */
- (BOOL)chatSendMsg:(NSString *)message
       fromUsername:(NSString *)username
           toUserId:(unsigned int)userId;

/**
 * This method is used to join data conference interface
 * 加入数据会议
 @param joinConfData TUPDataConfParam value
 */
- (void)joinDataConfWithParams:(DataConfParam*)joinConfData;

@end

#endif /* DataConferenceInterface_h */


