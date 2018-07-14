//
//  ConfRunningViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ConfRunningViewController.h"
#import "ManagerService.h"
//#import "ECConfInfo.h"
//#import "ECCurrentConfInfo.h"
#import "ConfAttendee.h"
#import "ConfAttendeeInConf.h"
#import "ConfStatus.h"
#import "AttendeeListCell.h"
#import "ConfListViewController.h"
#import "VideoShareViewController.h"
#import "DataShareViewController.h"
#import "DialSecondPlate.h"
#import "tup_confctrl_def.h"

#import "ChatMsg.h"
#import "EAGLView.h"
#import "CommonUtils.h"
#import "VCConfUpdateInfo.h"
#import "VCAttendee.h"

@interface ConfRunningViewController ()<UITableViewDelegate, UITableViewDataSource, ConferenceServiceDelegate, DataConferenceServiceDelegate, DialSecondPlateDelegate>

@property (nonatomic, strong)VCConfUpdateInfo *mineConfInfo;

@property (nonatomic,strong) IBOutlet UITableView *attendeeListTableView;
@property (nonatomic, strong) NSMutableArray *currentAttendees;

@property (nonatomic,strong) UIImageView *enterDataSharedView;
@property (nonatomic,strong) UIImageView *enterVideoShareView;
@property (nonatomic,strong) UIButton *enterVideoShareBtn;
@property (nonatomic,strong) UIButton *enterDataSharedBtn;

@property (nonatomic,copy) NSString *sipAccount;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *speakerBtn;
@property (weak, nonatomic) IBOutlet UIButton *addMemberBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyPadBtn;
@property (weak, nonatomic) IBOutlet UIButton *requestChairBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataMeetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *postPoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *lockConfLabel;
@property (weak, nonatomic) IBOutlet UILabel *chairLabel;

@property (nonatomic, assign) BOOL isMicMute;
@property (nonatomic, assign) BOOL __block isLock;
@property (nonatomic, strong) NSMutableArray *currentSpeakArray;
@property (nonatomic, strong) NSMutableArray *attendeeArray;
@property (nonatomic, strong) VCAttendee *vcAttendee;

@end

@implementation ConfRunningViewController

-(void)ecConferenceEventCallback:(EC_CONF_E_TYPE)ecConfEvent result:(NSDictionary *)resultDictionary
{
    switch (ecConfEvent)
    {
        case CONF_E_ATTENDEE_UPDATE_INFO:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!_attendeeArray){
                    _attendeeArray = [[NSMutableArray alloc]init];
                }
                if(!_currentStatus){
                    _currentStatus  = [[ConfStatus alloc] init];
                }
                
                _currentStatus.callId = [[CommonUtils getUserDefaultValueWithKey:@"confCallId"] intValue];
                _attendeeArray = resultDictionary[VCCONF_ATTENDEE_UPDATE_KEY];
                _currentStatus.participants = [NSMutableArray arrayWithArray:_attendeeArray];
                int mediaType = [[ManagerService confService] obtainMediaType];
                DDLogInfo(@"ESpaceConfRunningViewController mediaType is %d",mediaType);
                switch (mediaType) {
                    case 1:
                    {
                        _currentStatus.media_type = CONF_MEDIATYPE_VOICE;
                    }
                        break;
                    case 3:
                    {
                        _currentStatus.media_type = CONF_MEDIATYPE_VIDEO;
                    }
                        break;
                    case 17:
                    {
                        _currentStatus.media_type = CONF_MEDIATYPE_DATA;
                    }
                        break;
                    case 19:
                    {
                        _currentStatus.media_type = CONF_MEDIATYPE_VIDEO_DATA;
                    }
                        break;
                    default:
                        break;
                }
                //                DDLogInfo(@"_currentStatus participants count:%d",[_attendeeArray count]);
                
                //                if (_currentStatus.conf_state == CONFCTRL_E_CONF_STATE_DESTROYED) {
                //                    [[TUPService confService] restoreConfParamsInitialValue];
                //                    [self quitToListViewCtrl];
                //                }
                if (_attendeeArray.count > 0) {
                    //                    [_currentAttendees removeAllObjects];
                    //                    _currentAttendees = [NSMutableArray arrayWithArray:_currentStatus.participants];
                    //                    DDLogInfo(@"_currentAttendees:%d",_currentAttendees.count);
                    [self.attendeeListTableView reloadData];
                }
                
                _currentStatus.selfNumber = [self sipAccount];
                DDLogInfo(@"self number is %@",_currentStatus.selfNumber);
                for (VCConfUpdateInfo *tempAttendee in _attendeeArray)
                {
                    if ([tempAttendee.aucName isEqualToString:[self sipAccount]])
                    {
                        _mineConfInfo = tempAttendee;
                        if (tempAttendee.updateType == VC_ATTENDEE_UPDATE_LEAVE || tempAttendee.updateType == VC_ATTENDEE_UPDATE_BUTT) {
                            if (_currentStatus.media_type == CONF_MEDIATYPE_VIDEO_DATA)
                            {
                                BOOL isEndDataConf = [[ManagerService dataConfService] closeDataConference];
                                if (!isEndDataConf) {
                                    DDLogInfo(@"End conference(data) failed.");
                                }
                                [[ManagerService dataConfService].remoteCameraInfos removeAllObjects];
                                [[ManagerService dataConfService].localCameraInfos removeAllObjects];
                            }
                            [[ManagerService confService] restoreConfParamsInitialValue];
                            [self quitToListViewCtrl];
                        }
                    }
                }
                
                [self updateBtnStatus];
                
                // liyoufeng review 考虑辅流
                [self updateRightBarBottonItems];
            });
        }
            break;
        case CONF_E_UPGRADE_RESULT:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            if (!result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"Upgrade data conference failed!"];
                });
            }
        }
            break;
        case CONF_E_LOCK_STATUS_CHANGE:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    if(_isLock == NO){
                        [self showMessage:@"Lock conference success."];
                        _lockConfLabel.text = @"UnlockConf";
                        _isLock = YES;
                    }else{
                        [self showMessage:@"Unlock conference success."];
                        _lockConfLabel.text = @"LockConf";
                        _isLock = NO;
                    }
                    
                }
                else {
                    [self showMessage:@"Lock conference failed."];
                }
            });
            break;
        }
        case CONF_E_SPEAKER_LIST:
        {
            int speakerT = [resultDictionary[ECCONF_SPEAKERLIST_KEY] intValue];
            for(int i=0; i<[_attendeeArray count]; i++){
                VCConfUpdateInfo *confInfo = _attendeeArray[i];
                confInfo.isSpeaking = NO;
                if(confInfo.ucT == speakerT){
                    confInfo.isSpeaking = YES;
                }
                _attendeeArray[i] = confInfo;
            }
            [self.attendeeListTableView reloadData];
            break;
        }
        case CONF_E_REQUEST_CHAIRMAN_RESULT:
        {
            _vcAttendee = resultDictionary[ECCONF_RESULT_KEY];
            for(int i=0; i<[_attendeeArray count]; i++){
                VCConfUpdateInfo *confInfo = _attendeeArray[i];
                if(confInfo.ucT == _vcAttendee.terminalNum){
                    confInfo.isChair = YES;
                }
                _attendeeArray[i] = confInfo;
            }
            [self.attendeeListTableView reloadData];
            [self updateBtnStatus];
        }
            break;
        case CONF_E_RELEASE_CHAIRMAN_RESULT:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            if(result){
                for(int i=0; i<[_attendeeArray count]; i++){
                    VCConfUpdateInfo *confInfo = _attendeeArray[i];
                    if(confInfo.ucT == _vcAttendee.terminalNum){
                        confInfo.isChair = NO;
                    }
                    _attendeeArray[i] = confInfo;
                }
            }
        }
            break;
        case CONF_E_END_RESULT:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self finishConference];
        }
            break;
        case CONF_E_BROADCAST_RESULT:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"broadcast attendee success!"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"broadcast attendee fail!"];
                });
            }
        }
            break;
        case CONF_E_CANCEL_BROADCAST_RESULT:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"cancel broadcast attendee success!"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"cancel broadcast attendee fail!"];
                });
            }
        }
            break;
        case CONF_E_WATCH_RESULT:
        {
            BOOL result = [resultDictionary[ECCONF_RESULT_KEY] boolValue];
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"watch attendee success!"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"watch attendee fail!"];
                });
            }
        }
            break;
        default:
            break;
    }
}


- (void)dataConferenceEventCallback:(TUP_DATA_CONFERENCE_EVENT_TYPE)conferenceEvent result:(NSDictionary *)resultDictionary {
    DDLogInfo(@"dataConferenceEventCallback %d", conferenceEvent);
    NSDictionary *resultInfo = resultDictionary[TUP_DATACONF_CALLBACK_RESULT_KEY];
    switch (conferenceEvent) {
        case DATA_CONFERENCE_END: {
            break;
        }
        case DATACONF_USER_ENTER: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attendeeListTableView reloadData];
            });
            break;
        }
        case DATA_CONFERENCE_LEAVE: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attendeeListTableView reloadData];
            });
            break;
        }
        case DATA_CONFERENCE_JOIN_RESULT: {
            BOOL isSuccess = [resultInfo[UCCONF_RESULT_KEY] boolValue];
            DDLogInfo(@"DATA_CONFERENCE_JOIN_RESULT: %d", isSuccess);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    [self showMessage:@"Join data conf success."];
                    _dataMeetingBtn.enabled = NO;
                    [self stopTupBfcpCapability];
                }else {
                    [self showMessage:@"Join data conf failed."];
                }
                [self updateRightBarBottonItems];
            });
            break;
        }
        case DATACONF_RECEIVE_SHARE_DATA: {
            DDLogInfo(@"UILOG: DATACONF_RECEIVE_SHARE_DATA");
            break;
        }
        case DATACONF_SHARE_STOP: {
            DDLogInfo(@"UILOG: DATACONF_SHARE_STOP");
            break;
        }
        case DATACONF_VEDIO_ON_SWITCH: {
            DDLogInfo(@"UILOG: DATACONF_VEDIO_ON_SWITCH");
            break;
        }
        case DATACONF_USER_LEAVE: {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *leaveUserName = resultInfo[DATACONF_USER_LEAVE_KEY];
                DDLogInfo(@"user %@ leave",leaveUserName);
            });
            break;
        }
        case DATACONF_REMOTE_CAMETAINFO: {
            DDLogInfo(@"DATACONF_REMOTE_CAMETAINFO");
            break;
        }
        case DATACONF_VEDIO_ON_NOTIFY: {
            BOOL isOpen = [resultInfo[DATACONF_VIDEO_ON_NOTIFY_KEY] boolValue];
            DDLogInfo(@"DATACONF_VEDIO_ON_NOTIFY isOpen: %d",isOpen);
            break;
        }
        case DATACONF_GET_HOST: {
            DDLogInfo(@"DATACONF_GET_HOST");
            break;
        }
        case DATACONF_GET_PERSENT: {
            DDLogInfo(@"DATACONF_GET_PERSENT");
            break;
        }
        case DATACONF_SET_HOST_RESULT: {
            DDLogInfo(@"DATACONF_SET_HOST_RESULT");
            BOOL result = [resultInfo[UCCONF_SET_HOST_RESULT_KEY] boolValue];
            if (!result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"Set host role failed."];
                });
            }
            break;
        }
        case DATACONF_SET_PERSENTER_RESULT: {
            DDLogInfo(@"DATACONF_SET_PERSENTER_RESULT");
            BOOL result = [resultInfo[UCCONF_SET_PERSENTER_RESULT_KEY] boolValue];
            if (!result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"Set persenter failed."];
                });
            }
            break;
        }
        case DATACONF_HOST_CHANGE: {
            DDLogInfo(@"hoster changeed, number: %d", [resultInfo[UCCONF_NEWHOST_KEY] intValue]);
            break;
        }
        case DATACONF_PERSENTER_CHANGE: {
            DDLogInfo(@"presenter changeed, number: %d", [resultInfo[UCCONF_NEWPERSENTER_KEY] intValue]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attendeeListTableView reloadData];
            });
            break;
        }
        default:
            break;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ManagerService confService].delegate = nil;
    [ManagerService dataConfService].delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ManagerService confService].delegate = self;
    [ManagerService dataConfService].delegate = self;
    [CommonUtils setToOrientation:UIDeviceOrientationPortrait];
    _vcAttendee = [[VCAttendee alloc]init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = _currentStatus.subject;
    
    self.view.backgroundColor = [UIColor clearColor];
    if (_currentStatus != nil && _currentStatus.participants.count > 0) {
        _currentAttendees = [NSMutableArray arrayWithArray:_currentStatus.participants];
    }
    _attendeeListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_attendeeListTableView registerNib:[UINib nibWithNibName:@"AttendeeListCell" bundle:nil] forCellReuseIdentifier:@"ConfAttendeeCell"];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(gobackBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    ROUTE_TYPE currentRoute = [[ManagerService callService] obtainMobileAudioRoute];
    _speakerBtn.selected = currentRoute == ROUTE_LOUDSPEAKER_TYPE;
    [[ManagerService dataConfService] configDataConfLocalView:[EAGLView getDataLocalView] remoteView:[EAGLView getDataRemoteView]];
    
    _isMicMute = NO;
    _isLock = NO;
    _currentSpeakArray = [[NSMutableArray alloc]init];
    
    [self updateBtnStatus];
    [self updateRightBarBottonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpeakerStatus:) name:NTF_AUDIOROUTE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRightBarBottonItems) name:@"TupBfcpDealMessage" object:nil];
    
}

- (void)refreshBtnState
{
    BOOL isMediax = [[ManagerService confService] isUportalMediaXConf];
    BOOL isSMC = [[ManagerService confService] isUportalSMCConf];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gobackBtnAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Exit the meeting?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeMeetingAction = [UIAlertAction actionWithTitle:@"End" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (_currentStatus.media_type == CONF_MEDIATYPE_VIDEO_DATA) {
                [[ManagerService dataConfService] closeDataConference];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[ManagerService confService] confCtrlEndConference];
            [self finishConference];
            
        }];
        
        UIAlertAction *leaveMeetingAction = [UIAlertAction actionWithTitle:@"Leave" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (_currentStatus.media_type == CONF_MEDIATYPE_VIDEO_DATA) {
                [[ManagerService dataConfService] leaveDataConference];
            }
            // 挂断通话
//            CallInfo *callInfo = [[ManagerService callService] callInfoWithConfId:_currentStatus.conf_id];
            [[ManagerService callService] closeCall:_currentStatus.callId];
            [[ManagerService confService] confCtrlLeaveConference];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self finishConference];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        if ([self checkMineRoleIsChairman])
        {
            [alertController addAction:closeMeetingAction];
        }
        [alertController addAction:leaveMeetingAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(BOOL)checkMineRoleIsChairman
{
    BOOL isChairman = NO;
    if (_mineConfInfo.isChair == YES)
    {
        isChairman = YES;
    }
    return isChairman;
}

-(void)finishConference
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBarHidden = NO;
        _currentStatus = nil;
        _currentAttendees = nil;
    });
}

-(NSString *)sipAccount
{
    NSString *sipAccount = [ManagerService callService].sipAccount;
//    NSArray *array = [sipAccount componentsSeparatedByString:@"@"];
//    NSString *shortSipNum = array[0];
    
    return sipAccount;
}


-(UIImageView *)enterVideoShareView{
    if (nil == _enterVideoShareView)
    {
        _enterVideoShareView = [self animationImageViewWithNormalImage:[UIImage imageNamed:@"enter_videoshare"]
                                                      highLightedImage:[UIImage imageNamed:@"enter_videoshare_highlight"]
                                                       animationImages:@[[UIImage imageNamed:@"enter_videoshare"],[UIImage imageNamed:@"enter_videoshare1"],
                                                                         [UIImage imageNamed:@"enter_videoshare2"],[UIImage imageNamed:@"enter_videoshare3"]]
                                                  andAnimationDuration:2];
    }
    return _enterVideoShareView;
}

-(UIImageView *)enterDataSharedView
{
    if (_enterDataSharedView == nil) {
        _enterDataSharedView = [self animationImageViewWithNormalImage:[UIImage imageNamed:@"enter_datashare"]
                                                      highLightedImage:[UIImage imageNamed:@"enter_datashare_highlight"]
                                                       animationImages:@[[UIImage imageNamed:@"enter_datashare"],[UIImage imageNamed:@"enter_datashare1"],
                                                                         [UIImage imageNamed:@"enter_datashare2"],[UIImage imageNamed:@"enter_datashare3"]]
                                                  andAnimationDuration:2];
    }
    return _enterDataSharedView;
}

-(UIButton *)enterVideoShareBtn
{
    if (_enterVideoShareBtn == nil) {
        _enterVideoShareBtn = [[UIButton alloc]initWithFrame:self.enterVideoShareView.bounds];
        [_enterVideoShareBtn addTarget:self action:@selector(enterVideoSharedController) forControlEvents:UIControlEventTouchUpInside];
        [_enterVideoShareBtn addSubview:_enterVideoShareView];
    }
    return _enterVideoShareBtn;
}

- (void)enterVideoSharedController {
    VideoShareViewController *videoShareVC = [[VideoShareViewController alloc] initWithConfInfo:self.currentStatus];
    [self.navigationController pushViewController:videoShareVC animated:YES];
}

- (UIButton *)enterDataSharedBtn
{
    if (_enterDataSharedBtn == nil) {
        _enterDataSharedBtn = [[UIButton alloc] initWithFrame:self.enterDataSharedView.bounds];
        [_enterDataSharedBtn addTarget:self action:@selector(enterDataSharedController) forControlEvents:UIControlEventTouchUpInside];
        [_enterDataSharedBtn addSubview:_enterDataSharedView];
    }
    return _enterDataSharedBtn;
}

- (void)enterDataSharedController {
    DataShareViewController *dataShareVC = [[DataShareViewController alloc] initWithConfInfo:self.currentStatus];
    [self.navigationController pushViewController:dataShareVC animated:YES];
}

- (void)updateRightBarBottonItems {
    
    NSMutableArray *rightItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *enterDataShared = [[UIBarButtonItem alloc] initWithCustomView:self.enterDataSharedBtn];
    UIBarButtonItem *enterVideoShared = [[UIBarButtonItem alloc]initWithCustomView:self.enterVideoShareBtn];
    switch (_currentStatus.media_type) {
        case CONF_MEDIATYPE_VIDEO:
            if ([ManagerService callService].isShowTupBfcp) {
                [rightItems addObject:enterDataShared];
            }
            
            [rightItems addObject:enterVideoShared];
            break;
            
        case CONF_MEDIATYPE_DATA:
            if (![ManagerService dataConfService].isJoinDataConference) {
                return;
            }
            if ([[ManagerService confService] isUportalSMCConf] || [[ManagerService confService] isUportalMediaXConf]) {
                [rightItems addObject:enterDataShared];
            }else {
                [rightItems addObject:enterDataShared];
                [rightItems addObject:enterVideoShared];
            }
            break;
            
        case CONF_MEDIATYPE_VIDEO_DATA:
            if ([ManagerService dataConfService].isJoinDataConference) {
               [rightItems addObject:enterDataShared];
            }
            [rightItems addObject:enterVideoShared];
            break;
            
        default:
            [rightItems addObject:enterVideoShared];
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rightItems.count > 0) {
            self.navigationItem.rightBarButtonItems = rightItems;
        }
    });
}

- (UIImageView *)animationImageViewWithNormalImage:(UIImage *)normalImage
                                  highLightedImage:(UIImage *)highLightedImage
                                   animationImages:(NSArray *)animationImages
                              andAnimationDuration:(NSTimeInterval)animationDuration
{
    UIImageView  *imageView = [[UIImageView alloc] initWithImage:normalImage
                                                highlightedImage:highLightedImage];
    imageView.animationImages = animationImages;
    imageView.animationDuration = animationDuration;
    return imageView;
}

- (void)updateSpeakerStatus:(NSNotification *)notification
{
    ROUTE_TYPE currentRoute = (ROUTE_TYPE)[notification.userInfo[AUDIO_ROUTE_KEY] integerValue];
    _speakerBtn.selected = currentRoute == ROUTE_LOUDSPEAKER_TYPE;
}

- (BOOL)stopTupBfcpCapability
{
//    CallInfo *callInfo = [[ManagerService callService] callInfoWithConfId:_currentStatus.conf_id];
    
    [[ManagerService callService] stopTupBfcpCapabilityWithCallId:_currentStatus.callId];
    return YES;
}

- (void)quitToListViewCtrl
{
    
    UIViewController *list = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ConfListViewController class]]) {
            list = vc;
            break;
        }
    }
    
    if (list) {
        [self.navigationController popToViewController:list animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Button Action

- (void)updateBtnStatus
{
    if (_mineConfInfo.isChair) {
        [_requestChairBtn setImage:[UIImage imageNamed:@"conf_tab_release_chairman_normal"] forState:UIControlStateNormal];
        self.chairLabel.text = @"ReleaseChair";
        [_postPoneBtn setEnabled:YES];
        [_addMemberBtn setEnabled:YES];
        if (_currentStatus.media_type == CONF_MEDIATYPE_DATA
            || _currentStatus.media_type == CONF_MEDIATYPE_VIDEO_DATA) {
            [_dataMeetingBtn setEnabled:NO];
        }
        else {
            [_dataMeetingBtn setEnabled:YES];
        }
    }
    else {
        [_requestChairBtn setImage:[UIImage imageNamed:@"conf_tab_request_chairman_normal"] forState:UIControlStateNormal];
        self.chairLabel.text = @"RequestChair";
        [_postPoneBtn setEnabled:NO];
        [_addMemberBtn setEnabled:NO];
        [_dataMeetingBtn setEnabled:NO];
    }
    
    if (_mineConfInfo.ucMute && _mineConfInfo.isChair) {
        _muteBtn.selected = YES;
    }
    
}

- (IBAction)addMember:(id)sender
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"Please enter participant number" preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please enter participant number...";
        textField.secureTextEntry = NO;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *accountTxf = alertCon.textFields.firstObject;
        NSString *attendeeNum = accountTxf.text;
        [[ManagerService confService] confCtrlAddAttendeeToConfercene:attendeeNum];
    }];
    [alertCon addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:cancelAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (IBAction)requestOrReleaseChair:(id)sender {
    if (_mineConfInfo.isChair) {
        [[ManagerService confService] confCtrlReleaseChairman:_mineConfInfo.aucName];
    } else {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"Please enter password" preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Please enter password ...";
            textField.secureTextEntry = NO;
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *accountTxf = alertCon.textFields.firstObject;
            NSString *password = accountTxf.text;
            [[ManagerService confService] confCtrlRequestChairman:password number:_mineConfInfo.aucName];
        }];
        [alertCon addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

- (IBAction)muteSelf:(id)sender { //
    if (_mineConfInfo.isChair) {
        if([[ManagerService confService] confCtrlMuteAttendeeM:_mineConfInfo.ucM T:_mineConfInfo.ucT isMute:!_mineConfInfo.ucMute]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_mineConfInfo.ucMute){
                    [self showMessage:@"Unmute self success"];
                }else{
                    [self showMessage:@"Mute self success"];
                }
            });
        }
    }
    else {
        if ([[ManagerService callService] muteMic:!_isMicMute callId:_currentStatus.callId]) {
            _isMicMute = !_isMicMute;
            _muteBtn.selected = _isMicMute;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_isMicMute){
                    [self showMessage:@"Mute self success"];
                }else{
                    [self showMessage:@"Unmute self success"];
                }

            });
        }
    }

}

- (IBAction)switchSpeaker:(id)sender {
    ROUTE_TYPE routeType = [[ManagerService callService] obtainMobileAudioRoute];
    ROUTE_TYPE configType = routeType == ROUTE_LOUDSPEAKER_TYPE ? ROUTE_DEFAULT_TYPE : ROUTE_LOUDSPEAKER_TYPE;
    [[ManagerService callService] configAudioRoute:configType];
}

- (IBAction)upgradeButtonAction:(id)sender {
    if (![self checkMineRoleIsChairman])
    {
        [self showMessage:@"You are not chairman!"];
        return;
    }
    [[ManagerService confService] confCtrlVoiceUpgradeToDataConference:(_currentStatus.media_type==CONF_MEDIATYPE_VIDEO)];
}
- (IBAction)keypadButtonAction:(id)sender {
    if ([DialSecondPlate shareInstance].isShow) {
        [[DialSecondPlate shareInstance] hideView];
    }else{
        [[DialSecondPlate shareInstance] showViewInSuperView:self.view Delegate:self];
    }
}

- (IBAction)postPone:(id)sender {
    if(_mineConfInfo.isChair){
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"Please enter postpone time" preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Please enter minutes ...";
            textField.secureTextEntry = NO;
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *accountTxf = alertCon.textFields.firstObject;
            NSString *minutes = accountTxf.text;
            [[ManagerService confService] confCtrlPostponeConf:minutes];
        }];
        [alertCon addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

#pragma mark - DialSecondDelegate
-(void)clickDialSecondPlate:(NSString *)string
{
//    CallInfo *callInfo = [[ManagerService callService] callInfoWithConfId:_currentStatus.conf_id];
     [[ManagerService callService] sendDTMFWithDialNum:string callId:_currentStatus.callId];
}



#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_currentStatus.lock_state) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 20)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 20)];
    label.text = @"Conference locked.";
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view addSubview:label];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.attendeeListTableView isEqual:tableView]){
        return _attendeeArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendeeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfAttendeeCell"];
    VCConfUpdateInfo *attendee = _attendeeArray[indexPath.row];
    cell.attendee = attendee;    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mineConfInfo.isChair) {
        VCConfUpdateInfo *attendee = _attendeeArray[indexPath.row];
        unsigned int userId = [attendee.userID intValue];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:attendee.aucName
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (attendee.updateType != VC_ATTENDEE_UPDATE_LEAVE
            || attendee.updateType != VC_ATTENDEE_UPDATE_DEL) {
            
            if (attendee.dataState == DataConfAttendeeMediaStateIn) {
                UIAlertAction *presentAction = [UIAlertAction actionWithTitle:@"Set Presenter"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action)
                                                {
                                                    BOOL result = [[ManagerService dataConfService] setRoleToUser:userId role:DATACONF_USER_ROLE_PRESENTER];
                                                    if (result) {
                                                        [self showMessage:@"set presenter success."];
                                                    }else {
                                                        [self showMessage:@"set presenter failed."];
                                                    }
                                                }];
                [alertController addAction:presentAction];
            }
            
            NSString *title = attendee.ucMute ? @"Grant Talk Right" : @"Revoke Talk Right";
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[ManagerService confService] confCtrlMuteAttendeeM:attendee.ucM T:attendee.ucT isMute:!attendee.ucMute];
            }];
            [alertController addAction:action];
            
            title = attendee.ucJoinConf==1 ? @"Hangup Participant" : @"Recall Participant";
            action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(attendee.ucJoinConf == 1){
                    [[ManagerService confService] confCtrlHangUpAttendeeM:attendee.ucM T:attendee.ucT];
                } else {
                    [[ManagerService confService] confCtrlRecallAttendeeM:attendee.ucM T:attendee.ucT];
                }
                if (attendee.dataState == DataConfAttendeeMediaStateIn || attendee.dataState == DataConfAttendeeMediaStatePresent) {
                    [[ManagerService dataConfService] kickoutUser:userId];
                }
            }];
            [alertController addAction:action];
            
            title = @"Remove Participant";
            action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[ManagerService confService] confCtrlRemoveAttendeeM:attendee.ucM T:attendee.ucT];
            }];
            [alertController addAction:action];
        }
        else if (attendee.updateType == VC_ATTENDEE_UPDATE_LEAVE
                 || attendee.updateType == VC_ATTENDEE_UPDATE_DEL){
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"Redial" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                ConfAttendee *cAttendee = [[ConfAttendee alloc] init];
                //                cAttendee.name = attendee.name;
                //                cAttendee.number = attendee.number;
                //                NSArray *addAttendeeArray = @[cAttendee];
                //                [[TUPService confService] confCtrlAddAttendeeToConfercene:addAttendeeArray];
            }];
            [alertController addAction:action];
        }
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

-(void)showMessage:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
}

- (void)creatAlert:(NSTimer *)timer
{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}


@end
