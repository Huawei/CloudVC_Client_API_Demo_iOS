//
//  DataConferenceService.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "DataConferenceService.h"
#import "HuaweiSDKService/tup_def.h"
#import "HuaweiSDKService/tup_conf_baseapi.h"
#import "HuaweiSDKService/tup_conf_basedef.h"
#import "HuaweiSDKService/tup_conf_extendapi.h"
#import "HuaweiSDKService/tup_conf_otherapi.h"
#import <UIKit/UIKit.h>
#import "Defines.h"
#import "DataConfParam.h"
#import "ManagerService.h"
#import "ECCurrentConfInfo.h"
#import "ECConfInfo.h"
#import "Notification.h"
#import "ConfCameraInfo.h"
#import "LoginInfo.h"
#import "ChatMsg.h"
#import "ConfAttendeeInConf.h"
#import "ParseConfXMLInfo.h"
//#import "tup_confctrl_advanced_interface.h"
#import "HuaweiSDKService/tup_conf_extenddef.h"
#import "HuaweiSDKService/tup_conf_otherapi.h"
#import "VCConfUpdateInfo.h"
#import "LoginAuthorizeInfo.h"

static const NSString * const CONF_PING_CALLBACK_KEY = @"CONF_PING_CALLBACK_KEY";
static const NSMutableDictionary *s_blockDic = [[NSMutableDictionary alloc] init];

/**
 *This enum is about data conf mode type
 *数据会议模式
 */
typedef NS_ENUM(NSInteger, DataConfMode) {
    DataConfMode_MS = 0,       // MS Mode
    DataConfMode_SBC = 1,      // SBC Mode
    DataConfMode_STG = 2       // STG Mode
};

/**
 *This method is used to define block  ConfPingCallbackBlock
 *定义block
 */
typedef void (^ConfPingCallbackBlock)(NSInteger pingID, NSString *dstIP, NSInteger nType);

#pragma mark - EConference Callbacks
/**
 *This method is used to be param of interface tup_conf_ping_request
 *tup_conf_ping_request接口的ping_callback参数回调
 */
void DataConfPingCallback(TUP_INT nPingID,TUP_CHAR* dst_addr,TUP_UINT8 nType, TUP_UINT16 rtt, TUP_UINT16 jitter, TUP_UINT16 svr_status)
{
    @autoreleasepool {
        if (nType == PING_RET_STATUS) {
            // tup_conf_ping_request方法设置后会回调两次，第一次一定是nType = PING_RET_STATUS，此时无需处理
            DDLogInfo(@"ping call back nType:ping_ret_status");
            return;
        }
        NSString *dstAddr = (dst_addr != NULL) ? [NSString stringWithUTF8String:dst_addr] : @"";
        NSInteger resultType = nType;
        dispatch_async(dispatch_get_main_queue(), ^{
            ConfPingCallbackBlock completion = [s_blockDic objectForKey:CONF_PING_CALLBACK_KEY];
            [s_blockDic removeObjectForKey:CONF_PING_CALLBACK_KEY];
            if (completion) {
                completion(nPingID, dstAddr, resultType);
            }
            
        });
    }
}

/**
 *This enum is about annotation type
 *标注属性
 */
typedef enum {
    ANNOTCUSTOMER_PICTURE,   // picture annotation property
    ANNOTCUSTOMER_MARK,      // mark annotation property
    ANNOTCUSTOMER_POINTER,   // pointer annotation property
    CUSTOMER_ANNOT_COUNT     // annotation count
};

/**
 *This enum is about annotation local resource struct
 *标注图标资源结构 各个元素
 */
typedef enum {
    LOCALRES_CHECK,          // check element
    LOCALRES_XCHECK,         // cCheck element
    LOCALRES_LEFTPOINTER,    // left pointer element
    LOCALRES_RIGHTPOINTER,   // right pointer element
    LOCALRES_UPPOINTER,      // up pointer element
    LOCALRES_DOWNPOINTER,    // down pointer element
    LOCALRES_LASERPOINTER,   // laser pointer element
    
    LOCALRES_COUNT           // element count
};

/**
 *This enum is about callback type
 *回调类型
 */
typedef NS_ENUM(NSUInteger, TUP_CONF_MODULE)
{
    DATA_CONF_MODULE,          // data conference module
    DATA_CONF_COMP_MODULE      // data conference component module
};

static float s_device_dpi =132;

static const NSInteger VIDEO_OPEN = 1;
static const NSInteger VIDEO_CLOSE = 0;

NSString *const TUP_DATACONF_CALLBACK_TYPE_KEY = @"TUP_DATACONF_CALLBACK_TYPE_KEY";
NSString *const TUP_DATACONF_CALLBACK_RESULT_KEY = @"TUP_DATACONF_CALLBACK_RESULT_KEY";

@protocol DataConfNotification <NSObject>

/**
 * This method is used to deel data conference event callback from service
 * 分发数据会议业务相关回调到界面
 *@param module TUP_MODULE
 *@param notification Notification
 */
- (void)dataConfModule:(TUP_CONF_MODULE)module notication:(DataConfNotification *)notification;

@end

/**
 *This is a declaration of protocol DataConfNotification's delegate
 *TupDataConfNotification协议代理
 */
static id<DataConfNotification> g_dataConfDelegate = nil;

/**
 *This method is used to set delegate of protocol TupDataConfNotification
 *数据会议回调delegate
 */
void SetDataConfCallbackHandler(id<DataConfNotification> dataConfDelegate)
{
    g_dataConfDelegate = dataConfDelegate;
}

/**
 *This method is used as a param for tup_conf_new
 *tup_conf_new接口参数conference_multi_callback的回调
 */
void onDataConferenceCallback(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pVoid, TUP_INT nSize)
{
    DataConfNotification *dataConfNotify = [[DataConfNotification alloc] initWithDataConfConfHandle:confHandle nType:nType nValue1:nValue1 nValue2:nValue2 pVoid:pVoid nSize:nSize];
    [g_dataConfDelegate dataConfModule:DATA_CONF_MODULE notication:dataConfNotify];
}

/**
 *This method is used as a param for tup_conf_reg_component_callback;
 *tup_conf_reg_component_callback接口参数component_multi_callback的回调
 */
TUP_VOID ComponentCallBack(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pVoid, TUP_INT nSize)
{
    DataConfNotification *compNotfiy = [[DataConfNotification alloc] initWithDataConfConfHandle:confHandle nType:nType nValue1:nValue1 nValue2:nValue2 pVoid:pVoid nSize:nSize];
    [g_dataConfDelegate dataConfModule:DATA_CONF_COMP_MODULE notication:compNotfiy];
}

@interface ECSDataConfXmlUserInfo : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;                        // xml parser
    NSMutableString *currentStringValue;           // current string value
}
@property (nonatomic, copy) NSString *bindNum;     // the join data conference number parser from xml string

/**
 * This method is used to init this xml string
 * 使用userInfo的Xml字符串进行初始化
 *@param xmlString userInfo的xml字符串
 *@return 实例对象
 */
- (instancetype)initWithXmlUserInfo:(NSString *)xmlString;
@end

@implementation ECSDataConfXmlUserInfo

- (instancetype)initWithXmlUserInfo:(NSString *)xmlString
{
    if (self = [super init]){
        if (xmlString.length > 0)
        {
            currentStringValue = [[NSMutableString alloc]initWithCapacity:0];
            xmlParser = [[NSXMLParser alloc]initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
            xmlParser.delegate = self;
            // 解析xmlParser
            [xmlParser parse];
        }
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // currentStringValue 清空
    [currentStringValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // 获取加入数据会议的与会号码
    if ([elementName isEqualToString:@"BindNum"]) {
        NSString *str = [currentStringValue stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.bindNum = str;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // currentStringValue 拼接上解析出来的字段
    [currentStringValue appendString:string];
}


@end

@interface DataConferenceService()<DataConfNotification> {
    TUP_UINT32 _selfUserId;              // self user Id
}

@property (nonatomic, retain) NSTimer *heartBeatTimer;           // NSTime record heart beat
@property (nonatomic, strong) NSMutableArray *memberArray;       // member array
@property (nonatomic, strong) DataConfParam *dataConfParams;  // data conference params
@property (nonatomic, assign) CameraIndex cameraCaptureIndex;    // Font：1 back：0
@property (nonatomic, assign) BOOL isBeInvite;                   // is been invient or nou
@property (nonatomic, assign) CONF_HANDLE dataConfHandle;        // data conference handle
@property (nonatomic, strong) id localDataConfCameraView;        // local view
@property (nonatomic, strong) id remoteDataConfCameraView;       // remote view
@property (nonatomic, strong) ConfCameraInfo *localCamreaInfo;   // local camrea info
@property (nonatomic, strong) ConfCameraInfo *remoteCamreaInfo;  // remote camrea info
@property (nonatomic, assign) DataConfMode dataConfMode;         // data conference mode ,ms:0,sbc:1,stg:2
@property (nonatomic, assign) BOOL bSTGConf;                     // is stg conferene or not
@end

static DataConferenceService *_dataConf = nil;
@implementation DataConferenceService
@synthesize delegate;
@synthesize chatDelegate;
@synthesize localCameraInfos = _localCameraInfos;
@synthesize remoteCameraInfos = _remoteCameraInfos;
@synthesize currentCameraInfo = _currentCameraInfo;
@synthesize isDataBFCPShow = _isDataBFCPShow;
@synthesize isJoinDataConference = _isJoinDataConference;


/**
 * This method is used to init this class
 *@return 实例对象
 */
-(instancetype)init
{
    if (self = [super init])
    {
        _bSTGConf = NO;
        _dataConfHandle = 0;
        _cameraCaptureIndex = CameraIndexFront;
        
        _memberArray = [[NSMutableArray alloc] init];
        _localCamreaInfo = [[ConfCameraInfo alloc] init];
        _remoteCamreaInfo = [[ConfCameraInfo alloc] init];
        _localCameraInfos = [[NSMutableArray alloc] init];
        _remoteCameraInfos = [[NSMutableArray alloc] init];
        _isDataBFCPShow = NO;
        _dataConfMode = DataConfMode_MS;    // 默认数据会议走MS方式
        _isJoinDataConference = NO;
//        [self startHeartBeatTimer];
        SetDataConfCallbackHandler(self);
    }
    return self;
}


#pragma mark - Data Conference Call Back Deal

/**
 * This method is used to distribute data conference event callback from data conference module or data conference component module
 * 区分数据会议业务是从DATA_CONF_MODULE的回调 还是DATA_CONF_COMP_MODULE 的回调
 *@param module TUP_CONF_MODULE
 *@param notification DataConfNotification
 */
- (void)dataConfModule:(TUP_CONF_MODULE)module notication:(DataConfNotification *)notification {
    if (module == DATA_CONF_MODULE) {
        [self onRecvTupConferenceNotification:notification];
    }else if (module == DATA_CONF_COMP_MODULE) {
        [self onRecvTupDataCompConferenceNotification:notification];
    }
}

/**
 * This method is used to deel DataConfNotification from DATA_CONF_MODULE
 * 分发DATA_CONF_MODULE来的通知消息
 *@param dataConfNotify DataConfNotification
 */
-(void)onRecvTupConferenceNotification:(DataConfNotification *)dataConfNotify
{
    [self dealConferenceCallBack:dataConfNotify.nType value1:dataConfNotify.nValue1 value2:dataConfNotify.nValue2 data:dataConfNotify.pVoid dataLength:dataConfNotify.nSize];
}

/**
 * This method is used to deel DATA_CONF_MODULE data conference event callback from service
 * 分发DATA_CONF_MODULE数据会议业务相关回调
 *@param nType int
 *@param nValue1 int
 *@param nValue2 long
 *@param pdata void*
 *@param nSize int
 */
-(void)dealConferenceCallBack:(int)nType value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    switch (nType)
    {
            // 加入数据会议通知
        case CONF_MSG_ON_CONFERENCE_JOIN:
        {
            DDLogInfo(@"CONF_MSG_ON_CONFERENCE_JOIN nType : %d, isSuccess : %d, nValue2:%ld",nType,nValue1,nValue2);
            NSDictionary *resultInfo = nil;
            BOOL isSuccess = NO;
            _isBeInvite = NO;
            if (nValue1 == TC_OK) {
                isSuccess = YES;
                _isJoinDataConference = YES;
                // 加入数据会议成功后，加载数据会议组件模块
                [self loadComponent];
            }else {
                // 如果加入数据会议失败，则20毫秒后释放数据会议资源
                [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.02];
            }
            resultInfo = @{
                           UCCONF_RESULT_KEY :[NSNumber numberWithBool:isSuccess]
                           };
            [self respondsDataConferenceDelegateWithType:DATA_CONFERENCE_JOIN_RESULT result:resultInfo];
            break;
        }
            // 数据会议组件加载成功通知，每个组件是否加载成功都会抛此消息上来
        case CONF_MSG_ON_COMPONENT_LOAD:
        {
            DDLogInfo(@"CONF_MSG_ON_COMPONENT_LOAD");
            [self handleComponetLoadWithValue:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 用户加入数据会议的通知，所有会议中的用户都会收到
        case CONF_MSG_USER_ON_ENTER_IND:
        {
            [self handleUserEnterConfWithData:pdata];
            break;
        }
            // 电话用户接入通知
        case CONF_MSG_ON_PHONE_ENTER_IND: {
            [self handlePhoneUserEnterConfWith:pdata];
            break;
        }
            // 用户离开数据会议通知，所有会议中的用户都会收到
        case CONF_MSG_USER_ON_LEAVE_IND:
        {
            [self handleUserLeaveConfWithData:pdata];
            break;
        }
            // 数据会议结束通知
        case CONF_MSG_ON_CONFERENCE_TERMINATE:
        {
            _isJoinDataConference = NO;
            DDLogInfo(@"CONF_MSG_ON_CONFERENCE_TERMINATE");
            [self conferenceTerminate:nValue1];
            break;
        }
            // 离开数据会议通知
        case CONF_MSG_ON_CONFERENCE_LEAVE:
        {
            _isJoinDataConference = NO;
            DDLogInfo(@"CONF_MSG_ON_CONFERENCE_LEAVE");
            [self leaveDataConference];
            break;
        }
            // 主讲人变更通知，设置者会收到
        case CONF_MSG_USER_ON_PRESENTER_GIVE_CFM:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_PRESENTER_GIVE_CFM result: %d",nValue1);
            BOOL result = nValue1 == TC_OK ? YES : NO;
            NSDictionary *resultInfo = @{
                                         UCCONF_SET_PERSENTER_RESULT_KEY :[NSNumber numberWithBool:result]
                                         };
            [self respondsDataConferenceDelegateWithType:DATACONF_SET_PERSENTER_RESULT result:resultInfo];
            break;
        }
            // 主讲人变更通知，被给予者会收到
        case CONF_MSG_USER_ON_PRESENTER_GIVE_IND:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_PRESENTER_GIVE_IND give persent: %d",nValue1);
            [self respondsDataConferenceDelegateWithType:DATACONF_GET_PERSENT result:nil];
            break;
        }
            // 主讲人变更通知， 所有人都能收到
        case CONF_MSG_USER_ON_PRESENTER_CHANGE_IND:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_PRESENTER_CHANGE_IND oldPersenter: %d, newPersenter: %d",nValue1,nValue2);
            
            NSMutableArray *joinedAttenees = [ManagerService confService].haveJoinAttendeeArray;
            NSString*beforeUserId = [NSString stringWithFormat:@"%d",nValue1];
            NSString* afterUserID = [NSString stringWithFormat:@"%d", nValue2];
            // 遍历已在语音会议中成员，如果该用户在语音会议中，更改其加入数据会议状态为已入数据会议状态
            for (VCConfUpdateInfo *attendee in joinedAttenees) {
                if ([attendee.userID isEqualToString:afterUserID]) {
                    attendee.dataState = DataConfAttendeeMediaStatePresent;
                }
                if ([attendee.userID isEqualToString:beforeUserId]) {
                    attendee.dataState = DataConfAttendeeMediaStateIn;
                }
            }
            NSDictionary *resultInfo = @{
                                         UCCONF_OLDPERSENTER_KEY :[NSNumber numberWithInt:nValue1],
                                         UCCONF_NEWPERSENTER_KEY :[NSNumber numberWithInt:nValue2]
                                         };
            [self respondsDataConferenceDelegateWithType:DATACONF_PERSENTER_CHANGE result:resultInfo];
            break;
        }
            // 主讲人变更通知，主动申请者回受到
        case CONF_MSG_USER_ON_HOST_GIVE_CFM:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_HOST_GIVE_CFM result : %d",nValue1);
            BOOL result = nValue1 == TC_OK ? YES : NO;
            NSDictionary *resultInfo = @{
                                         UCCONF_SET_HOST_RESULT_KEY :[NSNumber numberWithBool:result]
                                         };
            [self respondsDataConferenceDelegateWithType:DATACONF_SET_HOST_RESULT result:resultInfo];
            break;
        }
            // 主持人变更通知，被给予者会收到
        case CONF_MSG_USER_ON_HOST_GIVE_IND:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_HOST_GIVE_IND givehost: %d",nValue1);
            [self respondsDataConferenceDelegateWithType:DATACONF_GET_HOST result:nil];
            break;
        }
            // 主持人变更通知，所有人都会收到
        case CONF_MSG_USER_ON_HOST_CHANGE_IND:
        {
            DDLogInfo(@"CONF_MSG_USER_ON_HOST_CHANGE_IND oldhost: %d, newhost: %d",nValue1,nValue2);
            NSDictionary *resultInfo = @{
                                         UCCONF_OLDHOST_KEY :[NSNumber numberWithInt:nValue1],
                                         UCCONF_NEWHOST_KEY :[NSNumber numberWithInt:nValue2]
                                         };
            [self respondsDataConferenceDelegateWithType:DATACONF_HOST_CHANGE result:resultInfo];
            break;
        }
            // 电话能力更新通知，数据会议中辅流是否解码成功也通过此消息上报
        case CONF_MSG_ON_PHONE_CALL_VIDEO_CAPABLE_IND:
        {
            DDLogInfo(@"CONF_MSG_ON_PHONE_CALL_VIDEO_CAPABLE_IND");
            if (NULL == pdata)
            {
                DDLogInfo(@"onConfPhoneCallVideoStatus data is NULL!");
                return;
            }
            TC_Conf_Phone_Record *pPhoneUserInfo = (TC_Conf_Phone_Record *)pdata;
            
            BOOL isPhoneUserEnter = (0x01 == (pPhoneUserInfo->m_video_dev_capable & 0x01));
            BOOL isBFcpVideoStatusOn = (0x02 == (pPhoneUserInfo->m_video_dev_capable & 0x02));
            if (isPhoneUserEnter) {
                DDLogInfo(@"is phone user enter, number: %@", pPhoneUserInfo->m_phone_user_name);
            }
            
            NSDictionary *resultInfo = @{ECCONF_DATA_CONF_BFCP_KEY: [NSNumber numberWithBool:isBFcpVideoStatusOn]};
            // 数据会议辅流是否解码成功
            _isDataBFCPShow = isBFcpVideoStatusOn;
            [self respondsDataConferenceDelegateWithType:DATACONF_BFCP_SHARE result:resultInfo];
            break;
        }
        default:
            break;
    }
}

/**
 * This method is used to deel DataConfNotification data from DATA_CONF_COMP_MODULE
 * 分发DATA_CONF_COMP_MODULE来的通知消息
 *@param dataConfNotify DataConfNotification
 */
-(void)onRecvTupDataCompConferenceNotification:(DataConfNotification *)compNotify
{
    [self dealComponentCallBack:compNotify.nType value1:compNotify.nValue1 value2:compNotify.nValue2 data:compNotify.pVoid dataLength:compNotify.nSize];
}

/**
 * This method is used to deel DATA_CONF_COMP_MODULE data conference event callback from service
 * 分发DATA_CONF_COMP_MODULE数据会议业务相关回调
 *@param nType int
 *@param nValue1 int
 *@param nValue2 long
 *@param pdata void*
 *@param nSize int
 */
-(void)dealComponentCallBack:(int)nType value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    switch (nType)
    {
            // 视频状态通知相关
        case COMPT_MSG_VIDEO_ON_SWITCH: //1: open 0: close  2.Resume 4.Pause
        {
            DDLogInfo(@"COMPT_MSG_VIDEO_ON_SWITCH nValue1:%d",nValue1);
            [self handleVideoSwitchWithValue:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 收到别人发出的命令通知：打开视频命令，关闭视频命令
        case COMPT_MSG_VIDEO_ON_NOTIFY:
        {
            DDLogInfo(@"COMPT_MSG_VIDEO_ON_NOTIFY userId: %d, open: %d",nValue1,nValue2);
            TC_VIDEO_PARAM* videoParam = (TC_VIDEO_PARAM*)pdata;
            BOOL isOpen = nValue2 == 1 ? YES : NO;
            DDLogInfo(@"isOpen : %d",isOpen);
            NSDictionary *resultInfo = @{
                                         DATACONF_VIDEO_ON_NOTIFY_KEY : [NSNumber numberWithBool:isOpen]
                                         };
            [self respondsDataConferenceDelegateWithType:DATACONF_VEDIO_ON_NOTIFY result:resultInfo];
            break;
        }
            // 共享状态通知
        case COMPT_MSG_AS_ON_SHARING_STATE:
        {
            DDLogInfo(@"COMPT_MSG_AS_ON_SHARING_STATE");
            [self handleScreenShareState:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 共享通道通知
        case COMPT_MSG_AS_ON_SHARING_SESSION://2122
        {
            DDLogInfo(@"COMPT_MSG_AS_ON_SHARING_SESSION:nValue1: %d",nValue1);
        }
            break;
            // 屏幕数据更新通知
        case COMPT_MSG_AS_ON_SCREEN_DATA:
        {
            DDLogInfo(@"COMPT_MSG_AS_ON_SCREEN_DATA");
            [self handleScreenShare:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 收到聊天消息
        case COMPT_MSG_CHAT_ON_RECV_MSG:
        {
            DDLogInfo(@"COMPT_MSG_CHAT_ON_RECV_MSG result: %ld",nValue2);
            [self handleChatMSG:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 电话能力更新通知，数据会议中辅流是否解码成功也通过此消息上报
        case CONF_MSG_ON_PHONE_CALL_VIDEO_CAPABLE_IND:
        {
            DDLogInfo(@"CONF_MSG_ON_PHONE_CALL_VIDEO_CAPABLE_IND=====");
            if (NULL == pdata)
            {
                DDLogInfo(@"onConfPhoneCallVideoStatus data is NULL!");
                return;
            }
            TC_Conf_Phone_Record *pPhoneUserInfo = (TC_Conf_Phone_Record *)pdata;
            
            BOOL isPhoneUserEnter = (0x01 == (pPhoneUserInfo->m_video_dev_capable & 0x01));
            BOOL isBFcpVideoStatusOn = (0x02 == (pPhoneUserInfo->m_video_dev_capable & 0x02));
            if (isPhoneUserEnter) {
                DDLogInfo(@"is phone user enter, number: %@", pPhoneUserInfo->m_phone_user_name);
            }
            
            NSDictionary *resultInfo = @{ECCONF_DATA_CONF_BFCP_KEY: [NSNumber numberWithBool:isBFcpVideoStatusOn]};
            // 数据会议辅流是否解码成功
            _isDataBFCPShow = isBFcpVideoStatusOn;
            [self respondsDataConferenceDelegateWithType:DATACONF_BFCP_SHARE result:resultInfo];
            break;
        }
        default:
            break;
    }
    
    //About Audio Component
    if (nType<= COMPT_MSG_AUDIO_MAX && nType>=COMPT_MSG_AUDIO_ON_AUDIO_MUTE_ALL_ATTENDEE )
    {
        [self dealAudioComponentCallBack:nType value1:nValue1 value2:nValue2 data:pdata dataLength:nSize];
    }
    //About WB Component
    if (nType<= COMPT_MSG_WB_MAX && nType>=COMPT_MSG_WB_ON_DOC_NEW)
    {
        [self dealWBComponentCallBack:nType value1:nValue1 value2:nValue2 data:pdata dataLength:nSize];
    }
    //About DS Component
    if (nType<= COMPT_MSG_DS_MAX && nType>=COMPT_MSG_DS_BASE)
    {
        [self dealDSComponentCallBack:nType value1:nValue1 value2:nValue2 data:pdata dataLength:nSize];
    }
}

/**
 * This method is used to deal DS component event call back from service
 * 数据会议文档共享相关回调处理
 *@param nType int
 *@param nValue1 int
 *@param nValue2 long
 *@param pdata void*
 *@param nSize int
 */
-(void)dealDSComponentCallBack:(int)nType value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    switch (nType)
    {
            // 新建一个文档通知
        case COMPT_MSG_DS_ON_DOC_NEW:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_DOC_NEW");
            [self confSetCurrentPage:IID_COMPONENT_DS value1:nValue1 value2:nValue2 sync:1];
            break;
        }
            // 新建一页通知
        case COMPT_MSG_DS_ON_PAGE_NEW:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_DOC_NEW");
            [self confSetCurrentPage:IID_COMPONENT_DS value1:nValue1 value2:nValue2 sync:1];
            break;
        }
            // 同步翻页预先通知
        case COMPT_MSG_DS_ON_CURRENT_PAGE_IND:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_CURRENT_PAGE_IND");
            [self handleConfSharedDocPageChangedWithValue:nValue1 value2:nValue2 data:pdata dataLength:nSize];
            break;
        }
            // 文档界面数据通知
        case COMPT_MSG_DS_ON_DRAW_DATA_NOTIFY:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_DRAW_DATA_NOTIFY ");
            [self getSuraceBmpWithComponet:IID_COMPONENT_DS value1:nValue1 value2:nValue2 data:pdata];
            break;
        }
            // 删除一页通知
        case COMPT_MSG_DS_ON_PAGE_DEL:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_PAGE_DEL ");
            break;
        }
            // 删除一个文档
        case COMPT_MSG_DS_ON_DOC_DEL:
        {
            DDLogInfo(@"COMPT_MSG_DS_ON_DOC_DEL ");
            break;
        }
        default:
            break;
    }
}

/**
 * This method is used to deal WB component event call back from service
 * 数据会议白板相关回调处理
 *@param nType int
 *@param nValue1 int
 *@param nValue2 int
 *@param pdata int
 *@param nSize int
 */
-(void)dealWBComponentCallBack:(int)nType value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    switch (nType)
    {
            // 新建一个文档通知
        case COMPT_MSG_WB_ON_DOC_NEW :
        {
            DDLogInfo(@"COMPT_MSG_WB_ON_DOC_NEW");
            [self confSetCurrentPage:IID_COMPONENT_WB value1:nValue1 value2:nValue2 sync:1];
            break;
        }
            // 删除一个文档通知
        case COMPT_MSG_WB_ON_DOC_DEL:
        {
            DDLogInfo(@"COMPT_MSG_WB_ON_DOC_DEL");
            [self respondsDataConferenceDelegateWithType:DATACONF_SHARE_STOP result:nil];
            break;
        }
            // 新建一页通知
        case COMPT_MSG_WB_ON_PAGE_NEW :
        {
            DDLogInfo(@"COMPT_MSG_WB_ON_PAGE_NEW");
            [self confSetCurrentPage:IID_COMPONENT_WB value1:nValue1 value2:nValue2 sync:1];
            break;
        }
            // 翻页前预先通知
        case COMPT_MSG_WB_ON_CURRENT_PAGE_IND :
        {
            DDLogInfo(@"COMPT_MSG_WB_ON_CURRENT_PAGE_IND result: %ld",nValue2);
            [self confSetCurrentPage:IID_COMPONENT_WB value1:nValue1 value2:nValue2 sync:0];
            break;
        }
            // 白板界面数据通知
        case COMPT_MSG_WB_ON_DRAW_DATA_NOTIFY :
        {
            DDLogInfo(@"COMPT_MSG_WB_ON_DRAW_DATA_NOTIFY ");
            [self getSuraceBmpWithComponet:IID_COMPONENT_WB value1:nValue1 value2:nValue2 data:pdata];
            break;
        }
        default:
            break;
    }
}

/**
 * This method is used to deal audio component event call back from service
 * 数据会议音频相关回调处理
 *@param nType int
 *@param nValue1 int
 *@param nValue2 int
 *@param pdata int
 *@param nSize int
 */
-(void)dealAudioComponentCallBack:(int)nType value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    DDLogInfo(@"AudioComponentCallBack nType:%d :%d :%ld",nType,nValue1,nValue2);
    switch (nType)
    {
            // 音频设备热插拔通知
        case COMPT_MSG_AUDIO_ON_ENGINE_DEVICE_CHANGE:
        {
            DDLogInfo(@"COMPT_MSG_AUDIO_ON_ENGINE_DEVICE_CHANGE");
            break;
        }
            // 移动路由状态发生变化通知
        case COMPT_MSG_AUDIO_ON_ENGINE_ROUTE_CHANGE_NOTIFY:
        {
            DDLogInfo(@"COMPT_MSG_AUDIO_ON_ENGINE_ROUTE_CHANGE_NOTIFY");
            break;
        }
            // 音频设备状态通知
        case COMPT_MSG_AUDIO_ON_AUDIO_DEVICE_STATUS_CHANGE:
        {
            DDLogInfo(@"COMPT_MSG_AUDIO_ON_AUDIO_DEVICE_STATUS_CHANGE");
            break;
        }
            // 异步打开mic结果通知
        case COMPT_MSG_AUDIO_ON_AUDIO_OPEN_MIC:
        {
            DDLogInfo(@"COMPT_MSG_AUDIO_ON_AUDIO_OPEN_MIC");
            break;
        }
        default:
            break;
    }
}


#pragma mark - Heart Beat Timer Deal
/**
 * This method is used to create _heartBeatTimer.
 * 创建定时器
 */
-(void)startHeartBeatTimer
{
//    [self stopHeartBeat];
    dispatch_async(dispatch_get_main_queue(), ^{
        _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                           target:self
                                                         selector:@selector(heartBeat)
                                                         userInfo:nil
                                                          repeats:YES];
    });
}

/**
 * This method is used to release data conference
 * 释放数据会议资源
 */
-(void)stopDataConference {
    _dataConfParams = nil;
    [self stopHeartBeat];
    tup_conf_release(_dataConfHandle);
    SetDataConfCallbackHandler(nil);
    tup_conf_uninit();
    if (_bSTGConf) {
        _bSTGConf = NO;
        tup_conf_stop_stg_net();
    }
    tup_conf_cache_delete();
    _dataConfHandle = 0;
    _dataConfMode == DataConfMode_MS;
}

/**
 * This method is used to deal tup_conf_heart interface
 * 会议心跳接口
 */
-(void)heartBeat
{
    tup_conf_heart(_dataConfHandle);
}

/**
 * This method is used to stop _heartBeatTimer.
 * 销毁_heartBeatTimer定时器
 */
-(void)stopHeartBeat
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLogInfo(@"<INFO>: stopHeartBeat: enter!!! ");
        if ([self.heartBeatTimer isValid])
        {
            DDLogInfo(@"<INFO>: stopHeartBeat");
            [self.heartBeatTimer invalidate];
            self.heartBeatTimer = nil;
        }
    });
    
}

#pragma mark - Join Data Conference Deal

/**
 * this method is use to init data conference
 * 数据会议初始化
 */
- (void)prepareForDataConference {
    NSString *logPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log"];
    NSString *path = [logPath stringByAppendingString:@"/dataConf"];
    Init_param initParam;
    initParam.os_type = CONF_OS_IOS;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        initParam.dev_type = CONF_DEV_PHONE;
    }else {
        initParam.dev_type = CONF_DEV_PAD;
    }
    initParam.dev_dpi_x = 0;
    initParam.dev_dpi_y = 0;
    initParam.media_log_level = LOG_DEBUG;
    initParam.sdk_log_level = LOG_DEBUG;
    initParam.conf_mode = 0;
    
    strncpy(initParam.log_path, [path UTF8String], TC_MAX_PATH);
    strncpy(initParam.temp_path, [path UTF8String], TC_MAX_PATH);
    TUP_RESULT ret_conf_init = tup_conf_init(false, &initParam);
    [self startHeartBeatTimer];
    SetDataConfCallbackHandler(self);
}

/**
 * This method is used to join data conference after get data conference param
 * 获取数据会议大参数后，做加入数据会议操作
 *@param dataConfParams DataConfParam
 */
- (void)joinDataConfWithParams:(DataConfParam *)dataConfParams
{
    [self prepareForDataConference];
    
    [self confPingRequestWith:dataConfParams completionBlock:^(DataConfMode dataConfMode, NSString *sbcServerIP, NSString *msServerIP) {
        //                        join.dataConfMode = dataConfMode;
        //                        join.selSBCServerIP = sbcServerIP;
        //                        join.selMSServerIP = msServerIP;
        _dataConfMode = dataConfMode;
        NSString *serverIP = @"";
        NSString *serverType = @"";
        
        // 暂时屏蔽如果MT号为空的场景，待确认
//        // 在mediaX会议中当会议大参数获取的MT号为空时通过会议资源接口重新获取一次
//        if ([[ManagerService confService] isUportalMediaXConf] && dataConfParams.M == 0)
//        {
//            switch (dataConfMode) {
//                case DataConfMode_MS:
//                    serverIP = msServerIP;
//                    serverType = @"0";
//                    break;
//                case DataConfMode_SBC:
//                    serverIP = sbcServerIP;
//                    serverType = @"1";
//                    break;
//                case DataConfMode_STG:
//                    serverIP = msServerIP;
//                    serverType = @"2";
//                    break;
//                    
//                default:
//                    DDLogInfo(@"data conf mode error");
//                    serverIP = msServerIP;
//                    serverType = @"0";
//                    break;
//            }
//            
//            [self getConfResourceWithServerIP:serverIP serverType:serverType dataConfParam:dataConfParams];
//        }else{
            [self createDataConfObjectWithParams:dataConfParams];
//        }
    }];
}

/**
 * This method is used to join data conference
 * 加入数据会议
 *@param dataConfParams DataConfParam
 *@return BOOL
 */
-(BOOL)createDataConfObjectWithParams:(DataConfParam *)dataConfParams
{
    if (self.dataConfParams || _dataConfHandle != 0)
    {
        return NO;
    }
    __block int result = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _dataConfParams = dataConfParams;
        LoginAuthorizeInfo *loginInfo = [[ManagerService loginService] obtainLoginAuthorizeInfo];
        TC_CONF_INFO *confInfo = (TC_CONF_INFO *)malloc(sizeof(TC_CONF_INFO));
        memset(confInfo, 0, sizeof(TC_CONF_INFO));

        int userID = [loginInfo.selfNum intValue];
        DDLogInfo(@"report user id: %d", userID);
        confInfo->user_id = userID;
        confInfo->conf_id = [dataConfParams.confId intValue];
        confInfo->user_type = CONF_ROLE_GENERAL;
        
        /*
         * Report user information(user_info) to match participants in voice conference,
         * When receive data session(CONF_MSG_USER_ON_ENTER_IND), analysis user_info, get number, match attendees
         */
        NSString *userInfoXml = [NSString stringWithFormat:@"<UserInfo><BindNum>%@</BindNum></UserInfo>", dataConfParams.userUri];
        //Report user_info
        confInfo->user_info = (TUP_UINT8 *)[userInfoXml UTF8String];
        confInfo->user_info_len = userInfoXml.length + 1;
        DDLogInfo(@"Report user info: %@", userInfoXml);
        DDLogInfo(@"Data_Conf_Log: confInfo->user_type : %d",confInfo->user_type);
        confInfo->user_capability = 0;
        confInfo->sever_timer = 0;
        
        confInfo->userM = (TUP_UINT32)dataConfParams.M;
        confInfo->userT = (TUP_UINT32)dataConfParams.T;
        strncpy(confInfo->host_key,[dataConfParams.hostKey UTF8String],dataConfParams.hostKey.length);
        strncpy(confInfo->site_id, [dataConfParams.siteId UTF8String],dataConfParams.siteId.length);
        
        strncpy(confInfo->encryption_key, [dataConfParams.cryptKey UTF8String],dataConfParams.cryptKey.length);
        
        strncpy(confInfo->user_log_uri, [loginInfo.selfNum UTF8String],loginInfo.selfNum.length);
        strncpy(confInfo->user_name, [loginInfo.loginAccount UTF8String],loginInfo.loginAccount.length);
        strncpy(confInfo->conf_title, [@"Data conference" UTF8String],@"Data conference".length);
        
        TUP_UINT32 dwOptions = CONF_OPTION_USERLIST
        | CONF_OPTION_PHONE
        | CONF_OPTION_QOS
        | CONF_OPTION_HOST_NO_GRAB
        | CONF_OPTION_NEW_APPSHARE;
        
        _bSTGConf = (DataConfMode_STG == _dataConfMode);
        
        if (_dataConfMode == DataConfMode_SBC) {
            strncpy(confInfo->ms_server_ip,[dataConfParams.sbcServerAddress UTF8String],dataConfParams.sbcServerAddress.length);
            strncpy(confInfo->site_url, [dataConfParams.siteUrl UTF8String],dataConfParams.siteUrl.length);
            strncpy(confInfo->ms_server_interip,[dataConfParams.serverIp UTF8String],dataConfParams.serverIp.length);
//            confInfo->user_capability = 0; //用户能力
        }else{
            dwOptions = CONF_OPTION_USERLIST;
            dwOptions |= CONF_OPTION_LOAD_BALANCING;
            dwOptions |= CONF_OPTION_FLOW_CONTROL;
            strncpy(confInfo->ms_server_ip,[dataConfParams.serverIp UTF8String],dataConfParams.serverIp.length);
            strncpy(confInfo->site_url, [dataConfParams.cmAddress UTF8String],dataConfParams.cmAddress.length);
        }
        
        
        result = tup_conf_new((conference_multi_callback)onDataConferenceCallback, confInfo, dwOptions,&_dataConfHandle);
        DDLogInfo(@"Data_Conf_Log: _dataConfHandle is:%d",_dataConfHandle);
        DDLogInfo(@"Data_Conf_Log: tup_conf_new = %i",result);
        if (result == TC_OK)
        {
            if (_bSTGConf) {
                TC_STG_REGISTER_INFO_S stgRegisterInfo;
                memset(&stgRegisterInfo, 0, sizeof(TC_STG_REGISTER_INFO_S));
                // 1744939180只是临时写的一个非0的ip值(接口只需要非零值)，没有特殊意义；
                TUP_INT32 start_stg_ret = tup_conf_start_stg_net(NULL, &stgRegisterInfo, 1744939180);
                DDLogInfo(@"tup_conf_start_stg_net result: %d", start_stg_ret);
            }
            
            [self confSetServerList:dataConfParams.serverIp];
            
            // 设置电话会议的参数
            PHONE_CONFIG_INFO confPhoneConfig;
            memset(&confPhoneConfig, 0, sizeof(confPhoneConfig));
            strncpy(confPhoneConfig.conf_id, [dataConfParams.confId UTF8String], 16);
            strncpy(confPhoneConfig.conf_num, [dataConfParams.confId UTF8String], 16);
            strncpy(confPhoneConfig.host_pwd, [dataConfParams.hostKey UTF8String], 32);
            strncpy(confPhoneConfig.server_url, [dataConfParams.siteUrl UTF8String], 128);
            confPhoneConfig.sess_flag = TC_SESS_FLAG_AV_MIX;
            confPhoneConfig.attendee_num = 20;
            tup_conf_phone_config(_dataConfHandle, &confPhoneConfig);
            
            // 设置网络配置
            TC_CONF_INIT_CONFIG pconfig;
            memset(&pconfig, 0, sizeof(TC_CONF_INIT_CONFIG));
            pconfig.init_users_privilege = 0;
            tup_conf_setconfig(_dataConfHandle, &pconfig);
            
            [self joinDataConference];
        }
        else
        {
            NSDictionary *resultInfo = @{
                                         UCCONF_RESULT_KEY :[NSNumber numberWithBool:NO]
                                         };
            [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.02];
            [self respondsDataConferenceDelegateWithType:DATA_CONFERENCE_JOIN_RESULT result:resultInfo];
            DDLogInfo(@"Data_Conf_Log: tup_conf_new fail post message to UI");
        }
        free(confInfo);
    });
    _isBeInvite = NO;
    return result == TC_OK ? YES : NO;
}

/**
 * This method is used to set MS address list.
 * 设置MS地址列表接口
 *@param msServerAddress NSString
 *@return BOOL
 */
-(BOOL)confSetServerList:(NSString *)msServerAddress
{
    TUP_RESULT result =  tup_conf_setiplist(_dataConfHandle, [msServerAddress UTF8String]);
    DDLogInfo(@"Data_Conf_Log: tup_conf_setiplist = %d , ms address is :%@",result,msServerAddress);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 * This method is used to join conference.
 * 加入数据会议接口
 *@return BOOL
 */
- (BOOL)joinDataConference
{
    int result = TC_FAILURE;
    result =  tup_conf_join(_dataConfHandle);
    DDLogInfo(@"Call_Log: tup_conf_join = %i",result);
    if (result != TC_OK)
    {
        // 如果加入数据会议失败，20毫秒后释放数据会议资源
        NSDictionary *resultInfo = @{
                                     UCCONF_RESULT_KEY :[NSNumber numberWithBool:NO]
                                     };
        [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.02];
        [self respondsDataConferenceDelegateWithType:DATA_CONFERENCE_JOIN_RESULT result:resultInfo];
        DDLogInfo(@"Data_Conf_Log: tup_conf_join fail post message to UI");
    }
    _isBeInvite = NO;
    return result==TC_OK ? YES : NO;
}


/**
 * This method is used to regist data conference component all son components
 * 加载数据会议组件模块各个组件
 *@param iComponentID int
 *@return int
 */
- (int)registComponentsCallBack:(int)iComponentID
{
    // 加载会议控制组件
    if(iComponentID == IID_COMPONENT_BASE)
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_BASE, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_base_reg_callback : compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载文档共享组件
    if(IID_COMPONENT_DS == (iComponentID & IID_COMPONENT_DS))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_DS, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_ds_reg_callback : compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载屏幕共享组件
    if(IID_COMPONENT_AS == (iComponentID & IID_COMPONENT_AS))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_AS, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_as_reg_callback: compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载音频组件
    if(IID_COMPONENT_AUDIO == (iComponentID & IID_COMPONENT_AUDIO))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_AUDIO, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_audio_reg_callback: compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载视频组件
    if(IID_COMPONENT_VIDEO == (iComponentID & IID_COMPONENT_VIDEO))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_VIDEO, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_video_reg_callback: compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载聊天组件
    if(IID_COMPONENT_CHAT == (iComponentID & IID_COMPONENT_CHAT))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_CHAT, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_chat_reg_callback: compId=%d, result=%d", iComponentID, iRet);
    }
    // 加载白板组件
    if (IID_COMPONENT_WB == (iComponentID & IID_COMPONENT_WB))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(_dataConfHandle, IID_COMPONENT_WB, ComponentCallBack);
        DDLogInfo(@"<INFO>: conf_wb_reg_callback: compId=%d, result=%d", iComponentID, iRet);
    }
    return 0;
}

/**
 * This method is used deal the notice of end of conference.
 * 数据会议结束通知处理
 *@param nValue1 int
 */
-(void)conferenceTerminate:(int)nValue1
{
    // 20毫秒后释放会议资源
    [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.02];
    BOOL result = nValue1 == TC_OK ? YES : NO;
    NSDictionary *resultInfo = @{
                                 UCCONF_RESULT_KEY :[NSNumber numberWithBool:result]
                                 };
    [self respondsDataConferenceDelegateWithType:DATA_CONFERENCE_END result:resultInfo];
}

/**
 * This method is used to loads the specified component .
 * 加载数据会议组件模块
 */
-(void)loadComponent
{
    tup_conf_get_server_time(_dataConfHandle);
    TUP_UINT32 nNeedComponents =  IID_COMPONENT_BASE | IID_COMPONENT_DS | IID_COMPONENT_AS | IID_COMPONENT_VIDEO |IID_COMPONENT_CHAT|IID_COMPONENT_WB |IID_COMPONENT_AUDIO;
    int bRet = tup_conf_load_component(_dataConfHandle, nNeedComponents);
    if (TC_OK == bRet)
    {
        // 加载数据会议组件模块各个组件
        [self registComponentsCallBack:nNeedComponents];
    }
    DDLogInfo(@"TUP_DATA_CONF_LOG: conf_load_component result = %d", bRet);
}

/**
 * This method is used to notify a data user joining a meeting
 * 用户加入数据会议通知处理
 *@param data void *
 */
- (void)handleUserEnterConfWithData:(void *)data
{
    TC_Conf_User_Record *user = (TC_Conf_User_Record *)data;
    if ((user->user_capability & 0x00100000) != 0) {
        return;
    }
    
    TUP_UINT32 userid = user->user_alt_id;
    NSString *userName = [NSString stringWithUTF8String:user->user_name];
    NSString *userNumber;
    if (NULL != user->user_info) {
        NSString *userInfoString = [self getContentStringFromUserInfo:user->user_info
                                                    withMessageLength:user->user_info_len];
        
        // 解析xml字段
        ECSDataConfXmlUserInfo *xmlUserInfo = [[ECSDataConfXmlUserInfo alloc] initWithXmlUserInfo:userInfoString];
        userNumber = xmlUserInfo.bindNum;
        DDLogInfo(@"xml analytic user number: %@", userNumber);
    }
    
    if (0 == userNumber.length) {
        userNumber = [NSString stringWithUTF8String:user->user_alt_uri];
    }

    
    DDLogInfo(@"tup data conf user enter: %d %@ %@", userid, userNumber, userName);
    
    [self dealDataConfUserEnterEventWithNumber:userNumber userName:userName userId:userid];
}


/**
 * This method is used to get xml string
 * 获取xml字段
 *@param message TUP_UINT8
 *@param messageLength unsigned long
 *@return xmlMsgString
 */
- (NSString *)getContentStringFromUserInfo:(TUP_UINT8 *)message withMessageLength:(unsigned long)messageLength {
    TUP_UINT8* xmlMsg = (TUP_UINT8*)malloc((sizeof(TUP_UINT8)*messageLength + 1));
    if (NULL == xmlMsg) {
        return nil;
    }
    
    memset(xmlMsg, 0, messageLength);
    memcpy(xmlMsg, message, messageLength);
    
    
    size_t msgLength = strlen((char *)xmlMsg);
    if (0 >= msgLength || 256 <= msgLength) {
        free(xmlMsg);
        return nil;
    }
    NSString *xmlMsgString = [NSString stringWithUTF8String:(const char *)xmlMsg];
    free(xmlMsg);
    return xmlMsgString;
}

/**
 * This method is used to deal phone user enter a meeting
 * 电话用户接入处理
 *@param data void*
 */
- (void)handlePhoneUserEnterConfWith:(void*)data
{
    TC_Conf_Phone_Record *pPhoneUserInfo = (TC_Conf_Phone_Record *)data;
    if (0x01 != (pPhoneUserInfo->m_video_dev_capable & 0x01)) {//ip话机入会，为1；其他情况不处理
        DDLogInfo(@"NO IPPHONE ENTER! ignore~~!");
        return;
    }
    
    TUP_UINT32 userid = pPhoneUserInfo->m_record_id;
    NSString* userNum = [NSString stringWithUTF8String:pPhoneUserInfo->m_uri];
    NSString* userName = [NSString stringWithUTF8String:pPhoneUserInfo->m_phone_user_name];
    
    DDLogInfo(@"Phone user enter conf with userID: %@, userNum: %@, userName: %@", userid, userNum, userName);
    
    [self dealDataConfUserEnterEventWithNumber:userNum userName:userName userId:userid];
}

/**
 * This method is used to deal user enter a meeting
 * 用户入会处理
 *@param userNumber NSString
 *@param userName NSString
 *@param userid TUP_UINT32
 */
- (void)dealDataConfUserEnterEventWithNumber:(NSString *)userNumber
                                    userName:(NSString *)userName
                                      userId:(TUP_UINT32)userid {
    
    LoginAuthorizeInfo *mine = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    if (![userName isEqualToString:mine.loginAccount])
    {
        if (userid != 0)
        {
            _selfUserId = userid;
        }
    }
    
    [_memberArray addObject:[NSNumber numberWithInt:userid]];
    
    NSMutableArray *joinedAttenees = [ManagerService confService].haveJoinAttendeeArray;
    BOOL isInConf = NO;
    
    // 遍历已在语音会议中成员，如果该用户在语音会议中，更改其加入数据会议状态为已入数据会议状态
    for (VCConfUpdateInfo *attendee in joinedAttenees) {
        if ([attendee.aucName isEqualToString:userName]) {
            attendee.userID = [NSString stringWithFormat:@"%d", userid];
            attendee.dataState = DataConfAttendeeMediaStateIn;
            isInConf = YES;
        }
    }
    if (!isInConf) {
        VCConfUpdateInfo *updateInfo = [[VCConfUpdateInfo alloc]init];
        updateInfo.aucName = userName;
        updateInfo.aucNumber = userNumber;
        updateInfo.userID = [NSString stringWithFormat:@"%d", userid];
        updateInfo.dataState = DataConfAttendeeMediaStateIn;
        [[ManagerService confService].haveJoinAttendeeArray addObject:updateInfo];
    }
    
    NSDictionary *notifyInfo = @{DATACONF_USER_ENTER_KEY:userName};
    [self respondsDataConferenceDelegateWithType:DATACONF_USER_ENTER result:notifyInfo];
}

/**
 * This method is used to deal user leave a meeting
 * 用户离会处理
 *@param data void *
 */
- (void)handleUserLeaveConfWithData:(void *)data
{
    TC_Conf_User_Record *leaveUserInfo = (TC_Conf_User_Record *)data;
    TUP_UINT32 leaveUserid = leaveUserInfo->user_alt_id;
    NSString *userName = [NSString stringWithUTF8String:leaveUserInfo->user_name];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_memberArray];
    for (NSNumber *userId in tempArray)
    {
        if ([userId intValue] == leaveUserid)
        {
            [_memberArray removeObject:userId];
        }
    }
    NSString *attendeeUserID = [NSString stringWithFormat:@"%u",leaveUserid];
    NSMutableArray *joinedAttenees = [ManagerService confService].haveJoinAttendeeArray;
    // 遍历已在语音会议中成员，如果该用户在语音会议中，更改其加入数据会议状态为离开数据会议状态
    for (VCConfUpdateInfo *attendee in joinedAttenees) {
        if ([attendee.userID isEqualToString:attendeeUserID]) {
            attendee.dataState = DataConfAttendeeMediaStateLeave;
        }
    }
    DDLogInfo(@"user leave conf: userName: %@, user_alt_id: %d",userName,leaveUserid);
    NSDictionary *notifyInfo = @{
                                 DATACONF_USER_LEAVE_KEY:userName
                                 };
    [self respondsDataConferenceDelegateWithType:DATACONF_USER_LEAVE result:notifyInfo];
}

#pragma mark - Public Method
/**
 * This method is used to end conference.
 * 结束数据会议
 *@return BOOL
 */
- (BOOL)closeDataConference
{
    self.currentCameraInfo = nil;
    int result = TC_FAILURE ;
    result =  tup_conf_terminate(self.dataConfHandle);
    DDLogInfo(@"Data_Log: tup_conf_terminate = %i",result);
    if (TC_OK == result) {
        // 结束数据会议成功，则50毫秒后释放数据会议资源
        [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.05];
    }
    return result==TC_OK ? YES : NO;
}

/**
 * This method is used to kick out a user.
 * 踢出与会者
 *@param userId int
 *@return BOOL
 */
-(BOOL)kickoutUser:(int)userId
{
    int result = TC_FAILURE;
    result = tup_conf_user_kickout(self.dataConfHandle, (TUP_UINT32)userId);
    DDLogInfo(@"Data_Log: tup_conf_user_kickout = %i, userid: %d",result,userId);
    return result==TC_OK ? YES : NO;
}

/**
 * This method is used to config data conference localView and remoteView.
 * 配置本地窗口和远端窗口
 *@param localView view
 *@param remoteView view
 *@return BOOL
 */
-(BOOL)configDataConfLocalView:(id)localView remoteView:(id)remoteView
{
    if (localView == nil || remoteView == nil)
    {
        return NO;
    }
    DDLogInfo(@"config DataConf LocalView and remoteView");
    self.localDataConfCameraView = localView;
    self.remoteDataConfCameraView = remoteView;
    self.localCamreaInfo.videoView = localView;
    self.remoteCamreaInfo.videoView = remoteView;
    return YES;
}

/**
 * This method is used to leave data conference.
 * 离开数据会议
 *@return BOOL
 */
-(BOOL)leaveDataConference
{
    _isDataBFCPShow = NO;
    self.currentCameraInfo = nil;
    int result = tup_conf_leave(_dataConfHandle);
    DDLogInfo(@"data conference tup_conf_leave %d",result);
    BOOL ret = result == TC_OK ? YES : NO;
    if (ret)
    {
        // 离开数据成功后，50毫米后释放数据会议资源
        [self performSelector:@selector(stopDataConference) withObject:nil afterDelay:0.05];
    }
    NSDictionary *resultInfo = @{
                                 UCCONF_RESULT_KEY :[NSNumber numberWithBool:ret]
                                 };
    [self respondsDataConferenceDelegateWithType:DATA_CONFERENCE_LEAVE result:resultInfo];
    return result==TC_OK ? YES : NO;
}

/**
 * This method is used to set video capture rotate.
 * 设置视频旋转的角度
 *@param rotation NSInteger
 *@return BOOL
 */
-(BOOL)configCaptureRotaion:(NSInteger)rotation
{
    int result = tup_conf_video_set_capture_rotate(_dataConfHandle, self.localCamreaInfo.deviceId, rotation);
    DDLogInfo(@"tup_conf_video_set_capture_rotate result : %d",result);
    return result == TC_OK ? YES : NO;
}

/**
 * This method is used to send message to all user
 * 发送信息给所有人
 *@param message message
 *@return YES is success, No is fail
 */
-(BOOL)sendIMMessageToAll:(NSString *)message
{
    TUP_CHAR *msgChar = (TUP_CHAR *)[message UTF8String];
    int result = tup_conf_chat_sendmsg(_dataConfHandle, CHAT_TYPE_PUBLIC,0,msgChar, strlen(msgChar)+1);
    DDLogInfo(@"tup_conf_chat_sendmsg result : %d,msgChar is:%s ",result,msgChar);
    return result == TC_OK ? YES : NO;
}

/**
 * This method is used to set other user role (chairman)
 * 主席设置与会者角色
 *@param userId userId
 *@param userRole DATACONF_USER_ROLE_TYPE value
 *@return YES or NO
 */
-(BOOL)setRoleToUser:(unsigned int)userId role:(DATACONF_USER_ROLE_TYPE)userRole;
{
//    BOOL isExit = NO;
//    for (NSNumber *usersId in _memberArray)
//    {
//        if ([usersId intValue] == userId)
//        {
//            isExit = YES;
//        }
//    }
//    if (!isExit)
//    {
//        return NO;
//    }
    int result = tup_conf_user_set_role(_dataConfHandle,userId, userRole);
    DDLogInfo(@"tup_conf_user_set_role result : %d,role is:%x",result,userRole);
    return result == TC_OK ? YES : NO;
}

/**
 * This method is used to set data conference handle.
 * 数据会议handle的set方法
 *@param dataConfHandle CONF_HANDLE
 */
-(void)setDataConfHandle:(CONF_HANDLE)dataConfHandle
{
    _dataConfHandle = dataConfHandle;
}

#pragma mark -
/**
 * This method is used to deel data conference event callback from service to UI
 * 分发数据会议业务相关回调到界面
 *@param type TUP_CONTACT_EVENT_TYPE
 *@param resultDictionary NSDictionary
 */
-(void)respondsDataConferenceDelegateWithType:(TUP_DATA_CONFERENCE_EVENT_TYPE)type result:(NSDictionary *)resultInfo
{
    NSDictionary *tempResultsInfo = [[NSDictionary alloc] init];
    if (resultInfo == nil)
    {
        tempResultsInfo = @{
                            TUP_DATACONF_CALLBACK_TYPE_KEY : [NSNumber numberWithInt:type]
                            };
    }
    else
    {
        tempResultsInfo = @{
                            TUP_DATACONF_CALLBACK_TYPE_KEY : [NSNumber numberWithInt:type],
                            TUP_DATACONF_CALLBACK_RESULT_KEY : resultInfo
                            };
    }
    if ([self.delegate respondsToSelector:@selector(dataConferenceEventCallback:result:)])
    {
        [self.delegate dataConferenceEventCallback:type result:tempResultsInfo];
    }
}


/**
 * This method is used to release resource.
 * 释放界面消失时的相关资源
 */
-(void)dealloc
{
    [self stopHeartBeat];
    SetDataConfCallbackHandler(nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * This method is used to deal some preparatory work after the component is loaded.
 * 各个组件加载完成后的处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pData void*
 *@param nSize int
 */
-(void)handleComponetLoadWithValue:(int)nValue1 value2:(long)nValue2 data:(void*)pData dataLength:(int)nSize
{
    DDLogInfo(@"handleComponetLoadWithValue %d,%ld",nValue1,nValue2);
    CalcDpi();
    NSInteger componentID = nValue2;
    switch (componentID)
    {
            // 视频组件
        case IID_COMPONENT_VIDEO:
        {
            DDLogInfo(@"IID_COMPONENT_VIDEO _dataConfHandle :%d",_dataConfHandle);
            TUP_UINT32 videoDevCount = 0;
            tup_conf_video_get_deviceinfo(_dataConfHandle,NULL,&videoDevCount);
            if(videoDevCount >0)
            {
                TC_DEVICE_INFO* pDeviceInfo  = new TC_DEVICE_INFO[videoDevCount];
                tup_conf_video_get_deviceinfo(self.dataConfHandle, pDeviceInfo, &videoDevCount);
                [self storeCameraInfo:pDeviceInfo withLen:videoDevCount];
                DDLogInfo(@"pDeviceInfo:%d,%d",pDeviceInfo[0]._DeviceID,pDeviceInfo[1]._DeviceID);
                delete [] pDeviceInfo;
            }
            //[self openLocalCamera];
            break;
        }
            // 白板组件
        case IID_COMPONENT_WB:
        {
            DDLogInfo(@"IID_COMPONENT_WB");
            float scale = 1;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                scale = [[UIScreen mainScreen] scale];
            }
            NSInteger deviceDPI;
            NSString* deviceType = [UIDevice currentDevice].model;
            if ([deviceType hasPrefix:@"iPad"]) {
                scale = 132 * scale;
            }else if ([deviceType hasPrefix:@"iPhone"]) {
                scale = 163;
            }else if ([deviceType hasPrefix:@"iPod touch"]) {
                scale = 163;
            }else {
                scale = 160 * scale;
            }
            deviceDPI = scale;
            
            TC_SIZE disp = {static_cast<TUP_INT>(1680 * 1440.0/deviceDPI), static_cast<TUP_INT>(1050 * 1440.0/deviceDPI)};
            int result = tup_conf_ds_set_canvas_size(_dataConfHandle, IID_COMPONENT_WB, disp, true);
            DDLogInfo(@"tup_conf_ds_set_canvas_size result: %d",result);
            break;
        }
            // 文档共享组件
        case IID_COMPONENT_DS:
        {
            DDLogInfo(@"IID_COMPONENT_DS");
            [self OnComReady];
            //            TC_SIZE disp = {static_cast<TUP_INT>([UIScreen mainScreen].bounds.size.width *20),static_cast<TUP_INT>([UIScreen mainScreen].bounds.size.height *20)};
            //            int result = tup_conf_ds_set_canvas_size(_dataConfHandle, IID_COMPONENT_DS, disp, true);
            //            DDLogInfo(@"tup_conf_ds_set_canvas_size result: %d",result);
            break;
        }
            
        default:
            break;
    }
    
}

/**
 * This method is used to deal screen.
 * 屏幕相关处理
 */
void CalcDpi(void)
{
    float scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        scale = [[UIScreen mainScreen] scale];
    }
    
    NSString* deviceType = [UIDevice currentDevice].model;
    if ([deviceType hasPrefix:@"iPad"])
    {
        s_device_dpi = 132 * scale;
    }
    else if ([deviceType hasPrefix:@"iPhone"])
    {
        s_device_dpi = 163;
    }
    else if ([deviceType hasPrefix:@"iPod touch"])
    {
        s_device_dpi = 163;
    }
    else
    {
        s_device_dpi = 160 * scale;
    }
}

/**
 * This method is used to do some preparatory work after the document sharing is loaded.
 * 文档共享模块加载完成后的准备工作
 */
- (void) OnComReady
{
    DsDefineAnnot types[] = {{ANNOTCUSTOMER_PICTURE, DS_ANNOT_FLAG_CANBESELECTED | DS_ANNOT_FLAG_CANBEMOVED},
        {ANNOTCUSTOMER_MARK, DS_ANNOT_FLAG_CANBESELECTED | DS_ANNOT_FLAG_CANBEMOVED | DS_ANNOT_FLAG_FIXEDSIZE},
        {ANNOTCUSTOMER_POINTER, DS_ANNOT_FLAG_EXCLUSIVEPERUSER | DS_ANNOT_FLAG_FIXEDSIZE}};
    tup_conf_annotation_reg_customer_type(_dataConfHandle, IID_COMPONENT_AS, (DsDefineAnnot*)types, CUSTOMER_ANNOT_COUNT);
    
    TC_SIZE disp = {static_cast<TUP_INT>(1680*1440.0/s_device_dpi),static_cast<TUP_INT>(1050*1440.0/s_device_dpi)};
    
    TUP_RESULT ret = TC_OK;
    tup_conf_ds_set_canvas_size(_dataConfHandle, IID_COMPONENT_DS, disp, 1);
    if(ret == TC_OK)
    {
        DsDefineAnnot types[] = {{ANNOTCUSTOMER_PICTURE, DS_ANNOT_FLAG_CANBESELECTED | DS_ANNOT_FLAG_CANBEMOVED},
            {ANNOTCUSTOMER_MARK, DS_ANNOT_FLAG_CANBESELECTED | DS_ANNOT_FLAG_CANBEMOVED | DS_ANNOT_FLAG_FIXEDSIZE},
            {ANNOTCUSTOMER_POINTER, DS_ANNOT_FLAG_EXCLUSIVEPERUSER | DS_ANNOT_FLAG_FIXEDSIZE}};
        tup_conf_annotation_reg_customer_type(_dataConfHandle, IID_COMPONENT_DS, (DsDefineAnnot*)types, CUSTOMER_ANNOT_COUNT);
        
        Anno_Resource_Item items[LOCALRES_COUNT];
        memset(items, 0, sizeof(items));
        
        //	FILE* fp = NULL;
        items[LOCALRES_CHECK].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_CHECK].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_CHECK].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_CHECK].ptOffset.x = 210;//14 * s_dpi;
        items[LOCALRES_CHECK].ptOffset.y = 210;//14 * s_dpi;
        items[LOCALRES_CHECK].resIndex = LOCALRES_CHECK;
        //fp = fopen("check.png", "rb");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"check" ofType:@"png"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_CHECK].dataLen = [data length];
            items[LOCALRES_CHECK].pData = new char[items[LOCALRES_CHECK].dataLen];
            memcpy(items[LOCALRES_CHECK].pData, [data bytes], items[LOCALRES_CHECK].dataLen);
        }
        else
        {
            DDLogInfo(@"read check.png error.");
        }
        
        items[LOCALRES_XCHECK].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_XCHECK].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_XCHECK].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_XCHECK].ptOffset.x = 210;//14 * s_dpi;
        items[LOCALRES_XCHECK].ptOffset.y = 210;//14 * s_dpi;
        items[LOCALRES_XCHECK].resIndex = LOCALRES_XCHECK;
        //fp = fopen("xcheck.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"xcheck" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_XCHECK].dataLen = [data length];
            items[LOCALRES_XCHECK].pData = new char[items[LOCALRES_XCHECK].dataLen];
            memcpy(items[LOCALRES_XCHECK].pData, [data bytes], items[LOCALRES_XCHECK].dataLen);
        }
        else
        {
            DDLogInfo(@"read xcheck.png error.");
        }
        
        items[LOCALRES_LEFTPOINTER].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_LEFTPOINTER].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_LEFTPOINTER].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_LEFTPOINTER].ptOffset.x = 0;
        items[LOCALRES_LEFTPOINTER].ptOffset.y = 210;//14 * s_dpi;
        items[LOCALRES_LEFTPOINTER].resIndex = LOCALRES_LEFTPOINTER;
        //	fp = fopen("lpointer.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"lpointer" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_LEFTPOINTER].dataLen = [data length];
            items[LOCALRES_LEFTPOINTER].pData = new char[items[LOCALRES_LEFTPOINTER].dataLen];
            memcpy(items[LOCALRES_LEFTPOINTER].pData, [data bytes], items[LOCALRES_LEFTPOINTER].dataLen);
        }
        else
        {
            DDLogInfo(@"read lpointer.png error.");
        }
        
        items[LOCALRES_RIGHTPOINTER].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_RIGHTPOINTER].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_RIGHTPOINTER].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_RIGHTPOINTER].ptOffset.x = 420;//28 * s_dpi;
        items[LOCALRES_RIGHTPOINTER].ptOffset.y = 210;//14 * s_dpi;
        items[LOCALRES_RIGHTPOINTER].resIndex = LOCALRES_RIGHTPOINTER;
        //	fp = fopen("rpointer.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"rpointer" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_RIGHTPOINTER].dataLen = [data length];
            items[LOCALRES_RIGHTPOINTER].pData = new char[items[LOCALRES_RIGHTPOINTER].dataLen];
            memcpy(items[LOCALRES_RIGHTPOINTER].pData, [data bytes], items[LOCALRES_RIGHTPOINTER].dataLen);
        }
        else
        {
            DDLogInfo(@"read rpointer.png error.");
        }
        
        items[LOCALRES_UPPOINTER].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_UPPOINTER].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_UPPOINTER].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_UPPOINTER].ptOffset.x = 210;//14 * s_dpi;
        items[LOCALRES_UPPOINTER].ptOffset.y = 0;
        items[LOCALRES_UPPOINTER].resIndex = LOCALRES_UPPOINTER;
        //	fp = fopen("upointer.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"upointer" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_UPPOINTER].dataLen = [data length];
            items[LOCALRES_UPPOINTER].pData = new char[items[LOCALRES_UPPOINTER].dataLen];
            memcpy(items[LOCALRES_UPPOINTER].pData, [data bytes], items[LOCALRES_UPPOINTER].dataLen);
        }
        else
        {
            DDLogInfo(@"read upointer.png error.");
        }
        
        items[LOCALRES_DOWNPOINTER].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_DOWNPOINTER].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_DOWNPOINTER].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_DOWNPOINTER].ptOffset.x = 210;//14 * s_dpi;
        items[LOCALRES_DOWNPOINTER].ptOffset.y = 420;//28 * s_dpi;
        items[LOCALRES_DOWNPOINTER].resIndex = LOCALRES_DOWNPOINTER;
        //fp = fopen("dpointer.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"dpointer" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_DOWNPOINTER].dataLen = [data length];
            items[LOCALRES_DOWNPOINTER].pData = new char[items[LOCALRES_DOWNPOINTER].dataLen];
            memcpy(items[LOCALRES_DOWNPOINTER].pData, [data bytes], items[LOCALRES_DOWNPOINTER].dataLen);
        }
        else
        {
            DDLogInfo(@"read dpointer.png error.");
        }
        
        items[LOCALRES_LASERPOINTER].format = DS_PIC_FORMAT_PNG;
        items[LOCALRES_LASERPOINTER].picWidth = 420;//28 * s_dpi;
        items[LOCALRES_LASERPOINTER].picHeight = 420;//28 * s_dpi;
        items[LOCALRES_LASERPOINTER].ptOffset.x = 210;//14 * s_dpi;
        items[LOCALRES_LASERPOINTER].ptOffset.y = 210;//14 * s_dpi;
        items[LOCALRES_LASERPOINTER].resIndex = LOCALRES_LASERPOINTER;
        //	fp = fopen("lp.png", "rb");
        path = [[NSBundle mainBundle] pathForResource:@"lp" ofType:@"png"];
        data = [NSData dataWithContentsOfFile:path];
        if(data != nil)
        {
            items[LOCALRES_LASERPOINTER].dataLen = [data length];
            items[LOCALRES_LASERPOINTER].pData = new char[items[LOCALRES_LASERPOINTER].dataLen];
            memcpy(items[LOCALRES_LASERPOINTER].pData, [data bytes], items[LOCALRES_LASERPOINTER].dataLen);
        }
        else
        {
            DDLogInfo(@"read lp.png error.");
        }
        
        tup_conf_annotation_init_resource(_dataConfHandle, IID_COMPONENT_DS, items, LOCALRES_COUNT);
        
        for(int i = 0; i < LOCALRES_COUNT; i++)
        {
            char* pBmpData = (char*)items[i].pData;
            if(pBmpData)
            {
                delete[] pBmpData;
            }
        }
    }
}


/**
 * This method is used to store camerInfo.
 * 存储摄像头相关信息
 *@param cameraArrayPointer TC_DEVICE_INFO
 *@param len size_t
 */
-(void)storeCameraInfo:(TC_DEVICE_INFO*)cameraArrayPointer withLen:(size_t)len
{
    [self.localCameraInfos removeAllObjects];
    for (int i = 0;i<len; i++)
    {
        ConfCameraInfo *cameraInfo = [[ConfCameraInfo alloc] init];
        cameraInfo.userId = cameraArrayPointer[i]._UserID;
        cameraInfo.deviceId = cameraArrayPointer[i]._DeviceID;
        cameraInfo.cameraName = [NSString stringWithUTF8String:cameraArrayPointer[i]._szName];
        cameraInfo.videoView = _localDataConfCameraView;
        DDLogInfo(@"get new camrea : _UserID %d, _DeviceID %d",cameraArrayPointer[i]._UserID,cameraArrayPointer[i]._DeviceID);
        [self.localCameraInfos addObject:cameraInfo];
        DDLogInfo(@"get new cameraInfo:%@",[cameraInfo description]);
    }
}

/**
 * This method is used to get the current information on server
 * 获取服务器上的当前信息
 *@return BOOL
 */
-(BOOL)getServiceCurrentData
{
    DsSyncInfo info;
    TUP_RESULT iRetService = tup_conf_ds_get_syncinfo(_dataConfHandle,IID_COMPONENT_WB,&info);
    DDLogInfo(@"iRetService:%d",iRetService);
    if (iRetService == TC_OK)
    {
        // 设置当前显示的页面
        TUP_RESULT iRetWB = tup_conf_ds_set_current_page(_dataConfHandle, IID_COMPONENT_WB, info.docId, info.pageId, 0);
        DDLogInfo(@"getServiceCurrentData iRetWB:%d info.docId:%d--%d",iRetWB,info.docId,info.pageId);
        if (iRetWB != TC_OK)
        {
            return NO;
        }
    }
    return iRetService == TC_OK ? YES:NO;
}

/**
 * This method is used to deal updating the user  interface
 * 文档数据界面更新通知处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pdata void*
 *@param nSize int
 */
-(void)getSuraceBmpWithComponet:(COMPONENT_IID)component value1:(int)nValue1 value2:(long)nValue2 data:(void*)pdata
{
    int width = 0;
    int height = 0;
    void* pData = NULL;
    pData = tup_conf_ds_get_surfacebmp(_dataConfHandle, component, (TUP_UINT32*)&width, (TUP_UINT32*)&height);
    if (pData != NULL)
    {
        int realLen = *((int*)((char*)pData + 2));
        //NSData* data = [NSData dataWithBytesNoCopy:pData length:realLen freeWhenDone:NO];
        NSData *data = [NSData dataWithBytes:(void*)pData length:realLen];
        UIImage* image = [[UIImage alloc] initWithData:data];
        if (!image)
        {
            DDLogInfo(@"obtain image error");
            return;
        }
        NSDictionary *shareDataInfo = @{
                                        DATACONF_SHARE_DATA_KEY:image
                                        };
        [self respondsDataConferenceDelegateWithType:DATACONF_RECEIVE_SHARE_DATA result:shareDataInfo];
        return;
    }
    DDLogInfo(@"pData is empty");
}

/**
 * This method is used to notify synchronously turning pages
 * 同步翻页预先通知处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pdata void*
 *@param nSize int
 */
- (void)handleConfSharedDocPageChangedWithValue:(int)nValue1 value2:(long)nValue2 data:(void*)pdata dataLength:(int)nSize
{
    // get current page size
    TUP_UINT32 pageId = nValue2;
    if (0 == nValue2)
    {
        DDLogInfo(@"<INFO>:COMPT_MSG_DS_ON_CURRENT_PAGE_IND:DS_CHANGE");
        DsDocInfo sizeZoom;
        int errOut = tup_conf_ds_get_docinfo(_dataConfHandle, IID_COMPONENT_DS, nValue1, &sizeZoom);
        if (TC_OK != errOut)
        {
            DDLogInfo(@"<ERROR>conf_ds_get_docinfo error:%d",errOut);
            return;
        }
        DDLogInfo(@"<INFO>conf_ds_get_docinfo pageId:%d",sizeZoom.currentPage);
        pageId = sizeZoom.currentPage;
    }
    DsPageInfo pageinfo;
    int err = tup_conf_ds_get_pageinfo(_dataConfHandle, IID_COMPONENT_DS, nValue1, pageId, &pageinfo);
    DDLogInfo(@"<inf0>: COMPT_MSG_DS_ON_CURRENT_PAGE: get page info docId=%d, pageId=%ld, pageWidth=%d, pageHieght=%d, pageScale=%d!",
           nValue1, nValue2, pageinfo.width, pageinfo.height, pageinfo.zoomPercent);
    if (TC_OK != err)
    {
        DDLogInfo(@"<ERROR>: COMPT_MSG_DS_ON_CURRENT_PAGE: get page info fialed!");
    }
    else
    {
        TC_SIZE disp = {pageinfo.width, pageinfo.height};
        err = tup_conf_ds_set_canvas_size(_dataConfHandle, IID_COMPONENT_DS, disp,0);
        DDLogInfo(@"<INFO>: tup_conf_ds_set_canvas_size:%d", err);
        err = tup_conf_ds_set_current_page(_dataConfHandle, IID_COMPONENT_DS, nValue1, nValue2, 0);
        DDLogInfo(@"<INFO>: tup_conf_ds_set_current_page:%d", err);
    }
}

/**
 * This method is used to create a new document
 * 新建一个文档
 *@param component COMPONENT_IID
 *@param nValue1 int
 *@param nValue2 long
 *@param sync TUP_BOOL
 *@return BOOL
 */
-(BOOL)confSetCurrentPage:(COMPONENT_IID)component value1:(int)nValue1 value2:(long)nValue2 sync:(TUP_BOOL)sync
{
    int result = tup_conf_ds_set_current_page(_dataConfHandle, component, nValue1, nValue2,sync);
    DDLogInfo(@"tup_conf_ds_set_current_page :%d, component is :%d",result,component);
    if (result != TC_OK)
    {
        DDLogInfo(@"tup_conf_ds_set_current_page error:%d",result);
    }
    return result == TC_OK ? YES : NO;
}

/**
 * This method is used to deal screen share state.
 * 屏幕共享状态处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pData void*
 *@param nSize int
 */
-(void)handleScreenShareState:(int)nValue1 value2:(long)nValue2 data:(void*)pData dataLength:(int)nSize
{
    switch (nValue2)
    {
        case AS_STATE_NULL:
        {
            DDLogInfo(@"screen share stop");
            [self respondsDataConferenceDelegateWithType:DATACONF_SHARE_STOP result:nil];
        }
            break;
        case AS_STATE_START:
        {
            DDLogInfo(@"screen share start");
        }
            break;
        default:
            break;
    }
}

/**
 * This method is used to update screen data.
 * 更新屏幕共享数据
 *@param nValue1 int
 *@param nValue2 long
 *@param pData void*
 *@param nSize int
 */
-(void)handleScreenShare:(int)nValue1 value2:(long)nValue2 data:(void*)pData dataLength:(int)nSize
{
    TC_AS_SCREENDATA screenData;
    memset((void *)(&screenData), 0, sizeof(screenData));
    // 获取数据
    TUP_RESULT dataRet = tup_conf_as_get_screendata(_dataConfHandle, &screenData);
    if (dataRet != TC_OK)
    {
        DDLogInfo(@"tup_conf_as_get_screendata failed:%d",dataRet);
        return;
    }
    DDLogInfo(@"tup_conf_as_get_screend+ata :%d",dataRet);
    char *data = (char *)screenData.pData;
    TUP_UINT32 ssize = *((TUP_UINT32 *)((char *)data + sizeof(TUP_UINT16)));
    NSData *imageData = [NSData dataWithBytes:data length:ssize];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    if (image == nil)
    {
        DDLogInfo(@"share image from data fail!");
        return;
    }
    NSDictionary *shareDataInfo = @{
                                    DATACONF_SHARE_DATA_KEY:image
                                    };
    [self respondsDataConferenceDelegateWithType:DATACONF_RECEIVE_SHARE_DATA result:shareDataInfo];
}

/**
 * This method is used to deal chat message.
 * 聊天消息处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pData void*
 *@param nSize int
 */
-(void)handleChatMSG:(int)nValue1 value2:(long)nValue2 data:(void*)pData dataLength:(int)nSize
{
    if (nValue2 != TC_OK)
    {
        DDLogInfo(@"Send msg fail or revice msg fail!");
        return;
    }
    TC_CHAT_MSG *chatMsg = (TC_CHAT_MSG *)pData;
    TUP_CHAR charMsgC[chatMsg->nMsgLen+1];
    memset(charMsgC, 0, chatMsg->nMsgLen+1);
    memcpy(charMsgC, chatMsg->lpMsg, chatMsg->nMsgLen);
    DDLogInfo(@"charMsgC: %s",charMsgC);
    NSString *msgStr = [NSString stringWithUTF8String:charMsgC];
    
    DDLogInfo(@"msgStr :%@,chatMsg->lpMsg :%s, chatMsg->fromUserName :%s，chatMsg->nMsgLen:%d",msgStr,chatMsg->lpMsg,chatMsg->fromUserName,chatMsg->nMsgLen);
    ChatMsg *tupMsg = [[ChatMsg alloc] init];
    tupMsg.nMsgLen = chatMsg->nMsgLen;
    tupMsg.nFromUserid = chatMsg->nFromUserid;
    tupMsg.nSequenceNmuber = chatMsg->nSequenceNmuber;
    tupMsg.nFromGroupID = chatMsg->nFromGroupID;
    tupMsg.time = chatMsg->time;
    tupMsg.lpMsg = msgStr;
    tupMsg.fromUserName = [NSString stringWithUTF8String:chatMsg->fromUserName];;
    if ([self.chatDelegate respondsToSelector:@selector(didReceiveChatMessage:)]) {
        [self.chatDelegate didReceiveChatMessage:tupMsg];
    }    
}

/**
 * This method is used to deal video switch.
 * 视频开关状态处理
 *@param nValue1 int
 *@param nValue2 long
 *@param pData void*
 *@param nSize int
 */
-(void)handleVideoSwitchWithValue:(int)nValue1 value2:(long)nValue2 data:(void*)pData dataLength:(int)nSize
{
    TUP_UINT32 ulUserId = nValue2;
    TUP_UINT32 deviceID = *((TUP_UINT32 *)pData);
    ConfCameraInfo *selfcameraInfo ;
    if (self.localCameraInfos.count > 0)
    {
        selfcameraInfo = self.localCameraInfos[self.cameraCaptureIndex];
    }
    [self changeConfCameraInfo:ulUserId deviceId:deviceID open:nValue1 == VIDEO_OPEN ? YES : NO];
    NSInteger rotation = 0;
    if (nValue1 == VIDEO_OPEN) {
        if (ulUserId == selfcameraInfo.userId)
        {
            // 如果当前摄像头是后置摄像头，则画面需旋转180度
            if (_cameraCaptureIndex == CameraIndexBack) {
                rotation = 180;
            }
            [self attachVideoView:_localCamreaInfo];
        }
    }
    BOOL isPostUserId = NO;
    if(nValue1 == VIDEO_CLOSE)
    {
        if (ulUserId == selfcameraInfo.userId)
        {
            [self detachVideoView:_localCamreaInfo];
        }
        else
        {
            [self detachVideoView:_remoteCamreaInfo];
            isPostUserId = YES;
        }
    }
    // iPhone and iPod
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self configCaptureRotaion:rotation];
    }
    NSDictionary *resultInfo = @{
                       DATACONF_VIDEO_ON_SWITCH_KEY:[NSNumber numberWithBool:nValue1],
                       DATACONF_VIDEO_ON_SWITCH_USERID_KEY: [NSNumber numberWithInt:ulUserId]
                       };

    [self respondsDataConferenceDelegateWithType:DATACONF_VEDIO_ON_SWITCH result:resultInfo];
    if (nValue1 == VIDEO_CLOSE && ulUserId == self.currentCameraInfo.userId) {
        self.currentCameraInfo = nil;
    }
}

/**
 * This is used to updating current cameraIndo;
 * 更新当前摄像头信息
 *@param userId TUP_UINT32
 *@param deviceId TUP_UINT32
 *@param open BOOL
 */
-(void)changeConfCameraInfo:(TUP_UINT32)userId deviceId:(TUP_UINT32)deviceId open:(BOOL)open
{
    ConfCameraInfo *selfcameraInfo ;
    if (self.localCameraInfos.count > 0)
    {
        selfcameraInfo = self.localCameraInfos[self.cameraCaptureIndex];
    }
    // 如果需要更新的摄像头信息和当前摄像头信息一致，则不用更新，否则更新当前摄像头信息
    if (userId == selfcameraInfo.userId)
    {
        _localCamreaInfo = selfcameraInfo;
        DDLogInfo(@"local camrea userid: %d, deviceid: %d",_localCamreaInfo.userId,_localCamreaInfo.deviceId);
    }
    else
    {
        DDLogInfo(@"the other person in conf open camera");
        // 用户视频与窗口进行解绑
        [self detachVideoView:_remoteCamreaInfo];
        ConfCameraInfo *remoteCameraInfo = [[ConfCameraInfo alloc] init];
        remoteCameraInfo.userId = userId;
        remoteCameraInfo.deviceId = deviceId;
        remoteCameraInfo.cameraName = [NSString stringWithFormat:@"%d's camera",userId];
        remoteCameraInfo.videoView = self.remoteDataConfCameraView;
        _remoteCamreaInfo = remoteCameraInfo;
        
        // 用户视频鱼窗口重新绑定
        // [self attachVideoView:remoteCameraInfo];
        
        // 更新ConfCameraInfo
        [self matchConfMemberWithCameraInfo:remoteCameraInfo open:open];
        DDLogInfo(@"remote camrea userid: %d, deviceid: %d",_remoteCamreaInfo.userId,_remoteCamreaInfo.deviceId);
    }
}

/**
 * This method is used to update ConfCameraInfo.
 * 更新ConfCameraInfo
 *@param cameraInfo ConfCameraInfo
 *@param open BOOL
 */
-(void)matchConfMemberWithCameraInfo:(ConfCameraInfo *)cameraInfo  open:(BOOL)open {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_remoteCameraInfos];
    if (tempArray.count == 0) {
        [_remoteCameraInfos addObject:cameraInfo];
    }
    else {
        for (ConfCameraInfo *tempCamreaInfo in tempArray) {
            if (cameraInfo.userId != tempCamreaInfo.userId && open) {
                [_remoteCameraInfos addObject:cameraInfo];
            }
            // 如果视频关闭，则移除changeConfCameraInfo
            if (cameraInfo.userId == tempCamreaInfo.userId && !open) {
                [_remoteCameraInfos removeObject:tempCamreaInfo];
            }
        }
    }
    DDLogInfo(@"match result :%@",_remoteCameraInfos);
    
    NSDictionary *resultInfo = @{DATACONF_REMOTE_CAMERA_KEY:_remoteCameraInfos};
    [self respondsDataConferenceDelegateWithType:DATACONF_REMOTE_CAMETAINFO result:resultInfo];
}

/**
 * This method is used to detach video view
 * 端口视频流传输
 *@param cameraInfo ConfCameraInfo value
 *@return YES is success, No is fail
 */
- (BOOL)detachVideoView:(ConfCameraInfo*)cameraInfo {
    DDLogInfo(@"cameraInfo----- :%@ ",cameraInfo);
    // 暂停自己或别人的视频
    int result = tup_conf_video_pause(self.dataConfHandle,cameraInfo.userId, cameraInfo.deviceId, false);
    DDLogInfo(@"<INFO>: video pause before detach: iRet = %d", result);
    int iRet = TC_FAILURE;
    //  用户视频与窗口进行解绑
    iRet = tup_conf_video_detach(_dataConfHandle, cameraInfo.userId, cameraInfo.deviceId, (__bridge void *)cameraInfo.videoView, true);
    DDLogInfo(@"<INFO>: detachVideoView: conf_video_detach=%d", iRet);
    if (cameraInfo.userId == _localCamreaInfo.userId) {
        _localCamreaInfo = cameraInfo;
    }else {
        _remoteCamreaInfo = cameraInfo;
    }
    return (iRet == TC_OK);
}

/**
 * This method is used to attach appointed user's video and window.
 * 用户的视频与窗口进行绑定
 *@param cameraInfo ConfCameraInfo
 *@return BOOL
 */
- (BOOL)attachVideoView:(ConfCameraInfo*)cameraInfo {
    // 取消 暂停自己或比别人的视频（重新获取）
    int result = tup_conf_video_resume(self.dataConfHandle,cameraInfo.userId, cameraInfo.deviceId);
    DDLogInfo(@"<INFO>: video resume before attach: iRet = %d", result);
    
    int showMode = SLIM_MODE;
    // 用户的视频与窗口进行绑定
    int iRet = tup_conf_video_attach(self.dataConfHandle, cameraInfo.userId, cameraInfo.deviceId,(__bridge void*)cameraInfo.videoView, true, showMode);
    DDLogInfo(@"<INFO>:attachVideo with showMode %d, and iRet = %d",showMode,iRet);
    if (cameraInfo.userId == _localCamreaInfo.userId) {
        _localCamreaInfo = cameraInfo;
    }else {
        _remoteCamreaInfo = cameraInfo;
    }
    return (iRet == TC_OK);
}

/**
 * This method is used to handle application resign active
 * 处理应用退出事件 （关闭本地视频，解绑远端视频）
 */
-(void)handleUIApplicationWillResignActiveNotification {
    if (0 != _localCamreaInfo.deviceId) {
        TUP_RESULT ret = tup_conf_video_close(_dataConfHandle, (TUP_UINT32)_localCamreaInfo.deviceId);
        DDLogInfo(@"background tup_conf_video_close result is %d", ret);
    }
    
    if (0 != _remoteCamreaInfo.deviceId) {
        TUP_RESULT iRet = tup_conf_video_detach(_dataConfHandle, _remoteCamreaInfo.userId, _remoteCamreaInfo.deviceId, (__bridge void *)_remoteCamreaInfo.videoView, true);
        DDLogInfo(@"background detach view ret = %d", iRet);
    }
}

/**
 * This method is used to handle application did become active
 * 处理应用开启事件 （打开本地视频，恢复远端视频）
 */
- (void)handleUIApplicationDidBecomeActiveNotification
{
    if (0 != _remoteCamreaInfo.deviceId) {
        TUP_RESULT nRet = tup_conf_video_resume(_dataConfHandle, _remoteCamreaInfo.userId, _remoteCamreaInfo.deviceId);
        TUP_RESULT attachRet = tup_conf_video_attach(_dataConfHandle, _remoteCamreaInfo.userId, _remoteCamreaInfo.deviceId, (__bridge TUP_VOID*)_remoteCamreaInfo.videoView, true, 0);
        DDLogInfo(@"become active remote resume: %d attach: %d", nRet, attachRet);
    }
    
    if (0 != _localCamreaInfo.deviceId) {
        TC_VIDEO_PARAM videoParam;
        memset(&videoParam, 0, sizeof(TC_VIDEO_PARAM));
        videoParam.xResolution = 640;
        videoParam.yResolution = 480;
        videoParam.nFrameRate = 15;
        TUP_RESULT sRes = tup_conf_video_setparam(_dataConfHandle, _localCamreaInfo.deviceId, &videoParam);
        TUP_RESULT nRet = tup_conf_video_open(_dataConfHandle, _localCamreaInfo.deviceId, true);
        DDLogInfo(@"become active local resume: setparam %d open: %d", sRes, nRet);
    }
}

/**
 * This method is used to switch local camera
 * 转换本地摄像头
 *@return YES or NO
 */
- (BOOL)switchLocalCamera {
    if (self.localCameraInfos.count > 0) {
        _cameraCaptureIndex = (_cameraCaptureIndex == CameraIndexFront) ? CameraIndexBack : CameraIndexFront;
        ConfCameraInfo *cameraInfo = self.localCameraInfos[_cameraCaptureIndex];
        TUP_UINT32 deviceId = cameraInfo.deviceId;
        [self configVideoResolvingPowerWithDeviceId:deviceId];
        TUP_RESULT openRet = tup_conf_video_open(_dataConfHandle, deviceId, YES);
        if (openRet != TC_OK) {
            DDLogInfo(@"openLocalCamera fail!");
            return NO;
        }
        DDLogInfo(@"open local camera success");
        return YES;
    }
    return NO;
}

/**
 * This method is used to open local camera
 * 打开本地摄像头
 *@return YES or NO
 */
- (BOOL)openLocalCamera {
    if (self.localCameraInfos.count > 0) {
        ConfCameraInfo *cameraInfo = self.localCameraInfos[_cameraCaptureIndex];
        TUP_UINT32 deviceId = cameraInfo.deviceId;
        [self configVideoResolvingPowerWithDeviceId:deviceId];
        TUP_RESULT openRet = tup_conf_video_open(_dataConfHandle, deviceId, YES);
        if (openRet != TC_OK) {
            DDLogInfo(@"openLocalCamera fail!");
            return NO;
        }
        DDLogInfo(@"open local camera success");
        return YES;
    }
    return NO;
}

/**
 * This method is used to close local camera
 * 关闭本地摄像头
 *@return YES or NO
 */
-(BOOL)closeLocalCamera {
    if (self.localCameraInfos.count > 0) {
        ConfCameraInfo *cameraInfo = self.localCameraInfos[_cameraCaptureIndex];
        TUP_UINT32 deviceId = cameraInfo.deviceId;
        TUP_RESULT openRet = tup_conf_video_close(_dataConfHandle, deviceId);
        if (openRet != TC_OK) {
            DDLogInfo(@"close local camera fail!");
            return NO;
        }
        DDLogInfo(@"close local camera success");
        return YES;
    }
    return NO;
}

/**
 * This method is used to set related parameters of video.
 * 设置视频的相关参数
 *@param deviceId TUP_UINT32
 */
-(void)configVideoResolvingPowerWithDeviceId:(TUP_UINT32)deviceId {
    TC_VIDEO_PARAM videoParam;
    memset(&videoParam, 0, sizeof(TC_VIDEO_PARAM));
    videoParam.xResolution = 640;
    videoParam.yResolution = 480;
    videoParam.nFrameRate = 15;
    TUP_RESULT sRes = tup_conf_video_setparam(_dataConfHandle, deviceId, &videoParam);
    if (sRes != TC_OK) {
        DDLogInfo(@"tup_conf_video_setparam failed:%d",sRes);
    }
}

/**
 * This method is used to select camera to watch
 * 选择要光看的摄像头
 *@param cameraInfo ConfCameraInfo value
 */
-(void)selectedCameraInfoToWatch:(ConfCameraInfo *)cameraInfo {
    self.currentCameraInfo = cameraInfo;
    DDLogInfo(@"cameraInfo---- :%@ _remoteCamreaInfo--- :%@",cameraInfo,_remoteCamreaInfo);
    [self detachVideoView:_remoteCamreaInfo];
    [self attachVideoView:cameraInfo];
}

/**
 * This method is used to play BFCP video view (BFCP by data channel)
 * 播放BFCP视频视图
 *@param bfcpVideoView EAGLView value (openGLDataConfView)
 */
- (void)playBfcpVideoView:(id)bfcpVideoView {
    TUP_RESULT ret_attach_as = tup_conf_as_attach(_dataConfHandle, AS_CHANNEL_TYPE_AUXFLOW, (__bridge TUP_VOID*)bfcpVideoView);
    DDLogInfo(@"ret_attach_as result: %d", ret_attach_as);
}

/**
 * This method is used to stop data conference BFCP video view showing
 * 暂停BFCP视频视图
 */
- (void)stopBfcpVideoView {
    TUP_RESULT ret_detach_as = tup_conf_as_detach(_dataConfHandle, AS_CHANNEL_TYPE_AUXFLOW);
    DDLogInfo(@"tup_conf_as_detach result: %d", ret_detach_as);
}

/**
 * This method is used to send chat message in data conference.
 * 在数据会议中发送聊天信息
 *@param message chat message body.
 *@param username mine name in data conference
 *@param userId at p2p chat it represents receiver's user id, at public chat it's ignored
 *@return YES or NO. See call back didReceiveChatMessage:
 */
- (BOOL)chatSendMsg:(NSString *)message
       fromUsername:(NSString *)username
           toUserId:(unsigned int)userId
{
    if (message.length == 0 || username.length == 0) {
        return NO;
    }
    TUP_CHAR* msg = (TUP_CHAR*)message.UTF8String;
    TUP_CHAR* name = (TUP_CHAR*)username.UTF8String;
    TUP_RESULT result = tup_conf_chat_sendmsg_ex(_dataConfHandle, (TUP_INT32)CHAT_TYPE_PUBLIC, (TUP_UINT32)userId, msg, strlen(msg), name);
    return result == TUP_SUCCESS;
}

//- (void)getConfResourceWithServerIP:(NSString *)serverIP
//                                       serverType:(NSString *)serverType // 0:ms 1:sbc 2:stg
//                                    dataConfParam:(DataConfParam *)dataConfParam
//{
//    
//    NSString *dataConfParamURL = [[ManagerService confService].dataConfParamURLDic objectForKey:dataConfParam.confId];
//    if ([dataConfParamURL length] == 0) {
//        DDLogInfo(@"data conf param uri empty!");
//        return;
//    }
//    
//    CONFCTRL_S_GET_CONF_RESOURCE *confResourceParams = (CONFCTRL_S_GET_CONF_RESOURCE *)malloc(sizeof(CONFCTRL_S_GET_CONF_RESOURCE));
//    if (NULL == confResourceParams) {
//        DDLogInfo(@"conf resource param malloc error!");
//        return;
//    }
//    memset(confResourceParams, 0, sizeof(CONFCTRL_S_GET_CONF_RESOURCE));
//    
//    const char *dataConfParamURLCStr = [dataConfParamURL UTF8String];
//    memcpy(confResourceParams->conf_url, dataConfParamURLCStr, CONFCTRL_D_MAX_URL_LEN);
//    //    HW_MEMCPY(confResourceParams->conf_url, (CONFCTRL_D_MAX_URL_LEN), dataConfParamURLCStr, strlen(dataConfParamURLCStr));
//    const char *confID = [dataConfParam.confId UTF8String];
//    memcpy(confResourceParams->random, confID, CONFCTRL_D_MAX_TOKEN_LEN);
//    //    HW_MEMCPY(confResourceParams->random, CONFCTRL_D_MAX_TOKEN_LEN, confID, strlen(confID));
//    
//    // 请求的xml消息体
//    NSString *rootElement = @"attendConferenceReq2";
//    // MediaX下hostKey和普通与会者安全号需要base64解码
//    NSString *userPwd = dataConfParam.userRole == 1 ? dataConfParam.hostKey : dataConfParam.partSecureConfNum;
//    NSString *base64Pwd = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:userPwd options:0]
//                                                encoding:NSUTF8StringEncoding];
//    
//    //    NSArray *sysLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    //    NSString *sysLanguage = [[sysLanguages objectAtIndex:0] length] > 0 ? [sysLanguages objectAtIndex:0] : @"en-US";
//    //    sysLanguage = [sysLanguage isEqualToString:@"zh-Hans"] ? @"zh-CN" : @"en-US";
//    NSString * sysLanguage = @"zh-CN";
//    
//    NSString * xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><%@><conferenceID>%@</conferenceID><pwd>%@</pwd><enableAV>%@</enableAV><enableData>%@</enableData><nickName>%@</nickName><language>%@</language><MSAddressType>%@</MSAddressType><MSAddress>%@</MSAddress><userNum>%@</userNum><userid>%@</userid><RequestType>%@</RequestType><pinCode>%@</pinCode><participantID>%@</participantID></%@>",
//                            rootElement,
//                            dataConfParam.confId,
//                            base64Pwd,
//                            @"false",
//                            @"true",
//                            dataConfParam.userName,
//                            sysLanguage,
//                            serverType,
//                            serverIP,
//                            @"", // Mediax下传userNum无法加入数据会议，所以此处置空
//                            dataConfParam.userId,
//                            @"1",
//                            dataConfParam.pinCode,
//                            dataConfParam.participantId,
//                            rootElement];
//    memcpy(confResourceParams->attend_conf_reqbody, [xmlString UTF8String], CONFCTRL_MAX_HTTPBODY_LENGTH);
//    //    HW_MEMCPY(confResourceParams->attend_conf_reqbody, CONFCTRL_MAX_HTTPBODY_LENGTH, [xmlString UTF8String], strlen([xmlString UTF8String]));
//    
//    char *outConfResource = (char *)malloc(CONFCTRL_MAX_CONFPARAMS_LENGTH);
//    if (NULL == outConfResource) {
//        DDLogInfo(@"malloc output error");
//        free(confResourceParams);
//        return;
//    }
//    memset(outConfResource, 0, CONFCTRL_MAX_CONFPARAMS_LENGTH);
//    //    HW_MEMSET(outConfResource, CONFCTRL_MAX_CONFPARAMS_LENGTH, 0, CONFCTRL_MAX_CONFPARAMS_LENGTH);
//    TUP_UINT32 outConfResourceLen = CONFCTRL_MAX_CONFPARAMS_LENGTH;
//    TUP_RESULT ret = tup_confctrl_get_conf_resource_syn(confResourceParams, outConfResource, &outConfResourceLen);
//    DDLogInfo(@"tup_confctrl_get_conf_resource_syn,result:%d", ret);
//    if (ret == TUP_SUCCESS || outConfResourceLen > 0) {
//        NSString *xmlConfResource = [NSString stringWithUTF8String:outConfResource];
//        //        DDLogError(@"get resource = %@", xmlConfResource); 调试打印，不能放开
//        ParseConfXMLInfo *xmlParse = [[ParseConfXMLInfo alloc] init];
//        multiConfUCV2 *info = [xmlParse parseUCV2ConfData:xmlConfResource];
//        dataConfParam.M = [info.userM intValue];
//        dataConfParam.T = [info.userT intValue];
//        [self createDataConfObjectWithParams:dataConfParam];
//    }
//    free(confResourceParams);
//    free(outConfResource);
//}


/**
 * This method is used to ping DataConfMode.
 * 判断当前是什么类型服务器
 *@param joinConfData DataConfParam
 *@param completion completionBlock
 */
- (void)confPingRequestWith:(DataConfParam*)joinConfData completionBlock:(void (^)(DataConfMode dataConfMode, NSString *sbcServerIP, NSString *msServerIP))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // ping MS 如果Ms服务器不通，再ping SBC服务器
        if (nil == joinConfData || nil == joinConfData.serverIp) {
            DDLogInfo(@"ping with error ms server ip");
            if (completion) {
                completion(DataConfMode_MS, nil, nil);
            }
            return;
        }
        NSString *separator = [joinConfData.serverIp containsString:@";"] ? @";" : @",";// ms地址列表一般都是以";"分割的
        NSArray *msServerList = [joinConfData.serverIp componentsSeparatedByString:separator];
        __weak typeof (self) wSelf = self;
        [self confPingServerWith:msServerList completionBlock:^(BOOL bSuc, NSString *selectedMSAddr) {
            if (bSuc) {
                if (completion) {
                    completion(DataConfMode_MS, nil, selectedMSAddr);
                }
                return;
            }
            
            NSString *randomMSServerIP = @"";
            if (nil != msServerList && [msServerList count] > 0) {
                NSUInteger index = (arc4random_uniform(INT_MAX) % [msServerList count]);
                randomMSServerIP = [msServerList objectAtIndex:index];
            } else {
                DDLogInfo(@"random ms server ip empty");
            }
            
            
            NSArray *sbcServerList = [joinConfData.sbcServerAddress componentsSeparatedByString:@";"];
            [wSelf confPingServerWith:sbcServerList completionBlock:^(BOOL bSuc, NSString *selectedSBCAddr) {
                if (completion) {
                    if (bSuc) {
                        completion(DataConfMode_SBC, selectedSBCAddr, randomMSServerIP);
                    } else {
                        completion(DataConfMode_STG, nil, randomMSServerIP);// wzy todo未测试！！！
                    }
                }
            }];
            
        }];
    });
}

/**
 * This method is used to get the best service.
 * ping成功返回对应的MS地址，失败返回nil;当存在多个服务器IP的时候，tup_conf_ping_request，返回最优的服务器
 *@param serverIPs NSArray
 *@param completion completionBlock
 */
- (void)confPingServerWith:(NSArray<NSString *> *)serverIPs completionBlock:(void (^)(BOOL bSuc, NSString *serverIP))completion
{
    if (nil == serverIPs || [serverIPs count] == 0) {
        if (completion) {
            completion(NO, nil);
        }
        return;
    }
    
    static const int ipMaxlen = 128;
    
    NSUInteger count = [serverIPs count];
    TUP_CHAR (*dstIPList)[ipMaxlen] = (TUP_CHAR (*)[ipMaxlen])malloc(sizeof(TUP_CHAR[ipMaxlen])*count);
    if (NULL == dstIPList) {
        DDLogInfo(@"dst ip malloc failed");
        if (completion) {
            completion(NO, nil);
        }
        return;
    }
    
    ConfPingCallbackBlock block = ^(NSInteger pingID, NSString *dstIP, NSInteger nType){
        if (completion) {
            if (nType == PING_RET_COMPLETE) {
                completion(YES, dstIP);
            } else {
                completion(NO, nil);
            }
        }
    };
    [s_blockDic setObject:block forKey:CONF_PING_CALLBACK_KEY];
    
    TUP_INT ipCount = 0;
    for (int i = 0; i < count; ++i) {
        memset(dstIPList[i], 0, ipMaxlen);
        id tmpServerIP = [serverIPs objectAtIndex:i];
        // 防止非NSString类型(NSNull)调用导致的崩溃
        if (![tmpServerIP isKindOfClass:[NSString class]]
            && ![tmpServerIP isKindOfClass:[NSMutableString class]])
        {
            tmpServerIP = @"";
            DDLogInfo(@"ping param ip error!!!");
        }
        
        const char *tmpIP = [tmpServerIP UTF8String];
        if (0 == strlen(tmpIP))
        {
            DDLogInfo(@"ping ip is empty, ignore!");
            continue;
        }
        ipCount++;
        strncpy(dstIPList[i], tmpIP, strlen(tmpIP));
        //        memcpy(dstIPList[i], tmpIP, strlen(tmpIP));
    }
    
    if (0 == ipCount)
    {
        DDLogInfo(@"ip is all empty, need not ping!");
        free(dstIPList);
        dstIPList = NULL;
        if (completion) {
            completion(NO, nil);
        }
        [s_blockDic removeObjectForKey:CONF_PING_CALLBACK_KEY];
        return;
    }
    
    TUP_BOOL bPingWithTLS = TUP_FALSE;
    TUP_INT pRetID = -1;
    TUP_RESULT ret = tup_conf_ping_request(dstIPList, (TUP_INT)ipCount, &DataConfPingCallback, 0, &pRetID, bPingWithTLS);
    free(dstIPList);
    dstIPList = NULL;
    
    if (ret != TUP_SUCCESS) {
        if (completion) {
            completion(NO, nil);
        }
        [s_blockDic removeObjectForKey:CONF_PING_CALLBACK_KEY];
    }
}

@end
