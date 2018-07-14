//
//  ConfDetailViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ConfDetailViewController.h"
#import "ManagerService.h"
#import "LoginInfo.h"
#import "ECCurrentConfInfo.h"
#import "ConfAttendee.h"
#import "CommonUtils.h"
#import "ConfRunningViewController.h"
#import "AppDelegate.h"

@interface ConfDetailViewController ()<ConferenceServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediaType;
@property (weak, nonatomic) IBOutlet UILabel *chairmanPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *generalPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduserNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *confStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *joinNumberTextField;

@end

@implementation ConfDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ManagerService confService].delegate = self;
    BOOL result = [[ManagerService confService] obtainConferenceDetailInfoWithConfId:_confInfo.conf_id Page:1 pageSize:10];
    if (!result)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    NSArray *array = [[ManagerService callService].sipAccount componentsSeparatedByString:@"@"];
    NSString *shortSipNum = array[0];
    self.joinNumberTextField.text = shortSipNum;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)ecConferenceEventCallback:(EC_CONF_E_TYPE)ecConfEvent result:(NSDictionary *)resultDictionary
{
    if (ecConfEvent == CONF_E_CURRENTCONF_DETAIL)
    {
        BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
        if (!result)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        ECCurrentConfInfo *currentConfInfo = resultDictionary[ECCONF_CURRENTCONF_DETAIL_KEY];
        _confInfo = currentConfInfo.confDetailInfo;
        _idLabel.text = _confInfo.conf_id;
        _subjectLabel.text = _confInfo.conf_subject;
        _accessNumberLabel.text = _confInfo.access_number;
        _startTimeLabel.text = _confInfo.start_time;
        _endTimeLabel.text = _confInfo.end_time;
        _chairmanPwdLabel.text = _confInfo.chairman_pwd;
        _generalPwdLabel.text = _confInfo.general_pwd;
        _scheduserNameLabel.text = _confInfo.scheduser_name;
        _scheduserNumberLabel.text = _confInfo.scheduser_number;
        switch (_confInfo.media_type)
        {
            case CONF_MEDIATYPE_VOICE:
                _mediaType.text = @"Voice conference";
                break;
            case CONF_MEDIATYPE_VIDEO:
                _mediaType.text = @"Video conference";
                break;
            case CONF_MEDIATYPE_DATA:
                _mediaType.text = @"Data conference";
                break;
            case CONF_MEDIATYPE_VIDEO_DATA:
                _mediaType.text = @"Data + Video conference";
                break;
            default:
                break;
        }
        switch (_confInfo.conf_state)
        {
            case CONF_E_CONF_STATE_SCHEDULE:
                _confStatusLabel.text = @"SCHEDULE";
                break;
            case CONF_E_CONF_STATE_CREATING:
                _confStatusLabel.text = @"CREATING";
                break;
            case CONF_E_CONF_STATE_GOING:
                _confStatusLabel.text = @"ON GOING";
                break;
            case CONF_E_CONF_STATE_DESTROYED:
                _confStatusLabel.text = @"END";
                break;
            default:
                break;
        }
    }
}

- (IBAction)joinConferenceButtonAction:(id)sender
{
//    if (_confInfo.media_type == 17)
//    {
//        [self showMessage:@"Can not directly joining the data conference"];
//        return;
//    }
    if (_confInfo.conf_state == CONF_E_CONF_STATE_DESTROYED)
    {
        [self showMessage:@"This conference have been end!"];
        return;
    }
    if (_confInfo.conf_state != CONF_E_CONF_STATE_GOING)
    {
        [self showMessage:@"This conference have not start going!"];
        return;
    }
    
    LoginInfo *mine = [[ManagerService loginService] obtainCurrentLoginInfo];
    ConfAttendee *tempAttendee = [[ConfAttendee alloc] init];
    tempAttendee.name = mine.account;
    tempAttendee.number = self.joinNumberTextField.text;
    tempAttendee.type = ATTENDEE_TYPE_NORMAL;
    DDLogInfo(@"scheduser_number : %@",_confInfo.scheduser_number);
    if (_confInfo.chairman_pwd.length > 0)
    {
        tempAttendee.role = CONF_ROLE_CHAIRMAN;
    }
    else
    {
        tempAttendee.role = CONF_ROLE_ATTENDEE;
    }
    NSArray *attendeeArray = @[tempAttendee];
    
	[[ManagerService confService] joinConference:_confInfo attendee:attendeeArray];

}
- (IBAction)TextFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)showMessage:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
}

- (void)creatAlert:(NSTimer *)timer
{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}
-(void)dealloc
{
    [ManagerService confService].delegate = nil;
}
@end
