//
//  LoginCenter.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "LoginCenter.h"
#import "Initializer.h"
#import "Defines.h"
#import "LoginServerInfo+uportalInfo.h"
#include <arpa/inet.h>

#import "HuaweiSDKService/login_def.h"
#import "HuaweiSDKService/login_interface.h"
#import "HuaweiSDKService/call_interface.h"
#import "HuaweiSDKService/call_advanced_interface.h"
#import "CommonUtils.h"
#import "HuaweiSDKService/TupContactsSDK.h"

NSNotificationName const UPORTAL_TOKEN_REFRESH_NOTIFY = @"UPORTAL_TOKEN_REFRESH_NOTIFY";
NSNotificationName const CALL_SIP_REGISTER_STATUS_CHANGED_NOTIFY = @"CALL_SIP_REGISTER_STATUS_CHANGED_NOTIFY";
NSString * const UPortalTokenKey = @"UPortalTokenKey";
NSString * const CallRegisterStatusKey = @"CallRegisterStatusKey";

static LoginCenter *g_loginCenter = nil;

@interface LoginCenter ()<TupLoginNotification>
@property (nonatomic, strong)LoginServerInfo *loginServerInfo;         // LoginServerInfo
@property (nonatomic, assign)BOOL bSTGTunnel;                          // is connected STG or not
@property (nonatomic, assign)TUP_FIREWALL_MODE firewallMode;           // fire wall mode
@property (nonatomic, strong)void (^callBackAction)(BOOL, NSError*);   // block
@property (nonatomic, strong)LoginAuthorizeInfo *authorizeInfo;

@end

@implementation LoginCenter

/**
 * This method is used to init this class
 * 初始化该类
 */
- (id)init
{
    if (self = [super init]) {
        [Initializer registerLoginCallBack:self];
    }
    return self;
}

/**
 *This method is used to creat single instance of this class
 *创建该类的单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_loginCenter = [[LoginCenter alloc] init];
    });
    return g_loginCenter;
}

/**
 * This method is used to login uportal authorize.
 * 登陆uportal鉴权
 *@param account user account
 *@param pwd user password
 *@param serverUrl uportal address
 *@param port uportal port
 *@param localAddress  device current ip address
 *@param completionBlock login result call back
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)pwd
               serverUrl:(NSString *)serverUrl
              serverPort:(NSUInteger)port
             networkType:(NSUInteger)networkType
            localAddress:(NSString *)localAddress
              completion:(void (^)(BOOL isSuccess, NSError *error))completionBlock
{
    LOGIN_S_AUTHORIZE_PARAM authorizeParams;
    memset(&authorizeParams, 0, sizeof(LOGIN_S_AUTHORIZE_PARAM));
    authorizeParams.auth_type = LOGIN_E_AUTH_NORMAL;
    strcpy(authorizeParams.user_agent, "WEB");
    //account+pwd
    LOGIN_S_AUTH_INFO authInfo;
    memset(&authInfo, 0, sizeof(LOGIN_S_AUTH_INFO));
    strcpy(authInfo.user_name, [account UTF8String]);
    strcpy(authInfo.password, [pwd UTF8String]);
    authorizeParams.auth_info = authInfo;
    // server
    LOGIN_S_AUTH_SERVER_INFO loginAuthServer;
    memset(&loginAuthServer, 0, sizeof(LOGIN_S_AUTH_SERVER_INFO));
    loginAuthServer.server_type = (LOGIN_E_SERVER_TYPE)networkType;
    DDLogInfo(@"network type is :%d",networkType);
    loginAuthServer.server_port = (TUP_UINT32)port;
    strcpy(loginAuthServer.server_url, [serverUrl UTF8String]);
    loginAuthServer.proxy_port = (TUP_UINT32)port;
    strcpy(loginAuthServer.proxy_url, [serverUrl UTF8String]);
    strcpy(loginAuthServer.server_version, "V6R6C00");
    authorizeParams.auth_server = loginAuthServer;
    
    TUP_RESULT result = tup_login_authorize(&authorizeParams);
    DDLogInfo(@"Login_Log: tup_login_authorize result = %#x",result);
    
    if (result != TUP_SUCCESS)
    {
        if (completionBlock) {
            completionBlock(NO, nil);
        }
    }
    else {
        self.callBackAction = completionBlock;
        LoginAuthorizeInfo *loginInfo = [[LoginAuthorizeInfo alloc] init];
        loginInfo.ipAddress = localAddress;
        loginInfo.loginAccount = account;
        loginInfo.loginName = account;
        loginInfo.loginPwd = pwd;
        loginInfo.serverAddress = serverUrl;
        loginInfo.proxyAddress = serverUrl;
        loginInfo.port = port;
        loginInfo.networkType = networkType;
        if (account.length >= 5) {
            loginInfo.selfNum = [account substringFromIndex:account.length-5];
        }
        _authorizeInfo = loginInfo;
    }
}

/**
 * This method is used to get uportal login server info.
 * 获取当前登陆信息
 *@return server info
 */
- (LoginServerInfo *)currentServerInfo
{
    return _loginServerInfo;
}

/**
 * This method is used to get current login info.
 * 获取当前登陆信息
 *@return server info
 */
- (LoginAuthorizeInfo *)loginAuthorizeInfo
{
    return _authorizeInfo;
}

/**
 * This method is used to judge whether server connect use stg tunnel.
 * 是否连接STG隧道
 *@return BOOL
 */
- (BOOL)isSTGTunnel
{
    return _bSTGTunnel;
}

/**
 * This method is used to sip account logout.
 * sip账号注销
 */
-(BOOL)logout
{
    TUP_RESULT ret = tup_call_deregister([_authorizeInfo.loginAccount UTF8String]);
    BOOL result = (TUP_SUCCESS == ret) ? YES : NO;
    return result;
}

/**
 * This method is used to deel login event callback and login sip event callback from service.
 * 分发登陆业务和登陆sip业务相关回调
 *@param module TUP_MODULE
 *@param notification Notification
 */
- (void)loginModule:(TUP_MODULE)module notification:(Notification *)notification
{
    if (module == LOGIN_UPORTAL_MODULE) {
        [self onRecvAuthorizeRegisterNotification:notification];
    }
    else {
        [self onRecvCallRegisterNotification:notification];
    }
}

- (void) onRecvNetAddrNotification:(Notification *)notification
{
    CALL_S_IDO_NETADDRESS *netaddress = (CALL_S_IDO_NETADDRESS *)notification.data;
    NSLog(@"CALL_E_EVT_NETADDR_NOTIFY_INFO :%d",netaddress->eEUAType);
    
    ContactsErrorId result = ContactsSuccess;
    
    NSString *userName = [NSString stringWithUTF8String:netaddress->acUserName];
    NSString *password = [NSString stringWithUTF8String:netaddress->acPassword];
    NSString *server = [NSString stringWithUTF8String:netaddress->acAddress];
    NSString *dnValue = [NSString stringWithUTF8String:netaddress->acDNValue];
    
    NSLog(@"username %@,password %@,server %@,dnvalue %@",userName,password,server,dnValue);
    
    if (CALL_E_EUA_TYPE_LDAP == netaddress->eEUAType)
    {
        NSLog(@"CALL_E_EUA_TYPE_LDAP");
        result = [[TupContactsSDK sharedInstance] startNetContactsService:TupContactLDAPAddress];
        NSLog(@"startNetContactsService :%d",result);
        if (result == ContactsSuccess)
        {
            
            result = [[TupContactsSDK sharedInstance] setFireWallMode:FireWallModeNULL];
            NSLog(@"setFireWallMode :%d",result);
            
            result = [[TupContactsSDK sharedInstance] setLdapConfig:userName
                                                           password:password
                                                         ldapServer:server
                                                                 dn:dnValue];
            NSLog(@"setLdapConfig :%d",result);
            
        }
        
    }
    else if (CALL_E_EUA_TYPE_FTP == netaddress->eEUAType)
    {
        NSLog(@"CALL_E_EUA_TYPE_FTP");
        result = [[TupContactsSDK sharedInstance] startNetContactsService:TupContactFTPAddress];
        if (result == ContactsSuccess)
        {
            NSString *ftpPath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/contact"];
            NSString *version = [NSString stringWithUTF8String:netaddress->acVersion];
            //ftp contact
            [[TupContactsSDK sharedInstance] downloadFtpContacts:userName
                                                        password:password
                                                       ftpServer:server
                                                        filePath:ftpPath
                                                         version:version
                                             downloadResultBlock:^(BOOL result) {
                                                 NSLog(@"downloadFtpContacts result : %d",result);
                                             }];
        }
    }
    
}

- (BOOL)contactStartupWithLogPath
{
    NSString *logPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log"];
    TupContactsSDK *mgr = [TupContactsSDK sharedInstance];
    NSString *path = [logPath stringByAppendingString:@"/contact"];
    [mgr setLogParam:TupContactsLogInfo maxSizeKB:2*1024 fileCount:1 logPath:path];
    [mgr setUserAccount:[CommonUtils getUserDefaultValueWithKey:USER_ACCOUNT]];
    return YES;
}

/**
 * This method is used to deel login event callback from service.
 * 分发登陆业务相关回调
 *@param module TUP_MODULE
 *@param notification Notification
 */
-(void)onRecvAuthorizeRegisterNotification:(Notification *)notify
{
    switch (notify.msgId)
    {
            // uportal 鉴权登陆结果
        case LOGIN_E_EVT_UPORTAL_AUTHORIZE_RESULT:
        {
            DDLogInfo(@"LOGIN_E_EVT_UPORTAL_AUTHORIZE_RESULT result is %d, userid: %d",notify.param1, notify.param2);
            LOGIN_S_UPORTAL_AUTHORIZE_RESULT *uportalInfo = (LOGIN_S_UPORTAL_AUTHORIZE_RESULT *)notify.data;
            BOOL result = notify.param1 == TUP_SUCCESS ? YES : NO;
            if (!result) {
                if (self.callBackAction) {
                    self.callBackAction(NO, nil);
                    self.callBackAction = nil;
                }
                return;
            }
            
            DDLogInfo(@": %s sip password: %s, domain :%s, expire :%d",uportalInfo->sip_impi, uportalInfo->sip_password,uportalInfo->sip_domain,uportalInfo->expire);
            LOGIN_S_SINGLE_SERVER_INFO serverInfo = uportalInfo->auth_serinfo;
            DDLogInfo(@"server address : %@ server port: %d",[NSString stringWithUTF8String:serverInfo.server_uri],serverInfo.server_port);
            LOGIN_S_AUTHORIZE_SITE_INFO *siteInfo = uportalInfo->site_info;
            LOGIN_S_ACCESS_SERVER * accessServer = siteInfo->access_server;
            DDLogInfo(@"sipURI:%@, eserver_uri: %@",[NSString stringWithUTF8String:accessServer->sip_uri],[NSString stringWithUTF8String:accessServer->eserver_uri]);
            //get sip address and port
            NSString *sipURI = [NSString stringWithUTF8String:accessServer->sip_uri];
            NSArray *tempArray = [sipURI componentsSeparatedByString:@":"];
            DDLogInfo(@"regServer: %@ port: %@",tempArray[0],tempArray[1]);
            
            
            LoginServerInfo *tupLoginAccessServer = [[LoginServerInfo alloc] initWithAccessServer:accessServer];
            tupLoginAccessServer.sipAccount = [NSString stringWithUTF8String:uportalInfo->sip_impi];
            tupLoginAccessServer.sipPwd = [NSString stringWithUTF8String:uportalInfo->sip_password];
            tupLoginAccessServer.userName = [NSString stringWithUTF8String:uportalInfo->user_name];
            tupLoginAccessServer.userNameForThirdParty = [NSString stringWithUTF8String:uportalInfo->real_user_account];
            tupLoginAccessServer.sipDomain = [NSString stringWithUTF8String:uportalInfo->sip_domain];
            tupLoginAccessServer.authServer = [NSString stringWithUTF8String:uportalInfo->auth_serinfo.server_uri];
            tupLoginAccessServer.authServerPort = uportalInfo->auth_serinfo.server_port;
            tupLoginAccessServer.token = [NSString stringWithUTF8String:uportalInfo->auth_token];
            tupLoginAccessServer.passwordType = uportalInfo->password_type;
            tupLoginAccessServer.deployMode = uportalInfo->deploy_mode;
            self.loginServerInfo = tupLoginAccessServer;
            
            [self loginFirewallDetect];

            break;
        }
        case LOGIN_E_EVT_SMC_AUTHORIZE_RESULT:
        {
            [self contactStartupWithLogPath];
            DDLogInfo(@"LOGIN_E_EVT_SMC_AUTHORIZE_RESULT result is %d, userid: %d",notify.param1, notify.param2);
            LOGIN_S_SMC_AUTHORIZE_RESULT *smcInfo = (LOGIN_S_SMC_AUTHORIZE_RESULT *)notify.data;
            BOOL result = notify.param1 == TUP_SUCCESS ? YES : NO;
            if (!result) {
                if (self.callBackAction) {
                    self.callBackAction(NO, nil);
                    self.callBackAction = nil;
                }
                return;
            } else {
                DDLogInfo(@"SMC authorize successed!");
                NSArray *array = [CommonUtils getUserDefaultValueWithKey:SERVER_CONFIG];
                NSString *url = [NSString stringWithFormat:@"https://%@:443",array[0]];
//                if (smcInfo != nil) {
//                    NSString *smcserver = [NSString stringWithUTF8String:smcInfo->smc_servers->server_uri];
//                    int port = smcInfo->smc_servers->server_port;
//                    url = [NSString stringWithFormat:@"https://%@:%d",smcserver,port];
//                }
                _authorizeInfo.smcUrl = url;
                [CommonUtils userDefaultSaveValue:url forKey:@"smcUrl"];
                DDLogInfo(@"smc server is :%@",url);
                DDLogInfo(@"loginaccount:%@  name:%@  pwd:%@",_authorizeInfo.loginAccount,_authorizeInfo.loginName,_authorizeInfo.loginPwd);
                _authorizeInfo.deployMode = LOGIN_E_DEPLOY_ENTERPRISE_CC;
//                [self loginFirewallDetect];
                [self sipLogin];
            }
            break;
        }
        case LOGIN_E_EVT_AUTHORIZE_RESULT:
        {
            [self contactStartupWithLogPath];
            DDLogInfo(@"LOGIN_E_EVT_AUTHORIZE_RESULT result:%d",notify.param1);
            BOOL result = notify.param1 == TUP_SUCCESS ? YES : NO;
            if (!result) {
                if (self.callBackAction) {
                    self.callBackAction(NO, nil);
                    self.callBackAction = nil;
                }
                return;
            }else{
                LOGIN_S_AUTHORIZE_RESULT *authResult = (LOGIN_S_AUTHORIZE_RESULT *)notify.data;
                _authorizeInfo.loginAccount = [NSString stringWithUTF8String:authResult->sip_info.auth_info.user_name];
                if (_authorizeInfo.loginAccount.length >= 5 && _authorizeInfo.loginAccount != nil) {
                    _authorizeInfo.selfNum = [_authorizeInfo.loginAccount  substringFromIndex:_authorizeInfo.loginAccount.length-5];
                }
                _authorizeInfo.loginName = [NSString stringWithUTF8String:authResult->sip_info.display_name];
                _authorizeInfo.loginPwd = [NSString stringWithUTF8String:authResult->sip_info.auth_info.password];
                _authorizeInfo.serverAddress = [NSString stringWithUTF8String:authResult->sip_info.sip_url];
                NSString* proxyUrl = [NSString stringWithUTF8String:authResult->sip_info.proxy_address];
                NSArray* addressAndPort = [proxyUrl componentsSeparatedByString:@":"];
                _authorizeInfo.proxyAddress = addressAndPort[0];
                _authorizeInfo.port = [addressAndPort[1] intValue];
                _authorizeInfo.currentToken = [NSString stringWithUTF8String:authResult->auth_token];
                _authorizeInfo.deployMode = LOGIN_E_DEPLOY_IMSHOSTED_CC;
                _authorizeInfo.confServerAddress = [NSString stringWithUTF8String:authResult->auth_serinfo.server_uri];
                _authorizeInfo.confPort = authResult->auth_serinfo.server_port;
//                [self loginFirewallDetect];
                [self sipLogin];
            }
            break;
        }
            // token 刷新结果
        case LOGIN_E_EVT_REFRESH_TOKEN_RESULT:
        {
            DDLogInfo(@"LOGIN_E_EVT_REFRESH_TOKEN_RESULT result: %#x",notify.param1);
            if (notify.param1 != TUP_SUCCESS)
            {
                DDLogInfo(@"auto refresh token fail , call refersh token method");
                tup_login_refresh_token();
            }
            LOGIN_S_REFRESH_TOKEN_RESULT *tokenInfo =(LOGIN_S_REFRESH_TOKEN_RESULT *)notify.data;
            NSString *token = @"";
            if (tokenInfo->auth_token != NULL) {
                token = [NSString stringWithUTF8String:tokenInfo->auth_token];
            }
            self.loginServerInfo.token = token;
            [[NSNotificationCenter defaultCenter] postNotificationName:UPORTAL_TOKEN_REFRESH_NOTIFY object:nil
                                                              userInfo:@{UPortalTokenKey : token}];
            break;
        }
            // 防火墙探测结果
        case LOGIN_E_EVT_FIREWALL_DETECT_RESULT:
        {
            TUP_FIREWALL_MODE mode = (TUP_FIREWALL_MODE)notify.param2;
            BOOL result = notify.param1 == TUP_SUCCESS;
            DDLogInfo(@"fire wall detect result : %d", result);
            
            // whether the firewall mode, do next step by mode.
            [self createSTGTunnel:mode];
            break;
        }
            // STG 隧道建立结果
        case LOGIN_E_EVT_STG_TUNNEL_BUILD_RESULT:
        {
            BOOL result = notify.param1 == TUP_SUCCESS;
            if (result) {
                [self sipLogin];
            }
            else {
                if (self.callBackAction) {
                    self.callBackAction(NO, nil);
                    self.callBackAction = nil;
                }
            }
        }
        default:
            break;
    }
}

/**
 * This method is used to deel login sip event callback from service
 * 分发登陆sip业务相关回调
 *@param module TUP_MODULE
 *@param notification Notification
 */
- (void)onRecvCallRegisterNotification:(Notification *)notification
{
    switch (notification.msgId) {
            // sip 账户信息改变通知
        case CALL_E_EVT_SIPACCOUNT_INFO:
        {
            CALL_S_SIP_ACCOUNT_INFO *regResult = (CALL_S_SIP_ACCOUNT_INFO *)notification.data;
            NSNumber *regReasonCode = [NSNumber numberWithUnsignedInt:regResult->ulReasonCode];
            CALL_E_REASON_CODE code = (CALL_E_REASON_CODE)[regReasonCode intValue];
            CALL_E_REG_STATE newRegState = regResult->enRegState;
            BOOL success = (regResult->ulReasonCode == 0) ? YES : NO;
            DDLogInfo(@"Login: regReasonCode is %@  sucess is %d  registerstate: %d",regReasonCode,success,newRegState);
            [self handleAccountRegisterResult:newRegState reasonCode:code];
            break;
        }
            // sip 账户注销通知
        case CALL_E_EVT_CALL_LOGOUT_NOTIFY:
            // sip 账户被踢通知
        case CALL_E_EVT_FORCEUNREG_INFO:
        {
            [self logout];
            [self handleAccountRegisterResult:CALL_E_REG_STATE_UNREGISTER reasonCode:0];
            break;
        }
        case CALL_E_EVT_NETADDR_NOTIFY_INFO:
        {
            [self onRecvNetAddrNotification:notification];
        }
            
        default:
            break;
    }
}

/**
 This method is used deal account sip register result.
 sip账户注册结果处理
 @param newRegState CALL_E_REG_STATE
 @param code CALL_E_REASON_CODE
 */
-(void)handleAccountRegisterResult:(CALL_E_REG_STATE)newRegState reasonCode:(CALL_E_REASON_CODE)code
{
    CallSipStatus sipStatus = kCallSipStatusUnRegistered;
    switch (newRegState)
    {
            // SIP 账户未注册
        case CALL_E_REG_STATE_UNREGISTER:
        {
            DDLogInfo(@"sip unregister");
            sipStatus = kCallSipStatusUnRegistered;
            break;
        }
            // SIP 账户注册中
        case CALL_E_REG_STATE_REGISTERING:
        {
            DDLogInfo(@"sip logining...");
            sipStatus = kCallSipStatusRegistering;
            break;
        }
            // SIP 账户已注册
        case CALL_E_REG_STATE_REGISTERED:
        {
            DDLogInfo(@"sip have been login");
            sipStatus = kCallSipStatusRegistered;
            break;
        }
            // SIP 账户注销中
        case CALL_E_REG_STATE_DEREGISTERING:
        {
            sipStatus = kCallSipStatusUnRegistered;
            DDLogInfo(@"sip deregistering....");
            break;
        }
            // SIP 账户无效状态
        case CALL_E_REG_STATE_BUTT:
        {
            DDLogInfo(@"sip register state is butt");
            sipStatus = kCallSipStatusUnRegistered;
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (sipStatus == kCallSipStatusRegistered) {
        if (self.callBackAction) {
            self.callBackAction(YES, nil);
        }
    }
    else if (sipStatus == kCallSipStatusUnRegistered) {
        if (self.callBackAction) {
            self.callBackAction(NO, nil);
        }
    }
    else {
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_SIP_REGISTER_STATUS_CHANGED_NOTIFY object:nil userInfo:@{CallRegisterStatusKey : @(sipStatus)}];
}

/**
 * This method is used to detect fire wall
 * 防火墙探测
 */
-(void)loginFirewallDetect
{
    // param is empty, do next step.
    if (_loginServerInfo == nil || _loginServerInfo.stgUri.length == 0) {
        [self createSTGTunnel:TUP_FIREWALL_MODE_NONE];
        return;
    }
    
    LOGIN_S_DETECT_SERVER detect_server;
    memset(&detect_server, 0, sizeof(LOGIN_S_DETECT_SERVER));
    detect_server.server_num = 1;
    LOGIN_S_SERVER_ADDR_INFO servers;
    memset(&servers, 0, sizeof(LOGIN_S_SERVER_ADDR_INFO));
    NSArray *array = [_loginServerInfo.svnUri componentsSeparatedByString:@":"];
    NSString *serverUri = array[0];
    NSString *port = array[1];
    strncpy(servers.server_uri, serverUri.UTF8String, strlen(serverUri.UTF8String));
    servers.server_port = (TUP_UINT32)port.integerValue;
    detect_server.servers = &servers;
    TUP_RESULT result = tup_login_firewall_detect(&detect_server);
    
    // firewall detect failed , do next step.
    if (result != TUP_SUCCESS) {
        [self createSTGTunnel:TUP_FIREWALL_MODE_NONE];
    }
}


/**
 * This method is used to create STG tunnel
 * 创建STG隧道
 *@param mode TUP_FIREWALL_MODE
 */
- (void)createSTGTunnel:(TUP_FIREWALL_MODE)mode
{
    if (_loginServerInfo.maaUri.length == 0 || _loginServerInfo.stgUri.length > 0) {
        _bSTGTunnel = YES;
    }
    
    _firewallMode = mode;
    if (mode == TUP_FIREWALL_MODE_ONLY_HTTP || mode == TUP_FIREWALL_MODE_HTTPANDSVN) {
        _bSTGTunnel = YES;
    }
    
    if (_bSTGTunnel) {
        LOGIN_S_STG_PARAM server;
        memset(&server, 0, sizeof(LOGIN_S_STG_PARAM));
        server.stg_num = 1;
        //STG服务器
        LOGIN_S_SERVER_ADDR_INFO stg_servers;
        memset(&stg_servers, 0, sizeof(LOGIN_S_SERVER_ADDR_INFO));
        NSArray *array = [_loginServerInfo.stgUri componentsSeparatedByString:@":"];
        NSString *serverUrl = array[0];
        NSString *serverPort = array[1];
        stg_servers.server_port = (TUP_UINT32)serverPort.integerValue;
        strcpy(stg_servers.server_uri, [serverUrl UTF8String]);
        server.stg_servers = &stg_servers;
        //userName、pwd、caPth
        strcpy(server.user_name, [_loginServerInfo.stgAccount UTF8String]);
        strcpy(server.password, [_loginServerInfo.stgPwd UTF8String]);
        //    strcpy(server.ca_path, [caPath UTF8String]);
        TUP_RESULT result = tup_login_build_stg_tunnel(&server);
        if (result != TUP_SUCCESS) {
            if (self.callBackAction) {
                self.callBackAction(NO, nil);
                self.callBackAction = nil;
            }
        }
    }
    else {
        [self sipLogin];
    }
}


/**
 * This method is used to register sip account.
 * sip账号注册
 */
- (void)sipLogin
{
    if (0 == _authorizeInfo.loginAccount.length
        || 0 == _authorizeInfo.loginPwd.length
        || 0 == _authorizeInfo.ipAddress.length)
    {
        if (self.callBackAction) {
            self.callBackAction(NO, nil);
            self.callBackAction = nil;
        }
        return;
    }

    [self configSipServer];
    TUP_RESULT ret_register = tup_call_register([_authorizeInfo.loginAccount UTF8String],
                                                [_authorizeInfo.loginName UTF8String],
                                                [_authorizeInfo.loginPwd UTF8String]);
    BOOL result = (TUP_SUCCESS == ret_register) ? YES : NO;
    if (!result)
    {
        if (self.callBackAction) {
            self.callBackAction(NO, nil);
            self.callBackAction = nil;
        }
    }
}

/**
 * This method is used to set proxy server.
 * 设置服务器代理
 *@param serverPort int
 *@param serverUrl NSString
 *@param userName NSString
 *@param password NSString
 *@return BOOL
 */
-(BOOL)loginSetProxy:(int)serverPort serverUrl:(NSString *)serverUrl userName:(NSString *)userName password:(NSString *)password
{
    LOGIN_S_PROXY_PARAM proxy_param;
    memset(&proxy_param, 0, sizeof(LOGIN_S_PROXY_PARAM));
    LOGIN_S_SERVER_ADDR_INFO proxy_server;
    memset(&proxy_server, 0, sizeof(LOGIN_S_SERVER_ADDR_INFO));
    proxy_server.server_port = serverPort;
    strcpy(proxy_server.server_uri, [serverUrl UTF8String]);
    LOGIN_S_AUTH_INFO proxy_auth;
    memset(&proxy_auth, 0, sizeof(LOGIN_S_AUTH_INFO));
    strcpy(proxy_auth.user_name, [userName UTF8String]);
    strcpy(proxy_auth.user_name, [password UTF8String]);
    proxy_param.proxy_auth = proxy_auth;
    proxy_param.proxy_server = proxy_server;
    TUP_RESULT result = tup_login_set_proxy(&proxy_param);
    return result == TUP_SUCCESS ? YES : NO;
}

/**
 This method is used to config sip server.
 配置sip服务器
 */
- (void)configSipServer
{
//    NSString *sipServer = @"";
//    NSInteger sipPort = 0;
//    if (_firewallMode == TUP_FIREWALL_MODE_ONLY_HTTP) {
//        if (_loginServerInfo.sipStgUri.length > 0) {
//            NSArray *sipArray = [_loginServerInfo.sipStgUri componentsSeparatedByString:@":"];
//            NSString *sipPortStr = sipArray[1];
//            sipServer = sipArray[0];
//            sipPort = sipPortStr.integerValue;
//        }
//    }
//    else if (_firewallMode == TUP_FIREWALL_MODE_HTTPANDSVN)
//    {
//        if (_loginServerInfo.svnUri.length > 0) {
//            NSArray *sipArray = [_loginServerInfo.svnUri componentsSeparatedByString:@":"];
//            sipServer = sipArray[0];
//            sipPort = 443;
//        }
//    }
//    else {
//        if (_loginServerInfo.sipUri.length > 0) {
//            NSArray *sipArray = [_loginServerInfo.sipUri componentsSeparatedByString:@":"];
//            NSString *sipPortStr = sipArray[1];
//            sipServer = sipArray[0];
//            sipPort = sipPortStr.integerValue;
//        }
//    }
    
    //Reg server address
    NSArray *array = [CommonUtils getUserDefaultValueWithKey:SERVER_CONFIG];
    SIP_TRANS_MODE sipTransMode = [array[3] intValue];
    CALL_S_SERVER_CFG serverCfg;
    memset_s(&serverCfg, sizeof(CALL_S_SERVER_CFG), 0, sizeof(CALL_S_SERVER_CFG));
    strncpy(serverCfg.server_address, [_authorizeInfo.serverAddress UTF8String], strlen([_authorizeInfo.serverAddress UTF8String]));
    serverCfg.server_port = (sipTransMode == SIP_TRANS_MODE_UDP)?_authorizeInfo.port:(TUP_UINT32)5061;
    TUP_RESULT configResult = tup_call_set_cfg(CALL_D_CFG_SERVER_REG_PRIMARY, &serverCfg);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_SERVER_REG_PRIMARY = %d, regserveraddress : %@",configResult,_authorizeInfo.serverAddress);
    
    //Proxy server address
    CALL_S_SERVER_CFG proxyServerCfg;
    memset_s(&proxyServerCfg, sizeof(CALL_S_SERVER_CFG), 0, sizeof(CALL_S_SERVER_CFG));
    strncpy(proxyServerCfg.server_address, [_authorizeInfo.proxyAddress UTF8String], strlen([_authorizeInfo.proxyAddress UTF8String]));
    proxyServerCfg.server_port = (sipTransMode == SIP_TRANS_MODE_UDP)?_authorizeInfo.port:(TUP_UINT32)5061;
    configResult = tup_call_set_cfg(CALL_D_CFG_SERVER_PROXY_PRIMARY, &proxyServerCfg);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_SERVER_PROXY_PRIMARY = %d  , proxyserveraddress : %@",configResult, _authorizeInfo.proxyAddress);
    
    CALL_S_IF_INFO IFInfo;
    memset_s(&IFInfo, sizeof(CALL_S_IF_INFO), 0, sizeof(CALL_S_IF_INFO));
    IFInfo.ulType = CALL_E_IP_V4;
    IFInfo.uAddress.ulIPv4 = inet_addr([_authorizeInfo.ipAddress UTF8String]);
    configResult = tup_call_set_cfg(CALL_D_CFG_NET_NETADDRESS, &IFInfo);
    
    CALL_E_AUTH_PASSWD_TYPE passwordType = CALL_E_AUTH_PASSWD_NORMAL;
    configResult = tup_call_set_cfg(CALL_D_CFG_ACCOUNT_PASSWORD_TYPE, &passwordType);
}

@end
