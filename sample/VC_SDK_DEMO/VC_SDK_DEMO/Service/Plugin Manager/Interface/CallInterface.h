//
//  CallInterface.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#ifndef CallInterface_h
#define CallInterface_h

#import "Defines.h"
#import "CallInfo.h"
#import "HuaweiSDKService/TupHistory.h"

extern NSString *const NTF_AUDIOROUTE_CHANGED; // audio route changed notification

@protocol CallServiceDelegate <NSObject>
@optional

/**
 * This method is used to deel call event callback
 * 呼叫事件回调
 *@param callEvent             Indicates TUP_CALL_EVENT_TYPE enum value
 *                             呼叫事件类型
 *@param resultDictionary      result value
 *                             回调信息集
 */
-(void)callEventCallback:(TUP_CALL_EVENT_TYPE)callEvent result:(NSDictionary *)resultDictionary;

@end

@protocol CallInterface <NSObject>

/**
 *Indicates call service delegate
 *呼叫业务代理
 */
@property (nonatomic, assign) id<CallServiceDelegate> delegate;

@property (nonatomic, strong) TupHistory * currentHRecord;

/**
 *Indicates global sip account
 *全局的sip账号
 */
@property (nonatomic, copy)NSString *sipAccount;

/**
 *Indicates whether show conf bfcp page
 *是否显示会议bfcp界面
 */
@property (nonatomic, assign)BOOL isShowTupBfcp;


/**
 * This method is used to config bussiness token
 * 配置业务token
 *@param sipAccount         Indicates sip account
 *                          sip账号
 *@param token              Indicates token
 *                          鉴权token
 */
- (void)configBussinessAccount:(NSString *)sipAccount
                         token:(NSString *)token;

/**
 * This method is used to config video window local view
 * 配置视频本地窗口画面
 *@param localView          Indicates local view
 *                          本地视图
 *@param remoteView         Indicates remote view
 *                          远端试图
 *@param bfcpView           Indicates bfcp view
 *                          bfcp试图
 *@param callId             Indicates call id
 *                          呼叫id
 *@return YES or NO
 */
-(BOOL)configVideoWindowLocalView:(id)localView
                       remoteView:(id)remoteView
                         bfcpView:(id)bfcpView
                           callId:(unsigned int)callId;

/**
 * This method is used to update video window local view
 * 更新视频本地窗口画面
 *@param localVideoView     Indicates local video view
 *                          本地视频视图
 *@param remoteVideoView    Indicates remote video view
 *                          远端视频试图
 *@param bfcpVideoView      Indicates bfcp video view
 *                          bfcp视频试图
 *@param callId             Indicates call id
 *                          呼叫id
 *@return YES or NO
 */
- (BOOL)updateVideoWindowWithLocal:(id)localVideoView
                         andRemote:(id)remoteVideoView
                           andBFCP:(id)bfcpVideoView
                            callId:(unsigned int)callId;

/**
 * This method is used to get call info with confId
 * 用confid获取呼叫信息
 *@param confId              Indicates conference Id
 *                           会议id
 *@return call Info          Return call info
 *                           返回值为呼叫信息
 *@return YES or NO
 */
- (CallInfo *)callInfoWithConfId:(NSString *)confId;

/**
 * This method is used to config video orient and index with call id
 * 使用callid配置视频横竖屏以及序号
 *@param callid callId       Indicates call id
 *                           呼叫id
 */
- (void)configVideoOrientAndIndexWithCallId:(unsigned int)callid;

/**
 * This method is used to open video preview, default open front camera
 * 打开视频预览,默认打开前置摄像头
 *@param cameraIndex         Indicates camera index
 *                           视频摄像头序号
 *@param viewHandler         Indicates view handle
 *                           视图句柄
 *@return YES or NO
 */
- (BOOL)videoPreview:(unsigned int)cameraIndex toView:(id) viewHandler;

/**
 * This method is used to close video preview
 *关闭视频预览
 */
- (void)stopVideoPreview;

/**
 *This method is used to start EC access number to join conference
 *EC接入码入会
 *@param confid                  Indicates confid
 *                               会议Id
 *@param acceseNum               Indicates accese number
 *                               会议接入码
 *@param psw                     Indicates password
 *                               会议密码
 *@return unsigned int           Return call id, equal zero mean start call fail.
 *                               返回呼叫id,失败返回0
 */
- (unsigned int) startECAccessCallWithConfid:(NSString *)confid AccessNum:(NSString *)acceseNum andPsw:(NSString *)psw;

/**
 *This method is used to start point to point audio call or video call
 *发起音视频呼叫
 *@param number                  Indicates number
 *                               呼叫的号码
 *@param callType audio/video    Indicates call type
 *                               呼叫类型
 *@return unsigned int           Return call id, equal zero mean start call fail.
 *                               返回呼叫id,失败返回0
 */
- (unsigned int) startCallWithNumber:(NSString *) number type:(TUP_CALL_TYPE) callType;

/**
 *This method is used to answer the incoming call, select audio or video call
 *接听呼叫
 *@param callType                Indicates call type
 *                               呼叫类型
 *@param callId                  Indicate call id
 *                               呼叫id
 *@return YES or NO
 */
- (BOOL) answerComingCallType:(TUP_CALL_TYPE)callType callId:(unsigned int)callId;

/**
 *This method is used to end call
 *结束通话
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES or NO
 */
-(BOOL)closeCall:(unsigned int)callId;

/**
 *This method is used to reply request of adding video call
 *回复是否接受音频转视频
 *@param accept                  Indicates whether accept
 *                               是否接受
 *@param callId                  Indicates call id
 *                               呼叫Id
 @return YES is success,NO is fail
 */
-(BOOL)replyAddVideoCallIsAccept:(BOOL)accept  callId:(unsigned int)callId;

/**
 *This method is used to upgrade audio to video call
 *将音频呼叫升级为视频呼叫
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)upgradeAudioToVideoCallWithCallId:(unsigned int)callId;

/**
 *This method is used to transfer video call to audio call
 *将视频呼叫转为音频呼叫
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)downgradeVideoToAudioCallWithCallId:(unsigned int)callId;

/**
 * This method is used to rotation camera capture
 * 转换摄像头采集
 *@param ratation                Indicates camera rotation {0,1,2,3}
 *                               旋转摄像头采集
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)rotationCameraCapture:(NSUInteger)ratation callId:(unsigned int)callId;

/**
 * This method is used to rotation Video display
 * 旋转摄像头显示
 *@param orientation             Indicates camera orientation
 *                               旋转摄像头采集
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES is success, NO is fail
 */
-(BOOL)rotationVideoDisplay:(NSUInteger)orientation callId:(unsigned int)callId;

/**
 * This method is used to switch camera index
 * 切换摄像头
 *@param cameraCaptureIndex      Indicates camera capture index, Fort -1 Back -0
 *                               摄像头序号
 *@param callId                  Indicates call id
 *                               呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)switchCameraIndex:(NSUInteger)cameraCaptureIndex callId:(unsigned int)callId;

/**
 * This method is used to switch camera open or close
 * 切换摄像头开关
 *@param openCamera               Indicates open camera, YES:open NO:close
 *                                是否打开摄像头
 *@param callId                   Indicates call id
 *                                呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)switchCameraOpen:(BOOL)openCamera callId:(unsigned int)callId;

/**
 * This method is used to deal with video streaming, app enter background or foreground
 * 在app前后景切换时,控制视频流
 *@param active                    Indicates active YES: goreground NO: background
 *                                 触发行为
 *@param callId                    Indicates call id
 *                                 呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)controlVideoWhenApplicationResignActive:(BOOL)active callId:(unsigned int)callId;

/**
 * This method is used to play WAV music file
 * 播放wav音乐文件
 *@param filePath                  Indicates file path
 *                                 文件路径
 *@return YES is success,NO is fail
 */
-(BOOL)mediaStartPlayWithFile:(NSString *)filePath;

/**
 * This method is used to stop play music
 * 停止播放铃音
 *@return YES is success,NO is fail
 */
-(BOOL)mediaStopPlay;

/**
 * This method is used to switch mute micphone
 * 打开或者关闭麦克风
 *@param mute                      Indicates switch microphone, YES is mute,NO is unmute
 *                                 打开或者关闭麦克风
 *@param callId                    Indicates call id
 *                                 呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)muteMic:(BOOL)mute callId:(unsigned int)callId;

/**
 * This method is used to switch mute speak
 * 打开或者关闭扬声器
 *@param mute                      Indicates switch speak, YES is mute,NO is unmute
 *                                 打开或者关闭扬声器
 *@param callId                    Indicates call id
 *                                 呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)muteSpeak:(BOOL)mute callId:(unsigned int)callId;

/**
 * This method is used to pause video capture
 * 暂停视频采集
 *@param pause                     Indicates whether pause video capture, YES: pause NO:recovery
 *                                 是否暂停视频采集
 *@param callId                    Indicates call id
 *                                 呼叫id
 *@return YES is success,NO is fail
 */
-(BOOL)pauseVideoCapture:(BOOL)pause callId:(unsigned int)callId;

/**
 * This method is used to get device list
 * 获取设备列表
 *@param deviceType                 Indicates device type,see CALL_E_DEVICE_TYPE
 *                                  设备类型，参考CALL_E_DEVICE_TYPE
 *@return YES is success,NO is fail
 */
-(BOOL)obtainDeviceListWityType:(DEVICE_TYPE)deviceType;

/**
 * This method is used to set audio route
 * 设置音频路线
 *@param route                      Indicates audio route, see ROUTE_TYPE enum value
 *                                  音频路线
 *@return YES is success,NO is fail. Call back see NTF_AUDIOROUTE_CHANGED
 */
-(BOOL)configAudioRoute:(ROUTE_TYPE)route;

/**
 * This method is used to get audio route
 * 获取音频路线
 *@return ROUTE_TYPE
 */
-(ROUTE_TYPE)obtainMobileAudioRoute;

/**
 * This method is used to send DTMF
 * 发送dtmf
 *@param number                      Indicates dtmf number, 0-9 * #
 *                                   dtmf号码
 *@param callId                      Indicates call id
 *                                   呼叫id
 *@return YES is success,NO is fail
 */
- (BOOL)sendDTMFWithDialNum:(NSString *)number callId:(unsigned int)callId;
/**
 *[en[This method is used to uninit call service
 * 去初始化呼叫业务
 *@return YES or NO
 */
-(BOOL)unloadCallService;

/**
 * This method is used to hang up all call.
 * 挂断所有呼叫
 */
- (void)hangupAllCall;

/**
 * This method is used to stop bfcp capability
 * 暂停bfcp能力
 *@param callid                      Indicates call id
 *                                   呼叫id
 */
- (BOOL)stopTupBfcpCapabilityWithCallId:(unsigned int)callid;

@end


#endif /* CallInterface_h */


