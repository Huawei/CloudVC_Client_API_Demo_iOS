//
//  SettingViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "SettingViewController.h"
#import "CommonUtils.h"

@interface SettingViewController ()
@property (nonatomic, weak)IBOutlet UITextField *serverAddressField;
@property (nonatomic, weak)IBOutlet UITextField *serverPortField;
@property (weak, nonatomic) IBOutlet UISwitch *onPremiseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hostedSwitch;
@property (nonatomic, strong) UISwitch *currentSwitch;
@property (nonatomic, assign) NETWORK_TYPE networkType;
@property (weak, nonatomic) IBOutlet UISwitch *tlsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *udpSwitch;
@property (nonatomic, assign) SIP_TRANS_MODE sipTransMode;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [CommonUtils getUserDefaultValueWithKey:SERVER_CONFIG];
    _serverAddressField.text = array[0];
    _serverPortField.text = array[1];
    
    _currentSwitch = [[UISwitch alloc] init];

    _networkType = [array[2] intValue];
    if(_networkType == NETWORK_ONPREMISE){
        _hostedSwitch.on = false;
        _onPremiseSwitch.on = true;
    }else{
        _hostedSwitch.on = true;
        _onPremiseSwitch.on = false;
    }
    _sipTransMode = [array[3] intValue];
    if (_sipTransMode == SIP_TRANS_MODE_UDP) {
        _udpSwitch.on = true;
        _tlsSwitch.on = false;
    }else{
        _udpSwitch.on = false;
        _tlsSwitch.on = true;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPremiseChoosed:(id)sender {
    UISwitch * swtich = sender;
    _currentSwitch = swtich;
    if(swtich.on){
        _hostedSwitch.on = false;
        _networkType = NETWORK_ONPREMISE;
    } else {
        _hostedSwitch.on = true;
        _networkType = NETWORK_HOSTED;
    }
}

- (IBAction)hostedChoosed:(id)sender {
    UISwitch * swtich = sender;
    _currentSwitch = swtich;
    if(swtich.on){
        _onPremiseSwitch.on = false;
        _networkType = NETWORK_HOSTED;
    } else {
        _onPremiseSwitch.on = true;
        _networkType = NETWORK_ONPREMISE;
    }
}

- (IBAction)udpSwitchAction:(id)sender {
    UISwitch * swtich = sender;
    if(swtich.on){
        _tlsSwitch.on = false;
        _sipTransMode = SIP_TRANS_MODE_UDP;
    } else {
        _tlsSwitch.on = true;
        _sipTransMode = SIP_TRANS_MODE_TLS;
    }
}

- (IBAction)tlsSwitchAction:(id)sender {
    UISwitch * swtich = sender;
    if(swtich.on){
        _udpSwitch.on = false;
        _sipTransMode = SIP_TRANS_MODE_TLS;
    } else {
        _udpSwitch.on = true;
        _sipTransMode = SIP_TRANS_MODE_UDP;
    }
}


- (IBAction)saveBtnClicked:(id)sender
{
    [CommonUtils userDefaultSaveValue:@[_serverAddressField.text, _serverPortField.text, [NSString stringWithFormat:@"%d",_networkType],[NSString stringWithFormat:@"%d",_sipTransMode]] forKey:SERVER_CONFIG];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
