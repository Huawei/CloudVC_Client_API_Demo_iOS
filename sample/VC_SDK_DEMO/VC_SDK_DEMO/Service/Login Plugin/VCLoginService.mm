//
//  VCLoginService.mm
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "VCLoginService.h"
#import "LoginServerInfo+uportalInfo.h"
#include "string.h"
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#import "login_interface.h"
#import "LoginInfo.h"
#import "Initializer.h"
#import "login_def.h"
#import "LoginCenter.h"
#import "CommonUtils.h"
#import "ManagerService.h"
#import "call_interface.h"
#import "LoginAuthorizeInfo.h"

#define NEEDMAALOGIN 0  // 是否需要MAA登陆
@interface VCLoginService()

/**
 *Indicates login status enum
 *登陆状态枚举
 */
@property (nonatomic, assign)LOGIN_STATUS_TYPE loginStatus;

/**
 *Indicates login info and part of authrize result
 *登陆信息以及部分鉴权结果
 */
@property (nonatomic, strong)LoginInfo *loginInfo;

@end

@implementation VCLoginService

/**
 *Indicates delegate of LoginInterface protocol
 *LoginInterface协议的代理
 */
@synthesize delegate;

/**
 *Indicates current login info and part of authrize result
 *当前登陆信息以及部分鉴权结果
 */
@synthesize currentLoginInfo;

/**
 *This method is used to init this class, in this method add observer for notification
 *该类的初始化方法，其中添加了两个事件监听
 */
-(instancetype)init
{
    if (self = [super init])
    {
        _loginStatus = LOGIN_STATUS_BUTT;
        //monitor the notification of token refresh result
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uportalTokenUpdateNotify:)
                                                     name:UPORTAL_TOKEN_REFRESH_NOTIFY
                                                   object:nil];
        //monitor the notification of sip status change
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginSipStatusChangedNotify:)
                                                     name:CALL_SIP_REGISTER_STATUS_CHANGED_NOTIFY
                                                   object:nil];
    }
    return self;
}

/**
 This method is used to do when self be released.
 VCLoginService被释放时，做去初始化操作
 */
-(void)dealloc
{
    [self unInitLoginServer];
}

/**
 *This method is used to update uportal token when it's notified
 *收到回调时刷新uportal token
 */
- (void)uportalTokenUpdateNotify:(NSNotification *)notification
{
    // config other server
    [self configOtherService];
}

/**
 *This method is used to get login status after receiving sip register notification
 *收到sip登陆回调后设置登陆状态
 */
- (void)loginSipStatusChangedNotify:(NSNotification *)notification
{
    NSNumber *status = [notification.userInfo objectForKey:CallRegisterStatusKey];
    switch (status.integerValue) {
        case kCallSipStatusUnRegistered:
        {
            // 登陆注册sip账号失败
            _loginStatus = LOGIN_STATUS_OFFLINE;
            break;
        }
        case kCallSipStatusRegistered:
        {
            // 登陆注册失败成功
            _loginStatus = LOGIN_STATUS_ONLINE;
            break;
        }
        case kCallSipStatusRegistering:
        {
            break;
        }
        default:
            break;
    }
    if (_loginStatus == LOGIN_STATUS_OFFLINE) {
        [self respondsLoginDelegateWithType:LOGINOUT_EVENT result:nil];
    }
}

/**
 *This method is used to respond login delegate with event type
 *根据事件类型将消息传递给代理
 */
-(void)respondsLoginDelegateWithType:(TUP_LOGIN_EVENT_TYPE)type result:(NSDictionary *)resultDictionary
{
    DDLogInfo(@"post to UI");
    if ([self.delegate respondsToSelector:@selector(loginEventCallback:result:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate loginEventCallback:type result:resultDictionary];
        });
    }
}

/**
 *This method is used to account login
 *账号登陆接口
 */
-(void)authorizeLoginWithLoginInfo:(LoginInfo *)LoginInfo completionBlock:(void (^)(BOOL isSuccess, NSError *error))completionBlock
{
    self.loginInfo = LoginInfo;
    // 登陆uportal鉴权
    [[LoginCenter sharedInstance] loginWithAccount:LoginInfo.account
                                          password:LoginInfo.password
                                         serverUrl:LoginInfo.regServerAddress
                                        serverPort:LoginInfo.regServerPort.integerValue
                                       networkType:LoginInfo.networkType.integerValue
                                      localAddress:[CommonUtils
                                                    getLocalIpAddressWithIsVPN:[CommonUtils checkIsVPNConnect]]
                                        completion:^(BOOL isSuccess, NSError *error)
     {
         LoginAuthorizeInfo *info = [self obtainLoginAuthorizeInfo];
         // 配置sipAccount 和 token
         [[ManagerService callService] configBussinessAccount:info.loginAccount token:info.currentToken];
         
#if NEEDMAALOGIN
         if (isSuccess) {
             NSString *token = [CommonUtils textFromBase64String:info.token];
             // 第三方鉴权返回账号通过userNameForThirdParth字段返回。 tiket鉴权场景下通过userName字段返回。
             NSString* maaAccount = info.userName.length > 0 ? info.userName : info.userNameForThirdParty;
             
             // 非第三方或tiket鉴权场景下, 返回userName可能为空, MAA登录接口不支持空账号, 使用用户输入账号
             if (maaAccount.length == 0) {
                 maaAccount = LoginInfo.account;
             }
             
             BOOL isSTGTunnel = [LoginCenter sharedInstance].isSTGTunnel;
             ECSSocketParam* param = nil;
             NSArray *serverInfos = nil;
             // 如果是链接STG隧道的情况下，maa登陆信息取maaStgUri的信息
             if (isSTGTunnel) {
                 serverInfos = [info.maaStgUri componentsSeparatedByString:@":"];
             } else {
                 serverInfos = [info.maaUri componentsSeparatedByString:@":"];
             }
             // serverInfos 只能存在serverIP和port两个元素，否则登陆失败
             if (serverInfos.count == 2)
             {
                 NSString *serverIP = serverInfos[0];
                 NSInteger port = [serverInfos[1] integerValue];
                 param = [[ECSSocketParam alloc] initWithHost:serverIP
                                                         port:port];
             }
             
             if (param == nil) {
                 if (completionBlock) {
                     completionBlock(NO, nil);
                 }
                 return ;
             }
             
             // 应用目前都使用token鉴权
             [TUPMAALoginService sharedInstance].authType = LOGINAUTHTYPE_token;
             [TUPMAALoginService sharedInstance].socketType = [LoginCenter sharedInstance].isSTGTunnel ? LOGINSOCKETTYPE_STG : LOGINSOCKETTYPE_NORMAL;
             // 登陆MAA
             [[TUPMAALoginService sharedInstance] loginWithAccount:maaAccount
                                                                pw:LoginInfo.password
                                                        serverList:@[param]
                                                          ssoToken:token
                                                        retryCount:3
                                                        completion:^(NSError *maaError)
              {
                  if (!maaError) {
                      [self configOtherService];
                      // 使用登陆maa时的account 作为当前ECSAppConfig的帐号
                      [ECSAppConfig sharedInstance].currentUser.account = maaAccount;
                      ECSUserConfig *userConfig = [[ECSAppConfig sharedInstance] currentUser];
                      [eSpaceDBService sharedInstance].localDataManager = [[ESpaceLocalDataManager alloc] initWithUserAccount:maaAccount];
                      
                      if (completionBlock) {
                          completionBlock(YES, nil);
                      }
                  }else {
                      if (completionBlock) {
                          completionBlock(NO, maaError);
                      }
                  }
              }];
         }else {
             if (completionBlock) {
                 completionBlock(isSuccess, error);
             }
         }
#else
         if (completionBlock) {
             completionBlock(isSuccess, error);
         }
         if (isSuccess) {
             [self configOtherService];
         }
#endif
     }];
}

/**
 *This method is usde to logout
 *账号登出
 */
- (void)logout
{
    [[LoginCenter sharedInstance] logout];
}

/**
 *This method is used to config bussiness account, token and conf service when token update
 *token刷新时重新配置token相关的业务
 */
- (void)configOtherService
{
    LoginAuthorizeInfo *info = [self obtainLoginAuthorizeInfo];
    [[ManagerService callService] configBussinessAccount:info.loginAccount token:info.currentToken];
    [[ManagerService confService] configToken:info.currentToken];
    [ManagerService confService].uPortalConfType = [self configDeployMode:info.deployMode];
}

/**
 *This method is used to config deploy mode
 *配置部署模式（uportal 会议类型）
 */
- (EC_CONF_TOPOLOGY_TYPE)configDeployMode:(LOGIN_E_DEPLOY_MODE)deployMode
{
    EC_CONF_TOPOLOGY_TYPE uPortalConfType = CONF_TOPOLOGY_BUTT;
    switch (deployMode) {
        case LOGIN_E_DEPLOY_ENTERPRISE_IPT:
            // uc组网，内置会议
            uPortalConfType = CONF_TOPOLOGY_UC;
            [self setMediaEnableData];
            break;
        case LOGIN_E_DEPLOY_ENTERPRISE_CC:
            // smc组网， smc会议
            uPortalConfType = CONF_TOPOLOGY_SMC;
            break;
        case LOGIN_E_DEPLOY_SPHOSTED_IPT:
        case LOGIN_E_DEPLOY_SPHOSTED_CC:
        case LOGIN_E_DEPLOY_SPHOSTED_CONF:
        case LOGIN_E_DEPLOY_IMSHOSTED_IPT:
        case LOGIN_E_DEPLOY_IMSHOSTED_CC:
            // mediax组网， mediax会议
            uPortalConfType = CONF_TOPOLOGY_MEDIAX;
            break;
        default:
            DDLogInfo(@"deploy is error, ignore!");
            break;
    }
    
    return uPortalConfType;
}

- (void)setMediaEnableData
{
    //辅流媒体开关设置
    TUP_BOOL media_enable_data = TUP_FALSE;
    TUP_RESULT ret_media_enable_data = tup_call_set_cfg(CALL_D_CFG_MEDIA_ENABLE_DATA, &media_enable_data);
}


#pragma Public method
/**
 *This method is used to obtain current login status
 *获取当前的登陆状态
 */
-(LOGIN_STATUS_TYPE)obtainCurrentLoginStatus
{
    return _loginStatus;
}

/**
 *This method is used to obtain current login info
 *获取当前登陆信息
 */
-(LoginInfo *)obtainCurrentLoginInfo
{
    return _loginInfo;
}

/**
 *This method is used to obtain ec token
 *获取鉴权token
 */
-(NSString *)obtainToken
{
    return [[LoginCenter sharedInstance] currentServerInfo].token;
}

/**
 *This method is used to obtain ec server info
 *获取服务器信息
 */
-(LoginServerInfo *)obtainAccessServerInfo
{
    return [[LoginCenter sharedInstance] currentServerInfo];
}

/**
 *This method is used to obtain vc server info
 *获取服务器信息
 */
-(LoginAuthorizeInfo *)obtainLoginAuthorizeInfo
{
    return [[LoginCenter sharedInstance] loginAuthorizeInfo];
}

#pragma mark - Authorize

/**
 *This method is used to uninit login server
 *去初始化服务器信息
 */
-(BOOL)unInitLoginServer
{
    TUP_RESULT result = tup_login_uninit();
    
    DDLogInfo(@"Login_Log: tup_login_uninit result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

@end

