//
//  Initializer.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "Initializer.h"
#import "Defines.h"
#import "HuaweiSDKService/login_def.h"
#import "HuaweiSDKService/login_interface.h"
#import "HuaweiSDKService/call_def.h"
#import "HuaweiSDKService/call_interface.h"
#import "HuaweiSDKService/call_advanced_interface.h"
#import "HuaweiSDKService/tup_service_interface.h"
#import "HuaweiSDKService/tup_confctrl_interface.h"
#import <UIKit/UIKit.h>

#define USER_AGENT_TE @"Huawei TE Mobile"

#define VIDEO_FRAMESIZE_DEFAULT 4
#define VIDEO_DATARATE_DEFAULT 768
#define VIDEO_BW_DEFAULT 768
#define VIDEO_FRAMERATE_DEFAULT 20
#define VIDEO_MIN_PORT 10580
#define VIDEO_MAX_PORT 10599

static id<TupLoginNotification> g_loginDelegate = nil;        // login delegate
static id<TupCallNotifacation> g_callDelegate = nil;          // call delegate
static id<TupConfNotifacation> g_confDelegate = nil;          // conference delegate

/**
 * tup_login_register_process_notifiy的接口参数回调LOGIN_FN_CALLBACK_PTR
 */
TUP_VOID onTUPLoginNotifications(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data)
{
    DDLogInfo(@"onTUPLoginNotifications : %#x",msgid);
    if (nil == g_loginDelegate)
    {
        return;
    }
    
    Notification *notification = [[Notification alloc] initWithMsgId:msgid param1:param1 param2:param2 data:data];
    [g_loginDelegate loginModule:LOGIN_UPORTAL_MODULE notification:notification];
}

/**
 * tup_call_register_process_notifiy的接口参数回调CALL_FN_CALLBACK_PTR
 */
TUP_VOID onTupCallCallBack(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, void *data)
{
    Notification *notification = [[Notification alloc] initWithMsgId:msgid param1:param1 param2:param2 data:data];
    
    if (msgid == CALL_E_EVT_SIPACCOUNT_INFO || msgid == CALL_E_EVT_CALL_LOGOUT_NOTIFY || msgid == CALL_E_EVT_FORCEUNREG_INFO || msgid == CALL_E_EVT_NETADDR_NOTIFY_INFO)
    {
        [g_loginDelegate loginModule:LOGIN_SIP_MODULE notification:notification];
    }
    else if (msgid == CALL_E_EVT_SERVERCONF_DATACONF_PARAM)
    {
        [g_callDelegate callModule:CALL_SIP_MODULE notication:notification];
        [g_confDelegate confModule:CALL_SIP_INFO_MODULE notication:notification];
    }
    else if(msgid == CALL_E_EVT_IDO_OVER_BFCP)
    {
        [g_confDelegate confModule:CALL_IDO_BFCP_MODULE notication:notification];
    }
    else if(msgid == CALL_E_EVT_CALL_ENDED)
    {
        [g_confDelegate confModule:CALL_IDO_BFCP_MODULE notication:notification];
        [g_callDelegate callModule:CALL_SIP_MODULE notication:notification];
    }
    else{
        [g_callDelegate callModule:CALL_SIP_MODULE notication:notification];
    }
}

/**
 * tup_confctrl_register_process_notifiy的接口参数回调CONFCTRL_FN_CALLBACK_PTR
 */
TUP_VOID onTupConferenceCallBack(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, void *data)
{
    Notification *confNotify = [[Notification alloc] initWithMsgId:msgid param1:param1 param2:param2 data:data];
    [g_confDelegate confModule:CONF_MODULE notication:confNotify];
}

@implementation Initializer

/**
 * This method is used to register login call back.
 * 设置登陆模块的代理
 *@param loginDelegate TupLoginNotification
 */
+ (void)registerLoginCallBack:(id<TupLoginNotification>)loginDelegate
{
    g_loginDelegate = loginDelegate;
}

/**
 * This method is used to register call call back.
 * 设置呼叫模块的代理
 *@param callDelegate TupCallNotifacation
 */
+ (void)registerCallCallBack:(id<TupCallNotifacation>)callDelegate
{
    g_callDelegate = callDelegate;
}

/**
 * This method is used to register conference call back.
 * 设置会议模块的代理
 *@param confDelegate TupConfNotifacation
 */
+ (void)registerConfCallBack:(id<TupConfNotifacation>)confDelegate
{
    g_confDelegate = confDelegate;
}

/**
 * This method is used to init all tup service.
 * 初始化各个tup模块
 *@param logPath NSString
 *@return BOOL
 */
+ (BOOL)startupWithLogPath:(NSString *)logPath
{
    TUP_RESULT ret_startup = tup_service_startup(NULL);
    if (ret_startup != TUP_SUCCESS) {
        return NO;
    }
    
    BOOL result = [self loginStartupWithLogPath:logPath];
    if (!result) {
        return NO;
    }
    
    result = [self callStartupWithLogPath:logPath];
    if (!result) {
        return NO;
    }
    [self configCallBusiness];
    [self configBFCP];
    
    result = [self confStartupWithLogPath:logPath];
    if (!result) {
        return NO;
    }
    
    return result;
}

/**
 * This method is used to init login service.
 * 初始化登陆模块
 *@param logPath NSString
 *@return BOOL
 */
+ (BOOL)loginStartupWithLogPath:(NSString *)logPath
{
    // init login
    NSString *path = [logPath stringByAppendingString:@"/login"];
    TUP_RESULT startLogResult = tup_login_log_start(LOGIN_E_LOG_DEBUG, 1*1024, 1, [path UTF8String]);
    DDLogInfo(@"tup_login_log_start: %d", startLogResult);
    TUP_RESULT result = tup_login_init("", LOGIN_E_VERIFY_MODE_NONE);
    DDLogInfo(@"tup_login_init: %d", result);
    if (result != TUP_SUCCESS) {
        return NO;
    }
    
    // register call back
    TUP_RESULT ret_register_notify = tup_login_register_process_notifiy(&onTUPLoginNotifications);
    DDLogInfo(@"tup_login_register_process_notifiy: %d", ret_register_notify);
    return ret_register_notify == TUP_SUCCESS;
}

/**
 * This method is used to init call service.
 * 初始化呼叫模块
 *@param logPath NSString
 *@return BOOL
 */
+ (BOOL)callStartupWithLogPath:(NSString *)logPath
{
    // init call
    NSString *path = [logPath stringByAppendingString:@"/call"];
    tup_call_log_start(CALL_E_LOG_DEBUG, 10*1024, 4, (TUP_CHAR*)[path UTF8String]);
    tup_call_hme_log_info(CALL_E_LOG_DEBUG, 10, CALL_E_LOG_DEBUG, 50);
    TUP_RESULT ret_call = tup_call_init();
    if (ret_call != TUP_SUCCESS) {
        DDLogInfo(@"tup_call_init result:%d",ret_call);
        return NO;
    }
    
    TUP_RESULT ret_register_process = tup_call_register_process_notifiy(&onTupCallCallBack);
    DDLogInfo(@"tup_call_register_process_notifiy: %d", ret_register_process);
    return ret_register_process == TUP_SUCCESS;
}


/**
 This method is used to config call business.
 配置呼叫模块业务
 */
+ (void)configCallBusiness
{
    TUP_RESULT configResult = TUP_FAIL;
    TUP_UINT32 envSolution = CALL_E_NET_TE;
    configResult = tup_call_set_cfg(CALL_D_CFG_ENV_SOLUTION, &envSolution);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_ENV_SOLUTION = %d",configResult);
    
    CALL_E_PRODUCT_TYPE mobileType = CALL_E_PRODUCT_TYPE_MOBILE;
    configResult = tup_call_set_cfg(CALL_D_CFG_ENV_PRODUCT_TYPE, &mobileType);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_ENV_PRODUCT_TYPE = %d",configResult);
    
    CALL_E_REJECTCALL_TYPE rejectType = CALL_D_REJECTTYPE_603;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_REJECT_TYPE, &rejectType);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_SIP_REJECT_TYPE = %d",configResult);
    
    
    CALL_E_TRANSPORTMODE transportMode = CALL_E_TRANSPORTMODE_UDP;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_TRANS_MODE, &transportMode);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_SIP_TRANS_MODE = %d",configResult);
    
    TUP_UINT32 sipPort = 5060;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_PORT, &sipPort);
    
    NSString *userAgentStr = USER_AGENT_TE;
    configResult = tup_call_set_cfg(CALL_D_CFG_ENV_USEAGENT, (TUP_VOID *)[userAgentStr UTF8String]);
    
    TUP_UINT32 tlsConfig = CALL_D_TLSVERSION_V1_0 | CALL_D_TLSVERSION_V1_1 | CALL_D_TLSVERSION_V1_2 ;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_TLS_VERSION, &tlsConfig);
    
    TUP_BOOL useMaa = TUP_TRUE;
    configResult = tup_call_set_cfg(CALL_D_CFG_CONF_USE_MAA_CONFCTRL, &useMaa);
    
    CALL_E_AUTH_PASSWD_TYPE pwdType = CALL_E_AUTH_PASSWD_HA1;
    configResult = tup_call_set_cfg(CALL_D_CFG_ACCOUNT_PASSWORD_TYPE, &pwdType);
    
    TUP_BOOL rotate_mode = TUP_TRUE;
    TUP_RESULT ret_rotate_mode = tup_call_set_cfg(CALL_D_CFG_VIDEO_CAP_ROTATE_CTRL_MODE, &rotate_mode);
    
    
    CALL_S_VIDEO_HDACCELERATE hdacc;
    memset_s(&hdacc, sizeof(CALL_S_VIDEO_HDACCELERATE), 0, sizeof(CALL_S_VIDEO_HDACCELERATE));
    TUP_RESULT ret_get_hdacc = tup_call_media_get_hdaccelerate(&hdacc);

    
    hdacc.ulHdDecoder = 0;
    TUP_RESULT ret_hdacc = tup_call_set_cfg(CALL_D_CFG_VIDEO_HDACCELERATE, (TUP_VOID *)&hdacc);;
    
    CALL_S_VIDEO_DATARATE datarateS;
    memset_s(&datarateS, sizeof(CALL_S_VIDEO_DATARATE), 0, sizeof(CALL_S_VIDEO_DATARATE));
    datarateS.ulDataRate = VIDEO_DATARATE_DEFAULT;
    datarateS.ulMaxBw = VIDEO_BW_DEFAULT;
    TUP_RESULT ret_video_data_rate = tup_call_set_cfg(CALL_D_CFG_VIDEO_DATARATE, &datarateS);

    CALL_S_VIDEO_FRAMESIZE framesizeS;
    memset_s(&framesizeS, sizeof(CALL_S_VIDEO_FRAMESIZE), 0, sizeof(CALL_S_VIDEO_FRAMESIZE));
    framesizeS.uiFramesize = VIDEO_FRAMESIZE_DEFAULT;
    framesizeS.uiDecodeFrameSize = VIDEO_FRAMESIZE_DEFAULT;
    TUP_RESULT ret_frame_size = tup_call_set_cfg(CALL_D_CFG_VIDEO_FRAMESIZE, &framesizeS);
    
    CALL_S_VIDEO_FRAMERATE framerateS;
    memset_s(&framerateS, sizeof(framerateS), 0, sizeof(framerateS));
    framerateS.uiFrameRate = VIDEO_FRAMERATE_DEFAULT;
    framerateS.uiMinFrameRate = 10;
    TUP_RESULT ret_frame_rate = tup_call_set_cfg(CALL_D_CFG_VIDEO_FRAMERATE, &framerateS);
    
    CALL_S_RTP_PORT_RANGE portRange;
    portRange.ulMinPort = 10580;
    portRange.ulMaxPort = 10599;
    TUP_RESULT ret_port_range = tup_call_set_cfg(CALL_D_CFG_VIDEO_PORT_RANGE, &portRange);
    
    TUP_UINT32 videoDSCP = 0;//(TUP_UINT32)maaInfo.videoDSCP;;
    TUP_RESULT ret_video_dscp = tup_call_set_cfg(CALL_D_CFG_DSCP_VIDEO, &videoDSCP);
    
    TUP_UINT32 fec = 0;
    TUP_RESULT ret_fec = tup_call_set_cfg(CALL_D_CFG_VIDEO_ERRORCORRECTING, &fec);
    
    TUP_UINT32 netLossRate = 100;
    TUP_RESULT ret_netLossRate = tup_call_set_cfg(CALL_D_CFG_VIDEO_NETLOSSRATE, &netLossRate);
    
    TUP_UINT32 keyframeInterval = 5;
    TUP_RESULT ret_keyFrameInterval = tup_call_set_cfg(CALL_D_CFG_VIDEO_KEYFRAMEINTERVAL, &keyframeInterval);
    
    TUP_UINT32 tactic = 0;
    TUP_RESULT ret_tactic = tup_call_set_cfg(CALL_D_CFG_VIDEO_TACTIC, &tactic);
    
    CALL_S_VIDEO_ARS ars;
    ars.bArs = 1;
    ars.bArsCtrlFec = 1;
    ars.bArsCtrlBitRate = 1;
    ars.ulMaxFecProFac = 0;
    ars.bArsCtrlFrameRate = 1;
    ars.bArsCtrlFrameSize = 1;
    TUP_RESULT ret_ars = tup_call_set_cfg(CALL_D_CFG_VIDEO_ARS, &ars);
    
    TUP_BOOL force_single_pt = TUP_TRUE;
    TUP_RESULT ret_pt = tup_call_set_cfg(CALL_D_CFG_VIDEO_H264_FORCE_SINGLE_PT, &force_single_pt);
    
    TUP_BOOL isNetAddrEnable = TUP_TRUE;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_ENABLE_CORPORATE_DIRECTORY,&isNetAddrEnable);
    DDLogInfo(@"tup_call_set_cfg:CALL_D_CFG_SIP_ENABLE_CORPORATE_DIRECTORY  configResult = %#x",configResult);
    
   
}

/**
 This method is used to config BFCP business.
 配置辅流模块业务
 */
+ (void)configBFCP
{
    //bfcp开关设置
    TUP_BOOL bfcp_enable = TUP_TRUE;
    TUP_RESULT ret_bfcp_enable = tup_call_set_cfg(CALL_D_CFG_MEDIA_ENABLE_BFCP, &bfcp_enable);
    
    //辅流媒体开关设置
    TUP_BOOL media_enable_data = TUP_TRUE;
    TUP_RESULT ret_media_enable_data = tup_call_set_cfg(CALL_D_CFG_MEDIA_ENABLE_DATA, &media_enable_data);
    
//    //bfcp端口设置
//    CALL_S_BFCP_PORT_RANGE bfcpPortRange;
//    HW_MEMSET(&bfcpPortRange, sizeof(CALL_S_BFCP_PORT_RANGE), 0, sizeof(CALL_S_BFCP_PORT_RANGE));
//    bfcpPortRange.ulMinPort = (TUP_UINT32)[maaInfo.bfcpPort integerValue];
//    bfcpPortRange.ulMaxPort = (TUP_UINT32)([maaInfo.bfcpPort integerValue] + 20);//最大端口号在最小端口号上加20，跟TE移动端保持一致
//    bfcpPortRange.ulTlsPort = 0;
//    TUP_RESULT ret_port_range = tup_call_set_cfg(CALL_D_CFG_BFCP_PORT_RANGE, &bfcpPortRange);
    
    //辅流参数设置
//    CALL_S_BFCP_PARAM bfcpParam;
//    HW_MEMSET(&bfcpParam, sizeof(CALL_S_BFCP_PARAM), 0, sizeof(CALL_S_BFCP_PARAM));
//    bfcpParam.uiTransType = (TUP_UINT32)maaInfo.bfcpTransport;  //1 UDP, 2 TCP;
//    bfcpParam.uiFloorCtrl = 3;  //1 c-only, 2 s-only, 3 c-s  //跟TE移动端保持一致
//    bfcpParam.uiSetup = 3;      //1 active, 2passive, 3 actpass  //跟TE移动端保持一致
//    TUP_RESULT ret_bfcp_param = tup_call_set_cfg(CALL_D_CFG_BFCP_PARAM, &bfcpParam);
    
    //辅流视频分辨率设置
    CALL_S_VIDEO_FRAMESIZE bfcpVideoFrameSize;
    memset(&bfcpVideoFrameSize, 0, sizeof(CALL_S_VIDEO_FRAMERATE));
    bfcpVideoFrameSize.uiFramesize = 3;//虽然没有发送，但是需要使用到编码发送空包实现类似心跳，所以需要配置，这里配置CIF进行保证
    bfcpVideoFrameSize.uiDecodeFrameSize = 16;
    TUP_RESULT ret_bfcp_video_frame_size = tup_call_set_cfg(CALL_D_CFG_DATA_FRAMESIZE, &bfcpVideoFrameSize);
    
    //辅流视频帧率设置
    CALL_S_VIDEO_FRAMERATE bfcpVideoFrameRate;
    memset(&bfcpVideoFrameRate, 0, sizeof(CALL_S_VIDEO_FRAMERATE));
    bfcpVideoFrameRate.uiFrameRate = 3;
    bfcpVideoFrameRate.uiMinFrameRate = 1;
    TUP_RESULT ret_bfcp_video_rate = tup_call_set_cfg(CALL_D_CFG_DATA_FRAMERATE, &bfcpVideoFrameRate);
    
    //端口为视频端口基础上加2
    CALL_S_RTP_PORT_RANGE portRange;
    memset(&portRange, 0, sizeof(CALL_S_RTP_PORT_RANGE));
    portRange.ulMinPort = VIDEO_MIN_PORT + 2;
    portRange.ulMaxPort = VIDEO_MAX_PORT + 2;
    TUP_RESULT ret_portRange = tup_call_set_cfg(CALL_D_CFG_DATA_PORT_RANGE, &portRange);
    
    CALL_S_VIDEO_LEVEL dataLevel;
    memset(&dataLevel, 0, sizeof(CALL_S_VIDEO_LEVEL));
    dataLevel.ulLevel = 40;
    dataLevel.ulMaxMBPS = 27000;
    dataLevel.ulMaxFS = 9000;  //支持1920*1200解码
    
    TUP_RESULT ret_data_level = tup_call_set_cfg(CALL_D_CFG_DATA_LEVEL, &dataLevel);
    
    NSString *dataCodecValue = @"106";
    TUP_RESULT ret_dataCodec = tup_call_set_cfg(CALL_D_CFG_DATA_CODEC, (TUP_VOID *)[dataCodecValue UTF8String]);
    
    //    CALL_D_CFG_DATA_ARQ //辅流丢包重传、TE写死关闭的
    TUP_BOOL data_arq = TUP_FALSE;
    TUP_RESULT ret_data_arq = tup_call_set_cfg(CALL_D_CFG_DATA_ARQ, &data_arq);
}

/**
 * This method is used to init conference service.
 * 初始化会议模块
 *@param logPath NSString
 *@return BOOL
 */
+ (BOOL)confStartupWithLogPath:(NSString *)logPath
{
    NSString *path = [logPath stringByAppendingString:@"/conference"];
    tup_confctrl_log_config(3, 10*1024, 4, (TUP_CHAR*)[path UTF8String]);
    int ret_meeting = tup_confctrl_init();
    DDLogInfo(@"tup_confctrl_init result %d", ret_meeting);
    
    CONFCTRL_S_INIT_PARAM param;
    param.bWaiMsgpThread = TUP_TRUE;
    param.bBatchUpdate = TUP_FALSE;
    param.bConnectCall = TUP_TRUE;
    param.bSaveParticipantList = TUP_TRUE;
    param.ulConfListMaxNum = 0;
    param.ulParaticipantMaxNum = 0;
    int result = tup_confctrl_set_init_param(&param);
    DDLogInfo(@"tup_confctrl_set_init_param result :%d",result);
    
    if (ret_meeting != TUP_SUCCESS || result != TUP_SUCCESS) {
        return NO;
    }
    
    TUP_RESULT ret_register_notify = tup_confctrl_register_process_notifiy(&onTupConferenceCallBack);
    DDLogInfo(@"tup_confctrl_register_process_notifiy: %d", ret_register_notify);
    return ret_register_notify == TUP_SUCCESS;
}

@end
