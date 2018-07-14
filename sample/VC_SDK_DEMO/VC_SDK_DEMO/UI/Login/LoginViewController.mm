//
//  LoginViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "CommonUtils.h"
#import "NetworkUtils.h"
#import "AppDelegate.h"
#import "ManagerService.h"
#import "LoginInfo.h"
#import "SettingViewController.h"
#import "LoginAuthorizeInfo.h"
#import "call_interface.h"

NSString *const USER_ACCOUNT        = @"USER_ACCOUNT";
NSString *const USER_PASSWORD       = @"USER_PASSWORD";
NSString *const USER_PROXYSERVER_ADDRESS = @"USER_PROXYSERVER_ADDRESS";
NSString *const USER_REGSERVER_ADDRESS  = @"USER_REGSERVER_ADDRESS";
NSString *const USER_SERVER_PORT        = @"USER_SERVER_PORT";

NSString *const USER_SIP_ACCOUNT        = @"USER_SIP_ACCOUNT";
NSString *const USER_SIP_PASSWORD       = @"USER_SIP_PASSWORD";
NSString *const USER_SIP_PROXYSERVER_ADDRESS = @"USER_SIP_PROXYSERVER_ADDRESS";
NSString *const USER_SIP_REGSERVER_ADDRESS  = @"USER_SIP_REGSERVER_ADDRESS";
NSString *const USER_SIP_SERVER_PORT        = @"USER_SIP_SERVER_PORT";


@interface LoginViewController ()<LoginServiceDelegate>
{
    BOOL _hasTimeOut;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NetworkUtils shareInstance];
    _hasTimeOut = NO;
    _loginingActivityIndicator.hidden = YES;
    _loginButton.hidden = NO;
    _accountTextField.text = [CommonUtils getUserDefaultValueWithKey:USER_ACCOUNT];
    _passwordTextField.text = [CommonUtils getUserDefaultValueWithKey:USER_PASSWORD];
    
    _versionLabel.text = [NSString stringWithFormat:@"Version: %@", [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    _hasTimeOut = NO;
    NSArray *serverConfig = [CommonUtils getUserDefaultValueWithKey:SERVER_CONFIG];
    NSString *serverAddress = serverConfig[0];
    NSString *serverPort = serverConfig[1];
    NSString *networkType = serverConfig[2];
    NSString *sipTransMode = serverConfig[3];
    CALL_E_TRANSPORTMODE transportMode = CALL_E_TRANSPORTMODE_UDP;
    if ([sipTransMode intValue] == SIP_TRANS_MODE_TLS) {
        transportMode = CALL_E_TRANSPORTMODE_TLS;
    }
    TUP_RESULT configResult = tup_call_set_cfg(CALL_D_CFG_SIP_TRANS_MODE, &transportMode);
    DDLogInfo(@"Login: tup_call_set_cfg CALL_D_CFG_SIP_TRANS_MODE = %d",configResult);
    
    if ([[NetworkUtils shareInstance] getCurrentNetworkStatus] == NotReachable)
    {
        [self showMessage:@"Current network is unavailable"];
        return;
    }
    NSArray *array = @[self.accountTextField.text,self.passwordTextField.text];
    for (NSString *tempString in array)
    {
        if (![CommonUtils checkIsNotEmptyString:tempString])
        {
            [self showMessage:@"Parameter can't be empty!"];
            return;
        }
    }
    
    if (serverAddress.length == 0 || serverPort.length == 0) {
        [self showMessage:@"server config can't be empty!"];
        return;
    }

    [self hiddenActivityIndicator:NO];
    LoginInfo *user = [[LoginInfo alloc] init];
    user.regServerAddress = serverAddress;
    user.regServerPort = serverPort;
    user.account = self.accountTextField.text;
    user.password = self.passwordTextField.text;
    user.networkType = networkType;
    [[ManagerService loginService] authorizeLoginWithLoginInfo:user completionBlock:^(BOOL isSuccess, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isSuccess) {
                [self showMessage:[NSString stringWithFormat:@"Login Fail!code:%d",error.code]];
                [self hiddenActivityIndicator:YES];
                return ;
            }
            
            [self hiddenActivityIndicator:YES];
            [CommonUtils userDefaultSaveValue:self.accountTextField.text forKey:USER_ACCOUNT];
            [CommonUtils userDefaultSaveValue:self.passwordTextField.text forKey:USER_PASSWORD];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewController *baseViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [UIApplication sharedApplication].delegate.window.rootViewController = baseViewController;
            [self configConferenceService];
        });
    }];
}

-(void)configConferenceService
{
    LoginAuthorizeInfo *loginInfo = [[ManagerService loginService] obtainLoginAuthorizeInfo];
    int networkType = loginInfo.networkType;
    
    if(networkType == NETWORK_ONPREMISE){
        [[ManagerService confService] configConferenceCtrlWithServerAddress:loginInfo.serverAddress port:loginInfo.port networkType:networkType];
        DDLogInfo(@"current network is on-premise:%d",loginInfo.networkType);
        NSString *conferaccount = [NSString stringWithFormat:@"%@@%@",loginInfo.loginAccount,loginInfo.serverAddress];
        [[ManagerService confService] configConferenceAuthCode:conferaccount pwd:loginInfo.loginPwd];
    }else{
        [[ManagerService confService] configConferenceCtrlWithServerAddress:loginInfo.confServerAddress port:loginInfo.confPort networkType:networkType];
        NSString * token = loginInfo.currentToken;
        [[ManagerService confService] configToken:token];
        DDLogInfo(@"current network is hosted:%d; token is:%@",loginInfo.networkType,token);
    }
}

-(void)hiddenActivityIndicator:(BOOL)isHidden
{
    if (isHidden)
    {
        self.loginingActivityIndicator.hidden = YES;
        [self.loginingActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
    }
    else
    {
        self.loginingActivityIndicator.hidden = NO;
        [self.loginingActivityIndicator startAnimating];
        self.loginButton.hidden = YES;
    }
}

-(void)showMessage:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [LoginViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
}
@end
