//
//  ConferenceService.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ConferenceService.h"
#import "HuaweiSDKService/tup_confctrl_interface.h"
#import "HuaweiSDKService/tup_confctrl_def.h"
#import "HuaweiSDKService/tup_confctrl_interface.h"
#import "HuaweiSDKService/tup_conf_basedef.h"
#include <arpa/inet.h>
#import <netdb.h>
#import <sys/socket.h>
#import <string.h>
#import "ECConfInfo+StructParase.h"
#import "ConfAttendee+StructParase.h"
#import "ManagerService.h"
#import "ConfData.h"
#import "ECCurrentConfInfo.h"
#import "ConfAttendeeInConf.h"
#import "ConfStatus.h"
#import "Initializer.h"
#import "LoginInfo.h"
#import "LoginServerInfo.h"
#import "DataConfParam.h"
#import "DataConfParam+StructParse.h"
#import "Defines.h"
#import "DataParamSipInfo.h"
#import "LoginAuthorizeInfo.h"
#import "VCConfUpdateInfo.h"
#import "VCAttendee.h"
#import "CommonUtils.h"

@interface ConferenceService()<TupConfNotifacation>

@property (nonatomic, assign) int confHandle;                     // current confHandle
@property (nonatomic, assign) NSString *dataConfIdWaitConfInfo;   // get current confId
@property (nonatomic, copy)NSString *sipAccount;                  // current sipAccount
@property (nonatomic, copy)NSString *account;                     // current account
@property (nonatomic, strong) NSString *confCtrlUrl;              // recorde dateconf_uri
@property (nonatomic, strong) DataParamSipInfo *dataParam;        // recorde DataParamSipInfo from sipInfo
@property (nonatomic, assign) BOOL isNeedDataConfParam;           // has getDataConfParam or not
@property (nonatomic, strong) NSMutableDictionary *confTokenDic;  // update conference token in SMC
@property (nonatomic, assign) BOOL hasReportMediaxSpeak;          // has reportMediaxSpeak or not in Mediax
@property (nonatomic, assign) int networkType;

@property (nonatomic, assign) int terminalDataRate;
@property (nonatomic, assign) int hasDataConf;
@property (nonatomic, assign) int mediaType;
@property (nonatomic, strong) VCAttendee *vcAttendee;
@property (nonatomic, assign) int BroadcastingT;
@end

@implementation ConferenceService

//creat getter and setter method of delegate
@synthesize delegate;

//creat getter and setter method of isJoinDataConf
@synthesize isJoinDataConf;

@synthesize isFirstJumpToRunningView;

//creat getter and setter method of haveJoinAttendeeArray
@synthesize haveJoinAttendeeArray;

//creat getter and setter method of uPortalConfType
@synthesize uPortalConfType;

//creat getter and setter method of selfJoinNumber
@synthesize selfJoinNumber;

//creat getter and setter method of dataConfParamURLDic
@synthesize dataConfParamURLDic;

/**
 *This method is used to get sip account from call service
 *从呼叫业务获取sip账号
 */
-(NSString *)sipAccount
{
    LoginAuthorizeInfo *mine = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    _account = mine.loginAccount;
    
    return _account;
}

/**
 *This method is used to get login account from login service
 *从登陆业务获取鉴权登陆账号
 */
- (NSString *)account
{
    LoginAuthorizeInfo *mine = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    _account = mine.loginAccount;
    
    return _account;
}

/**
 *This method is used to init this class， give initial value
 *初始化方法，给变量赋初始值
 */
-(instancetype)init
{
    if (self = [super init])
    {
        [Initializer registerConfCallBack:self]; //注册回调，将回调消息分发代理设置为自己
        self.isJoinDataConf = NO;
        _confHandle = 0;
        self.haveJoinAttendeeArray = [[NSMutableArray alloc] init]; //会议与会者列表
        self.uPortalConfType = CONF_TOPOLOGY_SMC;
        _confTokenDic = [[NSMutableDictionary alloc]init];
        _confCtrlUrl = nil;
        _isNeedDataConfParam = YES;
        self.selfJoinNumber = nil;
        self.dataConfParamURLDic = [[NSMutableDictionary alloc]init];
        _hasReportMediaxSpeak = NO;
        self.isFirstJumpToRunningView = YES;
        _BroadcastingT = -1;
    }
    return self;
}

#pragma mark - EC 6.0

/**
 *This method is used to uninit conf
 *会议去初始化
 */
-(void)uninitConfCtrl
{
    tup_confctrl_uninit();
}

/**
 * This method is used to deel conference event callback from service
 * 分发回控业务相关回调
 *@param module TUP_MODULE
 *@param notification Notification
 */
- (void)confModule:(TUP_MODULE)module notication:(Notification *)notification
{
    if (module == CONF_MODULE) {
        [self onRecvTupConferenceNotification:notification];
    }else if (module == CALL_SIP_INFO_MODULE) {
        [self onReceiveTupCallSipInfoNotification:notification];
    }else if(module = CALL_IDO_BFCP_MODULE){
        [self onReceiveBFCPNotification:notification];
    }else {
        
    }
}

-(void)onReceiveBFCPNotification :(Notification *)notify
{
    switch (notify.msgId){
        case CALL_E_EVT_IDO_OVER_BFCP:
        {
            DDLogInfo(@"ido over bfcp carry call id is _ %d",notify.param1);
            DDLogInfo(@"ido over bfcp carry is use bfcp _ %d",notify.param2);
            NSNumber *callId = [NSNumber numberWithInt:notify.param1];
            [CommonUtils userDefaultSaveValue:callId forKey:@"confCallId"];
            if(notify.param2){
                CONFCTRL_MCUConfInfo mcuConfInfo;
                memset(&mcuConfInfo, 0, sizeof(CONFCTRL_MCUConfInfo));
                mcuConfInfo.udwCallID = notify.param1;
                mcuConfInfo.udwCallProtType = CALL_E_PROTOCOL_SIP;
                //        mcuConfInfo.pucPasscode = (TUP_CHAR*)[self.chairPasscode UTF8String];
                //        DDLogInfo(@"chair passcode is %@",self.chairPasscode);
                mcuConfInfo.pucLocalName = (TUP_CHAR*)[[self sipAccount] UTF8String];
                if(!_confHandle && NULL != &mcuConfInfo){
                    TUP_RESULT ret = tup_confctrl_create_conf_handle((TUP_VOID*)&mcuConfInfo, (TUP_UINT32*)&_confHandle);
                    DDLogInfo(@"tup_confctrl_create_conf_handle result: %d, confhandle: %d",ret,_confHandle);
                }
                //        _vcCallId = notify.param1;
            }
        }
            break;
        case CALL_E_EVT_CALL_ENDED:
        {
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)notify.data;
            BOOL isConfCall = callInfo->bIsFocus;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithBool:isConfCall]
                                         };
            if(isConfCall){
                [self respondsECConferenceDelegateWithType:CONF_E_END_RESULT result:resultInfo];
                [self restoreConfParamsInitialValue];
                
            }
        }
            break;
        default:
            break;
    }

}


/**
 *This is a notification from call service, when create a data conf, there will have this notification, it carry some param can use to get big param for data conf
 *创会时如果是数据会议会收到该回调，从中获得小参数去获取数据会议大参数
 */
- (void)onReceiveTupCallSipInfoNotification :(Notification *)notify
{
    DDLogInfo(@"CALL_E_EVT_SERVERCONF_DATACONF_PARAM");
    CALL_S_DATACONF_PARAM *dataConfParam = (CALL_S_DATACONF_PARAM *)notify.data;
    DDLogInfo(@"dataConfParam->acAuthKey: %s,dataConfParam->acCharman: %s,dataConfParam->acCmAddr: %s,dataConfParam->acConfUrl: %s,dataConfParam->acGroupUri: %s,dataConfParam->acPassCode: %s,dataConfParam->acConfctrlRandom: %s,dataConfParam->acDataConfID: %s,dataConfParam->acExtConfType: %s,dataConfParam->ulCallID: %d,dataConfParam->ulConfID: %d",dataConfParam->acAuthKey,dataConfParam->acCharman,dataConfParam->acCmAddr,dataConfParam->acConfUrl,dataConfParam->acGroupUri,dataConfParam->acPassCode,dataConfParam->acConfctrlRandom,dataConfParam->acDataConfID,dataConfParam->acExtConfType,dataConfParam->ulCallID,dataConfParam->ulConfID);
    
    self.dataParam = [DataParamSipInfo paraseFromInfoStruct:dataConfParam];
    
    NSString *confID = [NSString stringWithUTF8String:dataConfParam->acDataConfID];
    DDLogInfo(@"CONFID:%@",confID);
    NSString *confPwd = [NSString stringWithUTF8String:dataConfParam->acPassCode];

    if (!self.selfJoinNumber) {
        self.selfJoinNumber = self.sipAccount;
    }
    LoginAuthorizeInfo *mine = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    confID = [CommonUtils getUserDefaultValueWithKey:@"smcConfId"];
    NSString *confCtrlRandom = [NSString stringWithUTF8String:dataConfParam->acConfctrlRandom];
    if(_isNeedDataConfParam){
        if ([self isUportalSMCConf]) {
            [self getConfDataparamsWithType:UportalDataConfParamGetTypePassCode
                                dataConfUrl:mine.smcUrl
                                     number:mine.loginAccount
                                        pCd:confID
                                     confId:_dataParam.dataConfId
                                        pwd:_dataParam.passCode
                                 dataRandom:_dataParam.dataRandom];
        }else if([self isUportalMediaXConf]){
            if (1 == dataConfParam->bP2PDataConf) {
                [self getConfDataparamsWithType:UportalDataConfParamGetTypeConfIdPassWordRandom
                                    dataConfUrl:_dataParam.dataConfUrl
                                         number:nil
                                            pCd:_dataParam.passCode
                                         confId:_dataParam.dataConfId
                                            pwd:_dataParam.passCode
                                     dataRandom:_dataParam.dataRandom];
            }
        }else{
            
        }
    }

    _dataConfIdWaitConfInfo = confID;
}

/**
 * This method is used to deel conference event notification
 * 处理回控业务回调
 *@param notify
 */
- (void)onRecvTupConferenceNotification:(Notification *)notify
{
    DDLogInfo(@"onReceiveConferenceNotification msgId : %d",notify.msgId);
    switch (notify.msgId)
    {
        case CONFCTRL_E_EVT_CONFCTRL_CONNECTED:   //vc模式下 会议接通上报回调
        {
            DDLogInfo(@"CONFCTRL_E_EVT_CONFCTRL_CONNECTED, confhandle: %d",notify.param1);
            _confHandle = notify.param1;
            _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO;
        }
            break;
        case CONFCTRL_E_EVT_END_CONF_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_END_CONF_RESULT");
//            [self restoreConfParamsInitialValue];
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithBool:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_END_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_GET_CONF_INFO_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_GET_CONF_INFO_RESULT result: %d",notify.param1);
            [self handleGetConfInfoResult:notify];
        }
            break;
        case CONFCTRL_E_EVT_GET_CONF_LIST_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_GET_CONF_LIST_RESULT");
            [self handleGetConfListResult:notify];
        }
            break;
        case CONFCTRL_E_EVT_BOOK_CONF_RESULT:  //vc 预约会议成功上报回调
        {
            DDLogInfo(@"CONFCTRL_E_EVT_BOOK_CONF_RESULT result :%d",notify.param1);
        }
            break;
        case CONFCTRL_E_EVT_SUBSCRIBE_CONF_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_SUBSCRIBE_CONF_RESULT handle: %d, result:%d",notify.param1,notify.param2);
            
        }
            break;
        case CONFCTRL_E_EVT_ATTENDEE_UPDATE_IND:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_ATTENDEE_UPDATE_IND, confhandle: %d", notify.param1);
            [self handleVCAttendeeUpdateNotify:notify];
            TE_ATTENDEE_DATA_IN_LIST *attendeeList = (TE_ATTENDEE_DATA_IN_LIST *)notify.data;
            DDLogInfo(@".......... %d", attendeeList->ucGetName);
            DDLogInfo(@".......... %@", [NSString stringWithUTF8String:attendeeList->aucName]);
            DDLogInfo(@".......... %d", attendeeList->ucT);
        }
            break;
        case CONFCTRL_E_EVT_ADD_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_ADD_ATTENDEE_RESULT result is : %d",notify.param2);
            BOOL result = TUP_SUCCESS == notify.param2 ? YES : NO;
            DDLogInfo(@"result is :%d",result);
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithBool:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_ADD_ATTENDEE_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_MUTE_CONF_RESULT:
        {
            TUP_BOOL *resultBool = (TUP_BOOL *)notify.data;
            DDLogInfo(@"CONFCTRL_E_EVT_MUTE_CONF_RESULT result : %d, mute: %d",notify.param2,resultBool[0]);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_MUTE_KEY: [NSNumber numberWithBool:resultBool[0]],
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_MUTE_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_DEL_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_DEL_ATTENDEE_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_DELETE_ATTENDEE_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_HANGUP_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_HANGUP_ATTENDEE_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_HANGUP_ATTENDEE_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_FLOOR_ATTENDEE_IND:
        {
//            Speaker report in this place
            TE_FLOOR_ATTENDEE *floorAttendee = (TE_FLOOR_ATTENDEE *)notify.data;
            if(floorAttendee!=NULL){
                NSNumber* sperkerT = [NSNumber numberWithInt:floorAttendee->ucT];
                NSDictionary *resultInfo = @{
                                             ECCONF_SPEAKERLIST_KEY : sperkerT
                                             };
                [self respondsECConferenceDelegateWithType:CONF_E_SPEAKER_LIST result:resultInfo];

            }
        }
            break;
        case CONFCTRL_E_EVT_HANDUP_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_HANDUP_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_RAISEHAND_ATTENDEE_RESULT result:resultInfo];
            
        }
            break;
        case CONFCTRL_E_EVT_MUTE_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_MUTE_ATTENDEE_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_MUTE_ATTENDEE_RESULT result:resultInfo];
            
        }
            break;
        case CONFCTRL_E_EVT_REALSE_CHAIRMAN_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_REALSE_CHAIRMAN_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            if(result && _vcAttendee){
                _vcAttendee = nil;
            }
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_RELEASE_CHAIRMAN_RESULT result:resultInfo];;
        }
            break;
        case CONFCTRL_E_EVT_REQ_CHAIRMAN_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_REQ_CHAIRMAN_RESULT result is : %d",notify.param2);
//            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
//            NSDictionary *resultInfo = @{
//                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
//                                         };
//            [self respondsECConferenceDelegateWithType:CONF_E_REQUEST_CHAIRMAN_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_CHAIRMAN_IND:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_CHAIRMAN_IND have chair  : %d",notify.param2);
            CONFCTRL_S_ATTENDEE_VC *attendeeVC = (CONFCTRL_S_ATTENDEE_VC *)notify.data;
            if(!_vcAttendee){
                _vcAttendee = [[VCAttendee alloc]init];
            }
            _vcAttendee.mcuNum = attendeeVC->ucMcuNum;
            _vcAttendee.terminalNum = attendeeVC->ucTerminalNum;
            BOOL haveChair = notify.param2;
            if(haveChair){
                NSDictionary *resultInfo = @{
                                             ECCONF_RESULT_KEY : _vcAttendee
                                             };
                [self respondsECConferenceDelegateWithType:CONF_E_REQUEST_CHAIRMAN_RESULT result:resultInfo];
            }
        }
            break;
        case CONFCTRL_E_EVT_LOCK_CONF_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_LOCK_CONF_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_LOCK_STATUS_CHANGE result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_CALL_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_CALL_ATTENDEE_RESULT result is : %d",notify.param2);
        }
            break;
        case CONFCTRL_E_EVT_REQUEST_CONF_RIGHT_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_REQUEST_CONF_RIGHT_RESULT result is : %d",notify.param2);
            CONFCTRL_S_REQUEST_CONFCTRL_RIGHT_RESULT *data = (CONFCTRL_S_REQUEST_CONFCTRL_RIGHT_RESULT *)notify.data;
            if (data != NULL) {
                if (strlen(data->dateconf_uri) > 0) {
                    _confCtrlUrl = [NSString stringWithUTF8String:data->dateconf_uri];
                }
            }
            
            // get data params
            if (_dataParam) {
                if ([self isUportalMediaXConf]) {
                    [self getConfDataparamsWithType:UportalDataConfParamGetTypeConfIdPassWordRandom
                                        dataConfUrl:_dataParam.dataConfUrl
                                             number:nil
                                                pCd:_dataParam.passCode
                                             confId:_dataParam.dataConfId
                                                pwd:_dataParam.passCode
                                         dataRandom:_dataParam.dataRandom];
                }else if ([self isUportalUSMConf]){
                    [self getConfDataparamsWithType:UportalDataConfParamGetTypePassCode
                                        dataConfUrl:_dataParam.dataConfUrl
                                             number:nil
                                                pCd:_dataParam.passCode
                                             confId:_dataParam.dataConfId
                                                pwd:_dataParam.passCode
                                         dataRandom:_dataParam.dataRandom];
                }else{
                    //empty
                }
                self.dataParam = nil;
            }
        }
        case CONFCTRL_E_EVT_SET_CONF_MODE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_SET_CONF_MODE_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:EC_SET_CONF_MODE_NOTIFY
                                                                    object:nil
                                                                  userInfo:@{ECCONF_RESULT_KEY : [NSNumber numberWithBool:result]}];
            });
        }
            break;
        case CONFCTRL_E_EVT_BROADCAST_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_BROADCAST_ATTENDEE_RESULT result: %d", notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_BROADCAST_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_RESULT result: %d", notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            if(result){
                _BroadcastingT = -1;
            }
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_CANCEL_BROADCAST_RESULT result:resultInfo];
        }
            break;
        case CONFCTRL_E_EVT_WATCH_ATTENDEE_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_WATCH_ATTENDEE_RESULT result: %d", notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_WATCH_RESULT result:resultInfo];
        }
            break;
        default:
            break;
    }
    if (notify.msgId == CONFCTRL_E_EVT_UPGRADE_CONF_RESULT || notify.msgId == CONFCTRL_E_EVT_DATACONF_PARAMS_RESULT)
    {
        [self handleUpgradeToDataConferenceNotify:notify];
    }
}

/**
 *This method is used to handle upgrade to data conference notification
 *升级数据会议回调处理
 */
-(void)handleUpgradeToDataConferenceNotify:(Notification *)notify
{
    switch (notify.msgId)
    {
        case CONFCTRL_E_EVT_UPGRADE_CONF_RESULT:
        {
            DDLogInfo(@"CONFCTRL_E_EVT_UPGRADE_CONF_RESULT result is : %d",notify.param2);
            BOOL result = notify.param2 == TUP_SUCCESS ? YES : NO;
            NSDictionary *resultInfo = @{
                                         ECCONF_RESULT_KEY : [NSNumber numberWithInt:result]
                                         };
            [self respondsECConferenceDelegateWithType:CONF_E_UPGRADE_RESULT result:resultInfo];
            if (!self.isJoinDataConf)
            {
                self.isJoinDataConf = YES;
            }
            
        }
            break;
        case CONFCTRL_E_EVT_DATACONF_PARAMS_RESULT:  //if get data param success, this notify will carry param info
        {
            DDLogInfo(@"CONFCTRL_E_EVT_DATACONF_PARAMS_RESULT result is : %d",notify.param1);
            CONFCTRL_S_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_DATACONF_PARAMS *)notify.data;
            if (!dataConfParams || notify.param1 != TUP_SUCCESS) {
                DDLogInfo(@"upgrade to data conference failed");
                return;
            }
            _isNeedDataConfParam = NO;
            DataConfParam *tupDataConfParams = [DataConfParam transformFromTupStruct:dataConfParams];
            // join data conference
            [[ManagerService dataConfService] joinDataConfWithParams:tupDataConfParams];
        }
            break;
        default:
            break;
    }
}

/**
 *This method is used to handle conf info update notification
 *处理会议信息改变上报的回调
 */
-(void)handleVCAttendeeUpdateNotify:(Notification *)notify
{
    CC_ATTENDEE_UPDATE_E confUpdateType = (CC_ATTENDEE_UPDATE_E)notify.param2;
    TE_ATTENDEE_DATA_IN_LIST *attendeeList = (TE_ATTENDEE_DATA_IN_LIST *)notify.data;
    VCConfUpdateInfo *updateInfo = [VCConfUpdateInfo returnVCConfInfoWith:attendeeList];
    DDLogInfo(@"updateInfo,aucName:%@",updateInfo.aucName);
    if(0 == [self.haveJoinAttendeeArray count] && 1 == attendeeList->ucGetName){
        VCConfUpdateInfo *updateInfo = [VCConfUpdateInfo returnVCConfInfoWith:attendeeList];
        updateInfo.updateType = (VC_ATTENDEE_UPDATE_E)confUpdateType;
        [self.haveJoinAttendeeArray addObject:updateInfo];
    }
    __block BOOL isAttendeeInConf = NO;
    [self.haveJoinAttendeeArray enumerateObjectsUsingBlock:^(VCConfUpdateInfo* attendeeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if(attendeeList->ucT == attendeeInfo.ucT || [[NSString stringWithUTF8String:attendeeList->aucName] isEqualToString:attendeeInfo.aucName]){
            isAttendeeInConf = YES;
        }
        *stop = YES;
    }];
    if(0 != [self.haveJoinAttendeeArray count] && 1 == attendeeList->ucGetName){
        
        updateInfo.updateType = (VC_ATTENDEE_UPDATE_E)confUpdateType;
        if(updateInfo.ucChair && _vcAttendee !=nil && updateInfo.ucT == _vcAttendee.terminalNum){
            updateInfo.isChair = YES;
        }else{
            updateInfo.isChair = NO;
        }
        
        [self.haveJoinAttendeeArray enumerateObjectsUsingBlock:^(VCConfUpdateInfo* attendeeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if([[NSString stringWithUTF8String:attendeeList->aucName] isEqualToString:attendeeInfo.aucName]){
                isAttendeeInConf = YES;
                *stop = YES;
            }
        }];
        if(isAttendeeInConf == NO){
            [self.haveJoinAttendeeArray addObject:updateInfo];
        }
        for(int i=0;i<[self.haveJoinAttendeeArray count];i++){
            VCConfUpdateInfo *attendee = self.haveJoinAttendeeArray[i];
            if([updateInfo.aucName isEqualToString: attendee.aucName]){
                //                attendee.updateType = (VC_ATTENDEE_UPDATE_E)confUpdateType;
                DDLogInfo(@"attendd number is:%@, updatetype is:%d",updateInfo.aucName,(int)updateInfo.updateType);
//                self.haveJoinAttendeeArray[i] = updateInfo;
                attendee.ucM = updateInfo.ucM;
                attendee.ucT = updateInfo.ucT;
                attendee.aucName = updateInfo.aucName;
                attendee.aucNumber = updateInfo.aucNumber;
                attendee.ucMute = updateInfo.ucMute;
                attendee.ucSilent = updateInfo.ucSilent;
//                attendee.userID = updateInfo.userID;
                attendee.isSpeaking = updateInfo.isSpeaking;
                attendee.isChair = updateInfo.isChair;
                attendee.ucJoinConf = updateInfo.ucJoinConf;
                attendee.updateType =updateInfo.updateType;
                
                self.haveJoinAttendeeArray[i] = attendee;
                
                if(updateInfo.updateType == VC_ATTENDEE_UPDATE_DEL){
                    [self.haveJoinAttendeeArray removeObject:self.haveJoinAttendeeArray[i]];
                }
            }
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self goConferenceRunView];
        
        //    confStatus.participants = self.haveJoinAttendeeArray;
        if(1 == [self.haveJoinAttendeeArray count]){
            VCConfUpdateInfo *updateInfo = self.haveJoinAttendeeArray[0];
            DDLogInfo(@"vc conf attendee count: %d",self.haveJoinAttendeeArray.count);
            DDLogInfo(@"vc conf attendee name: %@",updateInfo.aucName);
            DDLogInfo(@"vc conf attendee T: %d",updateInfo.ucT);
        }
        
        NSDictionary *resultInfo = @{
                                     VCCONF_ATTENDEE_UPDATE_KEY: self.haveJoinAttendeeArray
                                     };
        [self respondsECConferenceDelegateWithType:CONF_E_ATTENDEE_UPDATE_INFO result:resultInfo];
    });
}

/**
 *This method is used to get EC_CONF_MEDIATYPE enum value by param mediaType
 *根据传入的会议类型int值获取会议类型枚举值
 */
- (EC_CONF_MEDIATYPE)transformByUportalMediaType:(TUP_UINT32)mediaType {
    EC_CONF_MEDIATYPE type = CONF_MEDIATYPE_VOICE;
    switch (mediaType) {
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE:
            type = CONF_MEDIATYPE_VOICE;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO:
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO:
            type = CONF_MEDIATYPE_VIDEO;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
            type = CONF_MEDIATYPE_DATA;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
            type = CONF_MEDIATYPE_VIDEO_DATA;
            break;
            
        default:
            break;
    }
    return type;
}

/**
 *This method is used to handle get conf info result notification
 *处理获取会议信息结果回调
 */
-(void)handleGetConfInfoResult:(Notification *)notify
{
    DDLogInfo(@"CONFCTRL_E_EVT_GET_CONF_INFO_RESULT");
    CONFCTRL_S_GET_CONF_INFO_RESULT *confInfo = (CONFCTRL_S_GET_CONF_INFO_RESULT*)notify.data;

    if (notify.param1 != TUP_SUCCESS)
    {
        DDLogInfo(@"Get Conf Info Result if failed");
        NSDictionary *resultInfo = @{
                                     ECCONF_RESULT_KEY : [NSNumber numberWithBool:NO]
                                     };
        [self respondsECConferenceDelegateWithType:CONF_E_CURRENTCONF_DETAIL result:resultInfo];
        return;
    }
    if (!confInfo)
    {
        DDLogInfo(@"confInfo is nil");
        return;
    }
    CONFCTRL_S_CONF_LIST_INFO confListInfo = confInfo->conf_list_info;
    
    DDLogInfo(@"conf_id : %s, conf_subject : %s, media_type: %d,size:%d,scheduser_name:%s,scheduser_number:%s, start_time:%s, end_time:%s, conf_state: %d, confListInfo.chairman_pwd : %s",confListInfo.conf_id,confListInfo.conf_subject,confListInfo.media_type,confListInfo.size,confListInfo.scheduser_name,confListInfo.scheduser_number,confListInfo.start_time,confListInfo.end_time,confListInfo.conf_state,confListInfo.chairman_pwd);
    
    DDLogInfo(@"num_of_addendee :%d",confInfo->num_of_addendee);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CONFCTRL_S_ATTENDEE* attendee = confInfo->attendee;
    for (int i = 0; i< confInfo->num_of_addendee; i++)
    {
        DDLogInfo(@"attendee->name :%s,attendee->number: %s",attendee[i].name,attendee[i].number);
        ConfAttendee *confAttendee = [ConfAttendee returnConfAttendeeWith:attendee[i]];
        [tempArray addObject:confAttendee];
    }
    
    ECCurrentConfInfo *currentConfInfo = [[ECCurrentConfInfo alloc] init];
    ECConfInfo *ecConfInfo = [ECConfInfo returnECConfInfoWith:confListInfo];
    currentConfInfo.confDetailInfo = ecConfInfo;
    currentConfInfo.attendeeArray = [NSArray arrayWithArray:tempArray];
    NSString *confID = ecConfInfo.conf_id;
    
    if (strlen(confListInfo.token)) {
        NSString *smcToken = [NSString stringWithUTF8String:confListInfo.token];
        [self updateSMCConfToken:smcToken inConf:confID];
    }
    // selfJoinNumber is not sipAccount,get confDataParams from here.
    BOOL needGetParam = NO;
    if (self.selfJoinNumber && self.selfJoinNumber.length > 0) {
        if (![self.selfJoinNumber isEqualToString:self.sipAccount]) {
            needGetParam = YES;
        }
    }
    
    //judge whether is data conf,if it's data conf, invoke interface to get big param
    if (self.isJoinDataConf && [confID isEqualToString:_dataConfIdWaitConfInfo] && _isNeedDataConfParam && needGetParam)
    {
        NSString *pwd = [self isUportalSMCConf] ? currentConfInfo.confDetailInfo.general_pwd : currentConfInfo.confDetailInfo.chairman_pwd;
        if (!self.selfJoinNumber) {
            self.selfJoinNumber = self.sipAccount;
        }
        DDLogInfo(@"getdataConf,handleGetConfInfoResult");
        if ([self isUportalMediaXConf]) {
            [self getConfDataparamsWithType:UportalDataConfParamGetTypeConfIdPassWord dataConfUrl:nil number:nil pCd:nil confId:confID pwd:pwd dataRandom:nil];
        }else if ([self isUportalSMCConf]){
            [self getConfDataparamsWithType:UportalDataConfParamGetTypePassCode dataConfUrl:nil number:self.selfJoinNumber pCd:pwd confId:confID pwd:nil dataRandom:nil];
        }else{
            [self getConfDataparamsWithType:UportalDataConfParamGetTypePassCode dataConfUrl:nil number:self.selfJoinNumber pCd:pwd confId:confID pwd:nil dataRandom:nil];
        }
        
        _dataConfIdWaitConfInfo = nil;
    }
    NSDictionary *resultInfo = @{
                                 ECCONF_CURRENTCONF_DETAIL_KEY : currentConfInfo,
                                 ECCONF_RESULT_KEY : [NSNumber numberWithBool:YES]
                                 };
    //post current conf info detail to UI
    [self respondsECConferenceDelegateWithType:CONF_E_CURRENTCONF_DETAIL result:resultInfo];
}

/**
 *This method is used to handle get conf list result notification, if success refresh UI page
 *处理获取会议列表回调，如果成功，刷新UI页面
 */
-(void)handleGetConfListResult:(Notification *)notify
{
    DDLogInfo(@"result: %d",notify.param1);
    CONFCTRL_S_GET_CONF_LIST_RESULT *confListInfoResult = (CONFCTRL_S_GET_CONF_LIST_RESULT*)notify.data;
    DDLogInfo(@"confListInfoResult->current_count----- :%d total_count-- :%d",confListInfoResult->current_count,confListInfoResult->total_count);
    CONFCTRL_S_CONF_LIST_INFO *confList = confListInfoResult->conf_list_info;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< confListInfoResult->current_count; i++)
    {
        ECConfInfo *confInfo = [ECConfInfo returnECConfInfoWith:confList[i]];
        if (confInfo.conf_state != CONF_E_CONF_STATE_DESTROYED)
        {
            [tempArray addObject:confInfo];
        }
    }
    NSDictionary *resultInfo = @{
                                 ECCONF_LIST_KEY : tempArray
                                 };
    [self respondsECConferenceDelegateWithType:CONF_E_GET_CONFLIST result:resultInfo];
}

/**
 *This method is used to switch to the conf running page
 *切换到正在召开的会议页面
 */
-(void)goConferenceRunView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TUP_CALL_REMOVE_CALL_VIEW_NOTIFY object:nil];
    
//    if(self.isFirstJumpToRunningView){
//        self.isFirstJumpToRunningView = NO;
//    }
    
}

#pragma mark  public
/**
 * This method is used to set conference server params
 * 设置会议服务器信息
 *@param address server address
 *@param port server port
 *@param token get token from uportal login
 */
-(void)configConferenceCtrlWithServerAddress:(NSString *)address port:(int)port networkType:(int)networkType
{
    if (0 == address.length)
    {
        return;
    }
    _networkType = networkType;
    if(networkType == NETWORK_ONPREMISE){
        int ret = tup_confctrl_set_conf_env_type(CONFCTRL_E_CONF_ENV_ON_PREMISE_VC);
        DDLogInfo(@"tup_confctrl_set_conf_env_type result: %d",ret);
    }else{
        int ret = tup_confctrl_set_conf_env_type(CONFCTRL_E_CONF_ENV_HOSTED_VC);
        DDLogInfo(@"tup_confctrl_set_conf_env_type result: %d",ret);
    }
    
    CONFCTRL_S_SERVER_PARA *serverParam = (CONFCTRL_S_SERVER_PARA *)malloc(sizeof(CONFCTRL_S_SERVER_PARA));
    memset_s(serverParam, sizeof(CONFCTRL_S_SERVER_PARA), 0, sizeof(CONFCTRL_S_SERVER_PARA));
    strcpy(serverParam->server_addr, [address UTF8String]);
    serverParam->port = (TUP_INT32)port;
    int result = tup_confctrl_set_server_params(serverParam);
    DDLogInfo(@"tup_confctrl_set_server_p1arams result : %d",result);
    free(serverParam);
}

/**
 * This method is used to set token
 * 设置鉴权token
 *@param token get token from uportal login
 *@return YES or NO
 */
-(BOOL)configToken:(NSString *)token
{
    int setTokenResult = tup_confctrl_set_token([token UTF8String]);
    DDLogInfo(@"tup_confctrl_set_token result : %d, token : %@",setTokenResult,token);
    return setTokenResult == TUP_SUCCESS ? YES : NO;
}

/**
 *This method is used to config authcode,it's used in on_premise for setting conf enviroment
 */
-(void)configConferenceAuthCode:(NSString *)account pwd:(NSString *)password
{
    if(0 == account.length || 0 == password.length){
        return;
    }
    
    int ret = tup_confctrl_set_auth_code((TUP_CHAR *)[account UTF8String], (TUP_CHAR *)[password UTF8String]);
    DDLogInfo(@"tup_confctrl_set_auth_code result: %d", ret);
}

/**
 * This method is used to create conference
 * 创会
 *@param attendeeArray one or more attendees
 *@param mediaType EC_CONF_MEDIATYPE value
 *@return YES or NO
 */
-(BOOL)tupConfctrlBookConfHosted:(NSArray *)attendeeArray mediaType:(EC_CONF_MEDIATYPE)mediaType subject:(NSString *)subject
{
    CONFCTRL_S_BOOK_CONF_INFO_MEDIAX *bookConfInfo = (CONFCTRL_S_BOOK_CONF_INFO_MEDIAX *)malloc(sizeof(CONFCTRL_S_BOOK_CONF_INFO_MEDIAX));
    memset_s(bookConfInfo, sizeof(CONFCTRL_S_BOOK_CONF_INFO_MEDIAX), 0, sizeof(CONFCTRL_S_BOOK_CONF_INFO_MEDIAX));
    bookConfInfo->size = 2;
    bookConfInfo->conf_type = CONFCTRL_E_CONF_TYPE_NORMAL;
    bookConfInfo->media_type = [self uPortalConfMediaTypeByESpaceMediaType:mediaType];
    bookConfInfo->start_time = 0;
    bookConfInfo->summer_time = 0;
    bookConfInfo->conf_len = 7200;
    strcpy(bookConfInfo->subject, [subject UTF8String]);
    bookConfInfo->welcome_voice_enable = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    bookConfInfo->enter_prompt = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    bookConfInfo->leave_prompt = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    bookConfInfo->conf_filter = 0;
    bookConfInfo->record_flag = 0;
    bookConfInfo->auto_prolong = 0;
    bookConfInfo->multi_stream_flag = 0;
    bookConfInfo->allow_invite =  1;
    bookConfInfo->auto_invite = TUP_TRUE;   //自动邀请
    bookConfInfo->allow_video_control = 1;
    bookConfInfo->timezone = (CONFCTRL_E_TIMEZONE)56;
    bookConfInfo->reminder = CONFCTRL_E_REMINDER_TYPE_NONE;
    bookConfInfo->language = CONFCTRL_E_LANGUAGE_ZH_CN;
    bookConfInfo->conf_encrypt_mode = CONFCTRL_E_ENCRYPT_MODE_NONE;
    bookConfInfo->user_type = CONFCTRL_E_USER_TYPE_WEB;
    bookConfInfo->num_of_attendee = [attendeeArray count];
    bookConfInfo->attendee = [self returnHostedAttendee:attendeeArray];
    
    CONFCTRL_S_CYCLE_PARAM *cycleParam = (CONFCTRL_S_CYCLE_PARAM *)malloc(sizeof(CONFCTRL_S_CYCLE_PARAM));
    memset_s(cycleParam, sizeof(CONFCTRL_S_CYCLE_PARAM), 0, sizeof(CONFCTRL_S_CYCLE_PARAM));
    cycleParam->start_data=0;
    cycleParam->end_data = 0;
    cycleParam->frequency=CONFCTRL_E_CYCLE_TYPE_DAY;
    cycleParam->appointed_type=0;
    cycleParam->interval=0;
    cycleParam->point_num = 0;
    cycleParam->point = 0;
    cycleParam->cycle_count=0;
    bookConfInfo->cycle_params = cycleParam;
    
    CONFCTRL_S_ASSISTANT_MEDIA *mediaParams = (CONFCTRL_S_ASSISTANT_MEDIA *)malloc(sizeof(CONFCTRL_S_ASSISTANT_MEDIA));
    memset_s(mediaParams,sizeof(CONFCTRL_S_ASSISTANT_MEDIA) , 0, sizeof(CONFCTRL_S_ASSISTANT_MEDIA));
    mediaParams->mpi = 1;
    mediaParams->type = CONFCTRL_E_ASSIST_MEDIA_TYPE_FILM;
    mediaParams->code = CONFCTRL_E_VIDEO_CODEC_H263;
    mediaParams->bandwidth = CONFCTRL_E_BAND_WIDTH_384K;
    mediaParams->size = CONFCTRL_E_MEDIA_SIZE_CIF;
    bookConfInfo->assistant_media_params = mediaParams;
    
    TUP_RESULT ret = tup_confctrl_book_conf(bookConfInfo);
    DDLogInfo(@"tup_confctrl_book_conf result : %d",ret);
    if(bookConfInfo->assistant_media_params)
    {
        free(bookConfInfo->assistant_media_params);
        bookConfInfo->assistant_media_params = NULL;
    }
    if(bookConfInfo->cycle_params)
    {
        free(bookConfInfo->cycle_params);
        bookConfInfo->cycle_params = NULL;
    }
    free(bookConfInfo);
    return ret == TUP_SUCCESS ? YES : NO;
}


-(BOOL)tupConfctrlBookConf:(NSArray *)attendeeArray mediaType:(EC_CONF_MEDIATYPE)mediaType startTime:(NSDate *)startTime confLen:(int)confLen subject:(NSString *)subject password:(NSString *)password
{
    
    CONFCTRL_BOOKCONF_INFO_S *bookConfInfo = (CONFCTRL_BOOKCONF_INFO_S *)malloc(sizeof(CONFCTRL_BOOKCONF_INFO_S));
    memset_s(bookConfInfo, sizeof(CONFCTRL_BOOKCONF_INFO_S), 0, sizeof(CONFCTRL_BOOKCONF_INFO_S));
    bookConfInfo->ucSiteCallType = 0;
    bookConfInfo->ulSiteNumber = [attendeeArray count];
    bookConfInfo->pcParam1 = [self returnAttendeeWithArray:attendeeArray];
    [self uPortalConfMediaTypeByESpaceMediaType:mediaType];
    bookConfInfo->TerminalDataRate = self.terminalDataRate;
    bookConfInfo->usPwdLen = 0;
    bookConfInfo->pucPwd = (TUP_UCHAR*)[password UTF8String];
    DDLogInfo(@"chairman password is == %@",password);
    bookConfInfo->usAnonymousSiteNumber = 0;
    bookConfInfo->ucHasMuiltiPic = 0;
    bookConfInfo->ulSubPicCnt = 0;
    bookConfInfo->ulMultiPicGroupCnt = 0;
    bookConfInfo->usConfNameLen = [subject length];
    bookConfInfo->pucConfName = (TUP_UCHAR*)[subject UTF8String];
    bookConfInfo->pucLanguage = (TUP_UCHAR*)[@"zh-CN" UTF8String];
    bookConfInfo->pPayMode = (CC_SITECALL_PAYMODE *)malloc(sizeof(CC_SITECALL_PAYMODE));
    if(NULL == bookConfInfo->pPayMode){
        DDLogInfo(@"bookConfInfo->pPayMode malloc failed");
    }
    memset_s(bookConfInfo->pPayMode, sizeof(CC_SITECALL_PAYMODE), 0, sizeof(CC_SITECALL_PAYMODE));
    bookConfInfo->pPayMode->ucPayMode = 0;   //？？？？？
    bookConfInfo->pPayMode->CardNumberLen = 0;
    bookConfInfo->pPayMode->pucCardNumber = NULL;
    bookConfInfo->pPayMode->CardPwdLen = 0;
    bookConfInfo->pPayMode->pucCardPwd = NULL;
    bookConfInfo->ucHasDataConf = self.hasDataConf;
    DDLogInfo(@"has data conf %d", self.hasDataConf);
    bookConfInfo->ucHasAuxVideo = 0;
    bookConfInfo->ucbMVRecord = 0;
    bookConfInfo->ucbMVBroadcast = 0;
    bookConfInfo->ucRoleLabel = 0;
    bookConfInfo->stLocalAddr.enIpVer = CC_IP_V4;
    LoginAuthorizeInfo *mine = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    DDLogInfo(@"local address is :%@",mine.ipAddress);
    bookConfInfo->stLocalAddr.u.ulIpv4 = htonl(inet_addr([mine.ipAddress UTF8String]));
    
    NSString *regexDNS = @"^([0-9a-zA-Z][0-9a-zA-Z-]{0,62}\\.)+([0-9a-zA-Z][0-9a-zA-Z-]{0,62})\\.?$?";
    NSPredicate *predicateDNS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexDNS];
    NSString *serip = mine.serverAddress;
    if ([predicateDNS evaluateWithObject:mine.serverAddress]) {
        serip = [self getIPWithHostName:mine.serverAddress];
    }
    bookConfInfo->stServerAddr.enIpVer = CC_IP_V4;
    bookConfInfo->stServerAddr.u.ulIpv4 = htonl(inet_addr([serip UTF8String]));
    
    bookConfInfo->ucSiteCallMode = 0;
    bookConfInfo->ulSiteCallStartTime = 0;
    bookConfInfo->ulSiteCallTime = 0;
    bookConfInfo->lTimezoneOffset = 0;
    bookConfInfo->eVideoProto = CC_VIDEO_PROTO_BUTT;
    bookConfInfo->eVideoFormat = CC_VIDEO_FORMAT_RESOLFOR_BUTT;
    bookConfInfo->eVideoFrameRate = CC_VIDEO_FRAMERATE_BUTT;
    bookConfInfo->eAudioProto = CC_AUDIO_PROTOCOL_BUTT;
    bookConfInfo->eH235Policy = CC_H235_NOTUSED;
    bookConfInfo->eSipSrtpPolicy = CC_SRTP_NOTUSED;
    bookConfInfo->eSiteCallMode = CC_SITE_CALL_MODE_NORMAL;
    bookConfInfo->stVoiceCtrlParam.ucIsUseVoiceCtrl = 0;
    bookConfInfo->stVoiceCtrlParam.ucVoiceCtrlType = 0;
    bookConfInfo->stVoiceCtrlParam.ulVoiceValue = 0;
    TUP_RESULT ret = tup_confctrl_book_conf(bookConfInfo);
    DDLogInfo(@"tup_confctrl_book_conf result : %d",ret);
    if(bookConfInfo->pPayMode)
    {
        free(bookConfInfo->pPayMode);
        bookConfInfo->pPayMode = NULL;
    }
    
    free(bookConfInfo);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(NSString *) getIPWithHostName:(const NSString *)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
        
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

/**
 *This method is used to transform local date to UTC date
 *将本地时间转换为UTC时间
 */
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //input
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //output
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

/**
 * This method is used to create conference
 * 创会
 *@param attendeeArray one or more attendees
 *@param mediaType EC_CONF_MEDIATYPE value
 *@return YES or NO
 */
-(BOOL)createConferenceWithAttendee:(NSArray *)attendeeArray mediaType:(EC_CONF_MEDIATYPE)mediaType subject:(NSString *)subject startTime:(NSDate *)startTime confLen:(int)confLen password:(NSString *)password
{
//    self.chairPasscode = password;
    
    if(_networkType == NETWORK_ONPREMISE){
        return [self tupConfctrlBookConf:attendeeArray mediaType:mediaType startTime:startTime confLen:confLen subject:subject password:password];
    }else{
        return [self tupConfctrlBookConfHosted:attendeeArray mediaType:mediaType subject:subject];
    }
}

/**
 *This method is used to give value to struct CC_AddTerminalInfo by memberArray
 *用memberArray给结构体CONFCTRL_S_ATTENDEE赋值，为创会时的入参
 */
-(CC_AddTerminalInfo *)returnAttendeeWithArray:(NSArray *)memberArray
{
    
    CC_AddTerminalInfo *attendee = (CC_AddTerminalInfo *)malloc(memberArray.count*sizeof(CC_AddTerminalInfo));
    memset_s(attendee, memberArray.count *sizeof(CC_AddTerminalInfo), 0, memberArray.count *sizeof(CC_AddTerminalInfo));
    for (int i = 0; i<memberArray.count; i++)
    {
        ConfAttendee *tempAttendee = memberArray[i];
        attendee[i].nTerminalIDLength = [tempAttendee.number length];
        attendee[i].pTerminalID = (TUP_UCHAR*)[tempAttendee.number UTF8String];
        attendee[i].ucNumberLen = [tempAttendee.number length];
        attendee[i].pucNumber = (TUP_UCHAR*)[tempAttendee.number UTF8String];
        attendee[i].ucURILen = [tempAttendee.number length];
        attendee[i].pucURI = (TUP_UCHAR*)[tempAttendee.number UTF8String];
        attendee[i].TerminalType = CC_sip;
        attendee[i].udwSiteBandwidth = 1920;
        attendee[i].LanguageType = CC_sitecall_simpleChineseGB2312;
        attendee[i].stTerminalIPAddr.enIpVer = CC_IP_V4;
        attendee[i].ucInternationCodeLen = 0;
        attendee[i].pucInternationCode = 0;
        attendee[i].ucNationCodeLen = 0;
        attendee[i].pucNationCode = 0;
        attendee[i].ucTelcount = 0;
        attendee[i].pucTel = 0;
        //        attendee[i].pucTel->ucNumberLen = 0;
    }
    return attendee;
}

/**
 *This method is used to give value to struct CONFCTRL_S_ATTENDEE_MEDIAX by memberArray
 *用memberArray给结构体CONFCTRL_S_ATTENDEE赋值，为创会时的入参
 */
-(CONFCTRL_S_ATTENDEE_MEDIAX *)returnHostedAttendee:(NSArray*)memberArray
{
    CONFCTRL_S_ATTENDEE_MEDIAX *attendee = (CONFCTRL_S_ATTENDEE_MEDIAX *)malloc(memberArray.count*sizeof(CONFCTRL_S_ATTENDEE_MEDIAX));
    memset_s(attendee, memberArray.count*sizeof(CONFCTRL_S_ATTENDEE_MEDIAX), 0, memberArray.count*sizeof(CONFCTRL_S_ATTENDEE_MEDIAX));
    for(int i = 0; i<memberArray.count; i++){
        ConfAttendee *tempAttendee = memberArray[i];
        strcpy(attendee[i].number, [tempAttendee.number UTF8String]);
        strcpy(attendee[i].name, "");
        attendee[i].role = CONFCTRL_E_CONF_ROLE_ATTENDEE;
        attendee[i].type = CONFCTRL_E_ATTENDEE_TYPE_NORMAL;
        if(i == 0){
            attendee[i].role = CONFCTRL_E_CONF_ROLE_CHAIRMAN;
        }
    }
    
    return attendee;
}

/**
 * This method is used to get conference detail info
 * 获取会议详细信息
 *@param confId conference id
 *@param pageIndex pageIndex default 1
 *@param pageSize pageSize default 10
 *@return YES or NO
 */
-(BOOL)obtainConferenceDetailInfoWithConfId:(NSString *)confId Page:(int)pageIndex pageSize:(int)pageSize
{
    if (confId.length == 0)
    {
        DDLogInfo(@"current confId is nil");
        return NO;
    }
    CONFCTRL_S_GET_CONF_INFO confInfo;
    memset(&confInfo, 0, sizeof(CONFCTRL_S_GET_CONF_INFO));
    strcpy(confInfo.conf_id, [confId UTF8String]);
    confInfo.page_index = pageIndex;
    confInfo.page_size = pageSize;
    int getConfInfoRestult = tup_confctrl_get_conf_info(&confInfo);
    DDLogInfo(@"tup_confctrl_get_conf_info result: %d",getConfInfoRestult);
    return getConfInfoRestult == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to get conference list
 * 获取会议列表
 *@param pageIndex pageIndex default 1
 *@param pageSize pageSize default 10
 *@return YES or NO
 */
-(BOOL)obtainConferenceListWithPageIndex:(int)pageIndex pageSize:(int)pageSize
{
//    CONFCTRL_S_GET_VMR_LIST confVmrlist;
//    confVmrlist.is_ascend = YES;
//    confVmrlist.page_index = pageIndex;
//    confVmrlist.page_size = pageSize;
//    int result = tup_confctrl_get_vmr_list(&confVmrlist);
//    DDLogInfo(@"tup_confctrl_get_vmr_list result: %d",result);
//    return result == TUP_SUCCESS ? YES : NO;
    
    CONFCTRL_S_GET_CONF_LIST conflistInfo;
    memset(&conflistInfo, 0, sizeof(CONFCTRL_S_GET_CONF_LIST));
    conflistInfo.conf_right = CONFCTRL_E_CONFRIGHT_CREATE_JOIN;
    conflistInfo.page_size = pageSize;
    conflistInfo.page_index = pageIndex;
    conflistInfo.include_end = TUP_FALSE;
    int result = tup_confctrl_get_conf_list(&conflistInfo);
    DDLogInfo(@"tup_confctrl_get_conf_list result: %d",result);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to join conference
 * 加入会议
 *@param confInfo conference
 *@param attendeeArray attendees
 *@return YES or NO
 */
-(BOOL)joinConference:(ECConfInfo *)confInfo attendee:(NSArray *)attendeeArray
{
    if (attendeeArray.count == 0 || confInfo == nil) {
        return NO;
    }
    
    _confHandle = 0;
    ConfAttendee *tempAttendee = attendeeArray[0];
    
    // todo join conference action
    BOOL createConfhandleResult = [self createConfHandle:confInfo.conf_id];
    BOOL subscribeConfResult = [self subscribeConfWithConfId:confInfo.conf_id];
    BOOL createConfCtlResult = [self createUportalConfConfCtrlWithConfId:confInfo.conf_id pwd:tempAttendee.role == CONF_ROLE_CHAIRMAN ? confInfo.chairman_pwd : confInfo.general_pwd joinNumber:tempAttendee.number confCtrlRandom:nil];
    if (!createConfhandleResult || !subscribeConfResult || !createConfCtlResult) {
        return NO;
    }
    BOOL result = [self confCtrlAddAttendeeToConfercene:tempAttendee.number];
    if (result) {
        self.selfJoinNumber = tempAttendee.number;
    }
    return result;
}

/**
 * This method is used to access conference
 * 接入预约会议
 *@param confDetailInfo ECConfInfo value
 *@return YES or NO
 */
-(unsigned int)accessReservedConference:(ECConfInfo *)confDetailInfo
{
    int result = 0;
    if ([self isUportalUSMConf]) {
        TUP_CALL_TYPE callType = CALL_AUDIO;
        if (confDetailInfo.media_type == CONF_MEDIATYPE_VOICE)
        {
            callType = CALL_AUDIO;
        }
        if (confDetailInfo.media_type == CONF_MEDIATYPE_VIDEO || confDetailInfo.media_type == CONF_MEDIATYPE_VIDEO_DATA)
        {
            callType = CALL_VIDEO;
        }
        NSString *accessNum = [NSString stringWithFormat:@"%@*%@#",confDetailInfo.access_number,confDetailInfo.general_pwd];
        result =[[ManagerService callService] startCallWithNumber:accessNum type:callType];
    }else{
        result = [[ManagerService callService] startECAccessCallWithConfid:confDetailInfo.conf_id AccessNum:confDetailInfo.access_number andPsw:confDetailInfo.general_pwd];
    }
    return result;
}

/**
 * This method is used to add attendee to conference
 * 添加与会者到会议中
 @param attendeeArray attendees
 @return YES or NO
 */
-(BOOL)confCtrlAddAttendeeToConfercene:(NSString *)attendeeNum
{
    if (0 == attendeeNum.length)
    {
        return NO;
    }
    CC_AddTerminalInfo *terminalInfo = (CC_AddTerminalInfo *)malloc(sizeof(CC_AddTerminalInfo));
    memset_s(terminalInfo, sizeof(CC_AddTerminalInfo), 0, sizeof(CC_AddTerminalInfo));
    terminalInfo->nTerminalIDLength = attendeeNum.length;
    terminalInfo->pTerminalID = (TUP_UCHAR*)[attendeeNum UTF8String];
    terminalInfo->ucNumberLen = attendeeNum.length;
    terminalInfo->pucNumber = (TUP_UCHAR*)[attendeeNum UTF8String];
    terminalInfo->ucURILen = attendeeNum.length;
    terminalInfo->pucURI = (TUP_UCHAR*)[attendeeNum UTF8String];
    terminalInfo->TerminalType = CC_sip;
    terminalInfo->udwSiteBandwidth = 1920;
    terminalInfo->LanguageType = CC_sitecall_simpleChineseGB2312;
    terminalInfo->stTerminalIPAddr.enIpVer = CC_IP_V4;
    terminalInfo->ucInternationCodeLen = 0;
    terminalInfo->pucInternationCode = (TUP_UCHAR*)[@"" UTF8String];
    terminalInfo->ucNationCodeLen = 0;
    terminalInfo->pucNationCode = (TUP_UCHAR*)[@"" UTF8String];
    terminalInfo->ucTelcount = 0;
    //    CC_E164NUM *tel = (CC_E164NUM*)malloc(sizeof(CC_E164NUM));
    //    memset_s(tel, sizeof(CC_E164NUM), 0, sizeof(CC_E164NUM));
    //    tel->ucNumberLen = attendeeNum.length;
    //    tel->pucNumber = (TUP_UINT8*)[attendeeNum UTF8String];
    terminalInfo->pucTel = nil;
    
    int result = tup_confctrl_add_attendee(_confHandle, terminalInfo);
    DDLogInfo(@"tup_confctrl_add_attendee = %d, _confHandle:%d",result,_confHandle);
    //    free(attendee);
    free(terminalInfo);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to remove attendee
 * 移除与会者
 *@param attendeeNumber attendee number
 *@return YES or NO
 */
-(BOOL)confCtrlRemoveAttendeeM:(int)ucM T:(int)ucT
{
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    int result = tup_confctrl_remove_attendee(_confHandle, vcAttendee);
    DDLogInfo(@"tup_confctrl_remove_attendee = %d, _confHandle:%d ",result,_confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

- (BOOL)confCtrlPostponeConf:(NSString*)postponeTime
{
    if(0 == postponeTime.length){
        return NO;
    }
    TUP_RESULT result = tup_confctrl_postpone_conf(_confHandle,[postponeTime intValue]);
    DDLogInfo(@"tup_confctrl_postpone_conf result:%d",result);
    return result == TUP_SUCCESS;
}

/**
 * This method is used to hang up attendee
 * 挂断与会者
 *@param M
 *@param T
 *@return YES or NO
 */
-(BOOL)confCtrlHangUpAttendeeM:(int)ucM T:(int)ucT
{
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    int result = tup_confctrl_hang_up_attendee(_confHandle, vcAttendee);
    DDLogInfo(@"tup_confctrl_hang_up_attendee = %d, _confHandle:%d",result,_confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to recall attendee
 * 重呼与会者
 *@param M
 *@param T
 *@return YES or NO
 */
-(BOOL)confCtrlRecallAttendeeM:(int)ucM T:(int)ucT
{
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    int result = tup_confctrl_call_attendee(_confHandle, vcAttendee);
    DDLogInfo(@"tup_confctrl_call_attendee = %d, _confHandle:%d",result,_confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to leave conference
 * 离开会议
 *@return YES or NO
 */
-(BOOL)confCtrlLeaveConference
{
    int result = tup_confctrl_leave_conf(_confHandle);
    DDLogInfo(@"tup_confctrl_leave_conf = %d, _confHandle is :%d",result,_confHandle);
    [self restoreConfParamsInitialValue];
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to end conference (chairman)
 * 结束会议
 *@return YES or NO
 */
-(BOOL)confCtrlEndConference
{
    int result = tup_confctrl_end_conf(_confHandle);
    DDLogInfo(@"tup_confctrl_end_conf = %d, _confHandle is :%d",result,_confHandle);
    [self restoreConfParamsInitialValue];
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to dealloc conference params
 * 销毁会议参数信息
 */
-(void)restoreConfParamsInitialValue
{
    DDLogInfo(@"restoreConfParamsInitialValue");
    [_confTokenDic removeAllObjects];
    [self.haveJoinAttendeeArray removeAllObjects];
    [self.dataConfParamURLDic removeAllObjects];
    self.isJoinDataConf = NO;
    _dataConfIdWaitConfInfo = nil;
    _confCtrlUrl = nil;
    _isNeedDataConfParam = YES;
    self.selfJoinNumber = nil;
    self.dataParam = nil;
    _hasReportMediaxSpeak = NO;
    self.isFirstJumpToRunningView = YES;
    [self destroyConfHandle];
    _BroadcastingT = -1;
}


/**
 *This interface is used to destroy conference control handle.
 *销毁会议句柄
 */
-(BOOL)destroyConfHandle
{
    if (_confHandle == 0)
    {
        return NO;
    }
    BOOL result = NO;
    TUP_RESULT ret_destroy_confhandle = tup_confctrl_destroy_conf_handle(_confHandle);
    DDLogInfo(@"destroyConfHandleByConfId result :%d", ret_destroy_confhandle);
    
    result = (TUP_SUCCESS == ret_destroy_confhandle);
    if (result) {
        _confHandle = 0;
    }
    
    return result;
}

/**
 * This method is used to lock conference (chairman)
 * 主席锁定会场
 *@param isLock YES or NO
 *@return YES or NO
 */
-(BOOL)confCtrlLockConference:(BOOL)isLock
{
    TUP_BOOL tupBool = isLock ? 1 : 0;
    int result = tup_confctrl_lockconf(_confHandle, tupBool);
    DDLogInfo(@"tup_confctrl_lockconf = %d, _confHandle is :%d, isLock:%d",result,_confHandle,isLock);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to mute attendee (chairman)
 * 主席闭音与会者
 *@param attendeeNumber attendee number
 *@param isMute YES or NO
 *@return YES or NO
 */
-(BOOL)confCtrlMuteAttendeeM:(int)ucM T:(int)ucT isMute:(BOOL)isMute
{
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    TUP_BOOL tupBool = isMute ? 1 : 0;
    int result = tup_confctrl_mute_attendee(_confHandle, vcAttendee, tupBool);
    DDLogInfo(@"tup_confctrl_mute_attendee = %d, _smcConfHandle is :%d, isMute:%d",result,_confHandle,isMute);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 *This method is used to request chair with password during conf
 *会议中申请成为主席
 */
-(BOOL)confCtrlRequestChairmanWithPassword:(NSString *)password requestMan:(NSString *)attendeeNumber
{
    int result = tup_confctrl_request_chairman(_confHandle,(TUP_CHAR*) [password UTF8String], (TUP_CHAR*)[attendeeNumber UTF8String]);
    DDLogInfo(@"tup_confctrl_request_chairman = %d, password is :%@, attendeeNumber:%@",result,password,attendeeNumber);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 *This method is used to release chair during conf
 *会议中主席释放主席权限
 */
-(BOOL)confCtrlReleaseChairmanWithRequestMan:(NSString *)attendeeNumber
{
    int result = tup_confctrl_release_chairman(_confHandle,(TUP_CHAR*)[attendeeNumber UTF8String]);
    DDLogInfo(@"tup_confctrl_release_chairman = %d,  attendeeNumber:%@",result,attendeeNumber);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to upgrade audio conference to data conference
 * 语音会议升级为数据会议
 *@param hasVideo whether the conference has video
 *@return YES or NO
 */
-(BOOL)confCtrlVoiceUpgradeToDataConference:(BOOL)hasVideo
{
    CONFCTRL_S_ADD_MEDIA *upgradeParams = (CONFCTRL_S_ADD_MEDIA *)malloc(sizeof(CONFCTRL_S_ADD_MEDIA));
    memset_s(upgradeParams, sizeof(CONFCTRL_S_ADD_MEDIA), 0, sizeof(CONFCTRL_S_ADD_MEDIA));
    TUP_UINT32 media_type = CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE;
    if (hasVideo) {
         media_type = media_type | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO;
    }
    upgradeParams->media_type = media_type;
    int result = tup_confctrl_upgrade_conf(_confHandle, upgradeParams);
    DDLogInfo(@"tup_confctrl_upgrade_conf = %d",result);
    free(upgradeParams);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 *This method is used to get param info of joining data conference
 *获取数据会议大参数
 */
-(BOOL)getConfDataparamsWithType:(UportalDataConfParamGetType)type
                     dataConfUrl:(NSString *)confUrl
                          number:(NSString *)number
                             pCd:(NSString *)passCode
                          confId:(NSString *)confId
                             pwd:(NSString *)pwd
                      dataRandom:(NSString *)dataRandom
{
    DDLogInfo(@"getConfDataparams:confUrl:%@,number:%@,passCode:%@,confId:%@,pwd:%@,dataRandom:%@",confUrl,number,passCode,confId,pwd,dataRandom);
//    NSString *realUrl = nil;
//    //get the value of url sequence: 1、CONFCTRL_E_EVT_REQUEST_CONF_RIGHT_RESULT back  2、onReceiveTupCallSipInfoNotification back 3、 login back.
//    if (_confCtrlUrl.length > 0) {
//        realUrl = _confCtrlUrl;
//    }
//    if (realUrl == nil || realUrl.length == 0) {
//        realUrl = confUrl;
//    }
//    if (realUrl == nil || realUrl.length == 0) {
//        LoginServerInfo *loginServerInfo = [[ManagerService loginService] obtainAccessServerInfo];
//
//        realUrl = [NSString stringWithFormat:@"https://%@",loginServerInfo.msParamUri];
//    }
    CONFCTRL_S_GET_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_GET_DATACONF_PARAMS *)malloc(sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    memset_s(dataConfParams, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS), 0, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    strcpy(dataConfParams->conf_url, [confUrl UTF8String]);
    
    if ([confId length] > 0) {
        [self.dataConfParamURLDic setObject:confUrl forKey:confId];
    } else {
        DDLogInfo(@"conf id empty!");
    }
    
    if (UportalDataConfParamGetTypePassCode != type &&
        UportalDataConfParamGetTypeConfIdPassWordRandom != type &&
        UportalDataConfParamGetTypeConfIdPassWord != type)
    {
        DDLogInfo(@"error  get type!");
        return NO;
    }
    switch (type) {
        case UportalDataConfParamGetTypePassCode:
            if (number.length > 0)
            {
                strcpy(dataConfParams->sip_num, [number UTF8String]);
            }
            if (passCode.length > 0)
            {
                strcpy(dataConfParams->passcode, [passCode UTF8String]);
            }
            break;
        case UportalDataConfParamGetTypeConfIdPassWord:
            if (confId.length > 0)
            {
                strcpy(dataConfParams->conf_id, [confId UTF8String]);
            }
            if (pwd.length > 0)
            {
                strcpy(dataConfParams->password, [pwd UTF8String]);
            }
            break;
        case UportalDataConfParamGetTypeConfIdPassWordRandom:
            if (confId.length > 0)
            {
                strcpy(dataConfParams->conf_id, [confId UTF8String]);
            }
            
            if (pwd.length > 0)
            {
                strcpy(dataConfParams->password, [pwd UTF8String]);
            }
            
            if (dataRandom.length > 0)
            {
                strcpy(dataConfParams->random, [dataRandom UTF8String]);
            }
            break;
        default:
            break;
    }
    
    dataConfParams->type = (TUP_UINT32)type;
    DDLogInfo(@"confurl is %s, dataConfParams->passcode: %s,dataConfParams->conf_id:%s",dataConfParams->conf_url,dataConfParams->passcode,dataConfParams->conf_id);
    int getConfParamsResult = tup_confctrl_get_dataconf_params(dataConfParams);
    DDLogInfo(@"tup_confctrl_get_dataconf_params result: %d",getConfParamsResult);
    free(dataConfParams);
    return getConfParamsResult == TC_OK ? YES : NO;
}

/**
 * This method is used to release chairman right (chairman)
 * 释放主席权限
 *@param chairNumber chairman number in conference
 *@return YES or NO
 */
- (BOOL)confCtrlReleaseChairman:(NSString *)chairNumber
{
    if (chairNumber.length == 0) {
        return NO;
    }
    TUP_RESULT ret_release_chairman = tup_confctrl_release_chairman(_confHandle, (TUP_CHAR *)[chairNumber UTF8String]);
    return ret_release_chairman == TUP_SUCCESS;
}

/**
 * This method is used to request chairman right (Attendee)
 * 申请主席权限
 *@param chairPwd chairman password
 *@param newChairNumber attendee's number in conference
 *@return YES or NO
 */
- (BOOL)confCtrlRequestChairman:(NSString *)chairPwd number:(NSString *)newChairNumber
{
    if (newChairNumber.length == 0) {
        return NO;
    }
    
    TUP_RESULT ret_request_chairman = tup_confctrl_request_chairman(_confHandle, (TUP_CHAR *)[chairPwd UTF8String], (TUP_CHAR* )[newChairNumber UTF8String]);
    return (TUP_SUCCESS == ret_request_chairman);
}

/**
 *This method is used to post service handle result to UI by delegate
 *将业务处理结果消息通过代理分发给页面进行ui处理
 */
-(void)respondsECConferenceDelegateWithType:(EC_CONF_E_TYPE)type result:(NSDictionary *)resultDictionary
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ecConferenceEventCallback:result:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ecConferenceEventCallback:type result:resultDictionary];
        });
    }
}

/**
 *This method is used to get media type int value by enum EC_CONF_MEDIATYPE
 *将会议类型EC_CONF_MEDIATYPE枚举值转换为int值
 */
- (int)uPortalConfMediaTypeByESpaceMediaType:(EC_CONF_MEDIATYPE)type
{
    _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE;
    switch (type) {
        case CONF_MEDIATYPE_VOICE:
            self.terminalDataRate = 640;
            self.hasDataConf = 3;
            break;
        case CONF_MEDIATYPE_DATA:
            _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA;
            self.terminalDataRate = 640;
            self.hasDataConf = 2;
            break;
        case CONF_MEDIATYPE_VIDEO:
            _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO;
            self.terminalDataRate = 19200;
            self.hasDataConf = 3;
            break;
        case CONF_MEDIATYPE_VIDEO_DATA:
            _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA;
            self.terminalDataRate = 19200;
            self.hasDataConf = 2;
            break;
        default:
            self.terminalDataRate = 19200;
            self.hasDataConf = 3;
            DDLogInfo(@"unknow espace conf media type!");
            break;
    }
    return _mediaType;
}

-(int)obtainMediaType
{
    if(_isNeedDataConfParam == NO){
        _mediaType = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA;
    }
    return _mediaType;
}

/**
 *This method is used to save token to token dictionary as the key of conf id if con network is SMC
 *smc组网下。将当前token以conf id为键存入token词典
 */
- (void)updateSMCConfToken:(NSString *)confToken inConf:(NSString *)confId
{
    BOOL isSMCConf = self.uPortalConfType == CONF_TOPOLOGY_SMC ? YES : NO;
    if (!isSMCConf)
    {
        DDLogWarn(@"not smc conf, ignore!");
        return;
    }
    if (nil == confToken || 0 == confToken.length || nil == confId || 0 == confId.length)
    {
        DDLogWarn(@"param is empty!");
        return;
    }
    @synchronized (_confTokenDic) {
        if ([_confTokenDic objectForKey:confId])
        {
            DDLogWarn(@"confToken in conf:%@ has already exist!", confId);
        }
        else
        {
            [_confTokenDic setObject:confToken forKey:confId];
        }
    }
}

/**
 *This method is used to get token from dictionary according to conf id
 *从token字典中拿出conf id对应的token
 */
- (NSString *)smcConfTokenByConfId:(NSString *)confId
{
    BOOL isSMCConf = self.uPortalConfType == CONF_TOPOLOGY_SMC ? YES : NO;
    if (!isSMCConf)
    {
        DDLogWarn(@"not smc conf, has no token!");
        return nil;
    }
    if (nil == confId || 0 == confId.length)
    {
        DDLogWarn(@"confId is empty!");
        return nil;
    }
    @synchronized (_confTokenDic) {
        return [_confTokenDic objectForKey:confId];
    }
}

/**
 *This method is used to remove token from dictionary according to conf id
 *从token字典中移除conf id对应的token
 */
- (void)clearSMCConfTokenByConfId:(NSString *)confId
{
    BOOL isSMCConf = self.uPortalConfType == CONF_TOPOLOGY_SMC ? YES : NO;
    if (!isSMCConf)
    {
        DDLogWarn(@"not smc conf, ignore!");
        return;
    }
    if (nil == confId || 0 == confId.length)
    {
        DDLogWarn(@"confId is empty!");
        return;
    }
    @synchronized (_confTokenDic) {
        [_confTokenDic removeObjectForKey:confId];
    }
}

//get mainConfId with confId in CONF_TOPOLOGY_MEDIAX
- (NSString *)mainConfIdByDBConfID:(NSString *)confId
{
    //if uPortalConfType is not CONF_TOPOLOGY_MEDIAX ,use current confId.
    BOOL isMediaXConf = self.uPortalConfType == CONF_TOPOLOGY_MEDIAX ? YES : NO;
    if (!isMediaXConf)
    {
        return confId;
    }
    NSString *mainConfId = confId;
    NSRange range = [confId rangeOfString:@"sub"];
    if (range.length > 0)
    {
        mainConfId = [confId substringToIndex:range.location];
    }
    DDLogInfo(@"confId is:%@, mainConfID is:%@", confId, mainConfId);
    return mainConfId;
}

/**
 * This method is used to create conference handle
 * 创建会议句柄
 *@param confId conference id
 *@return YES or NO
 */
- (BOOL)createConfHandle:(NSString *)confId
{
    if (nil == confId || 0 == confId.length)
    {
        DDLogInfo(@"param is empty!");
        return NO;
    }
    //_confHandle is exist ,no need to create.
    if (_confHandle > 0)
    {
        return YES;
    }
    TUP_RESULT ret_handle_create = TUP_FALSE;
    NSString *confHandleString = nil;
    TUP_UINT32 confHandle = 0;
    ret_handle_create = tup_confctrl_create_conf_handle((TUP_VOID *)[confId UTF8String], &confHandle);
    DDLogInfo(@"tup_confctrl_create_conf_handle,result:%d",ret_handle_create);
    
    if (TUP_SUCCESS == ret_handle_create)
    {
        _confHandle = confHandle;
    }
    return (TUP_SUCCESS == ret_handle_create);
}

/**
 *This method is used to create uportal conference control before join in conference
 *在uportal下加入会议前创建会议回控
 */
- (BOOL)createUportalConfConfCtrlWithConfId:(NSString *)confId
                                        pwd:(NSString *)pwd
                                 joinNumber:(NSString *)joinNumber
                             confCtrlRandom:(NSString *)ctrlRandom
{
    if (nil == confId || 0 == confId.length)
    {
        return NO;
    }
    // get mainConfId
    NSString *mainConfId = [self mainConfIdByDBConfID:confId];

    //the token used to requestConfContrlRight, in CONF_TOPOLOGY_SMC ,use the token from confContrl's token.
    //in other EC_CONF_TOPOLOGY_TYPE,use the token from sipInfo,s ctrlRandom.

    NSString *confCtrlToken = ctrlRandom;
    BOOL isSMCConf = self.uPortalConfType == CONF_TOPOLOGY_SMC ? YES : NO;
    if (isSMCConf)
    {
        NSString *smcConfToken = [self smcConfTokenByConfId:confId];
        if (smcConfToken.length > 0)
        {
            confCtrlToken = smcConfToken;
        }
        else
        {
            DDLogInfo(@"can not find token by conf:%@", confId);
        }
    }
    
    BOOL requestConfRightResult = [self requestMediaXConfControlRightWithConfId:mainConfId
                                                                            pwd:pwd
                                                                         number:joinNumber
                                                                          token:confCtrlToken];
    if (!requestConfRightResult) {
        [self destroyConfHandle];
        BOOL isSMCConf = self.uPortalConfType == CONF_TOPOLOGY_SMC ? YES : NO;
        if (isSMCConf)
        {
            [self clearSMCConfTokenByConfId:confId];
        }
    }
    
    return requestConfRightResult;
}

/**
 *This method is used to create uportal conference control before join in conference
 *在mediaX环境下加入会议前创建会议回控
 */
- (BOOL)requestMediaXConfControlRightWithConfId:(NSString *)confid
                                            pwd:(NSString *)pwd
                                         number:(NSString *)number
                                          token:(NSString *)token
{
    //pwd and token ,can't be empty together.
    if (nil == confid || 0 == confid.length || nil == number || 0 == number.length || (pwd.length == 0 && token.length == 0))
    {
        DDLogInfo(@"requestMediaXConfControlRight param is empty!");
        return NO;
    }
    //get confhandle
    if (_confHandle == 0)
    {
        return NO;
    }

    pwd = (pwd == nil ? @"" : pwd);
    token = (token == nil ? @"" : token);
    
    TUP_RESULT ret_request_confctrl_right = tup_confctrl_request_confctrl_right(_confHandle, [number UTF8String], [pwd UTF8String], [token UTF8String]);
    DDLogInfo(@"ret_request_confctrl_right,result:%d",ret_request_confctrl_right);
    return (ret_request_confctrl_right == TUP_SUCCESS);
    
}

/**
 *This method is used to subscribe conference info(uportal network)
 *uportal组网下订阅会议信息
 */
- (BOOL)subscribeConfWithConfId:(NSString *)confId
{
    if (nil == confId || 0 == confId.length)
    {
        DDLogInfo(@"param is empty!");
        return NO;
    }
    
    if (_confHandle == 0)
    {
        return NO;
    }
    TUP_RESULT ret_subscribe = tup_confctrl_subscribe_conf(_confHandle);
    DDLogInfo(@"tup_confctrl_subscribe_conf,result:%d",ret_subscribe);
    
    return (TUP_SUCCESS == ret_subscribe);
}

/**
 * This method is used to judge whether is uportal mediax conf
 * 判断是否为mediax下的会议
 */
- (BOOL)isUportalMediaXConf
{
    //Mediax conference
    return  (CONF_TOPOLOGY_MEDIAX == self.uPortalConfType);
}

/**
 * This method is used to judge whether is uportal smc conf
 * 判断是否为smc下的会议
 */
- (BOOL)isUportalSMCConf
{
    //SMC conference
    return (CONF_TOPOLOGY_SMC == self.uPortalConfType);
}

/**
 * This method is used to judge whether is uportal UC conf
 * 判断是否为uc下的会议
 */
- (BOOL)isUportalUSMConf
{
    //UC conference
    return (CONF_TOPOLOGY_UC == self.uPortalConfType);
}

/**
 * This method is used to set conf mode
 * 设置会议模式
 */
- (void)setConfMode:(EC_CONF_MODE)mode {
    CONFCTRL_E_CONF_MODE tupMode;
    switch (mode) {
        case EC_CONF_MODE_FIXED:
            tupMode = CONFCTRL_E_CONF_MODE_FIXED;
            break;
        case EC_CONF_MODE_VAS:
            tupMode = CONFCTRL_E_CONF_MODE_VAS;
            break;
        case EC_CONF_MODE_FREE:
            tupMode = CONFCTRL_E_CONF_MODE_FREE;
            break;
        default:
            break;
    }
    
    TUP_RESULT ret_set_conf_mode = tup_confctrl_set_conf_mode(_confHandle, tupMode);
    DDLogInfo(@"ret_set_conf_mode: %d", ret_set_conf_mode);
}

/**
 * This method is used to boardcast attendee
 * 广播与会者
 */
- (void)boardcastAttendeeM:(int)ucM T:(int)ucT isBoardcast:(BOOL)isBoardcast {
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    if(ucT == _BroadcastingT && _BroadcastingT != -1){
        TUP_RESULT ret_boardcast_attendee = tup_confctrl_broadcast_attendee(_confHandle, vcAttendee, NO);
        DDLogInfo(@"cancel boardcast attendee number T: %d, ret: %d", ucT, ret_boardcast_attendee);
    }
    if(_BroadcastingT == -1 || ucT != _BroadcastingT){
        _BroadcastingT = ucT;
        TUP_RESULT ret_boardcast_attendee = tup_confctrl_broadcast_attendee(_confHandle, vcAttendee, YES);
        DDLogInfo(@"boardcast attendee number T: %d, ret: %d", ucT, ret_boardcast_attendee);
    }
}

/**
 * This method is used to watch attendee
 * 观看与会者
 */
- (void)watchAttendeeM:(int)ucM T:(int)ucT
{
    CONFCTRL_S_ATTENDEE_VC *vcAttendee = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC));
    vcAttendee->ucMcuNum = ucM;
    vcAttendee->ucTerminalNum = ucT;
    TUP_RESULT ret_watch_attendee = tup_confctrl_watch_attendee(_confHandle, vcAttendee);
    DDLogInfo(@"watch attendee number T: %d, ret: %d", ucT, ret_watch_attendee);
}

/**
 *This method is used to enable or disable speaker report
 *开启或者关闭发言人上报
 */
- (void)configMediaxSpeakReport
{
    TUP_RESULT result = tup_confctrl_set_speaker_report(_confHandle, TUP_TRUE);
    DDLogInfo(@"tup_confctrl_set_speaker_report, result : %d",result);
}

@end
