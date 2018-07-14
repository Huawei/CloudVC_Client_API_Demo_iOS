//
//  VideoShareViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ManagerService.h"
#import "EAGLView.h"
#import "ChatMsg.h"
#import "ConfCameraInfo.h"
#import "ConfAttendeeInConf.h"
#import "DeviceMotionManager.h"
#import "DataShareViewController.h"
#import "VideoShareViewController.h"
#import "DataConferenceInterface.h"
#import "DataConferenceService.h"
#import "VCConfUpdateInfo.h"

@interface VideoShareViewController ()<UITableViewDelegate, UITableViewDataSource, DataConferenceServiceDelegate, CallServiceDelegate>

@property (nonatomic, strong) UIView *localViewShower;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) EAGLView *remoteView;
@property (nonatomic, strong) EAGLView *localView;
@property (nonatomic, strong) UIButton *confDataShareBtn;
@property (nonatomic, strong) UIImageView *confDataShareImageView;
@property (nonatomic, strong) UIButton *attendCameraChooseBtn;
@property (nonatomic, strong) UIButton *cameraHandleBtn;
@property (nonatomic, strong) UIButton *cameraChangeBtn;
@property (nonatomic, strong) UIButton *setConfModeBtn;
@property (nonatomic, strong) UITableView *attendTableView;
@property (nonatomic, strong) UIImageView *attendTableViewBackImageView;
@property (nonatomic, strong) UIView *attendTableViewBackFullScreenView;

@property (nonatomic, assign) BOOL isCameraOpen;
//@property (nonatomic, strong) CallInfo *currentTupCallInfo;
@property (nonatomic, assign) NSInteger cameraCaptureIndex;
@property (nonatomic, strong) NSMutableArray *localCameraInfos;
@property (nonatomic, strong) NSMutableArray *remoteCameraInfos;

@property (nonatomic, assign) unsigned int selfUserID;
@property (nonatomic, strong) ConfCameraInfo *currentCameraInfo;
@property (nonatomic, assign) BOOL isEnterBackground;

@property (nonatomic, assign) EC_CONF_MODE currentConfMode;

@end

@implementation VideoShareViewController

- (NSMutableArray *)localCameraInfos {
    if (!_localCameraInfos) {
        _localCameraInfos = [[NSMutableArray alloc] init];
    }
    return _localCameraInfos;
}

- (NSMutableArray *)remoteCameraInfos {
    if (!_remoteCameraInfos) {
        _remoteCameraInfos = [[NSMutableArray alloc] init];
    }
    return _remoteCameraInfos;
}

- (instancetype)initWithConfInfo:(ConfStatus *)confInfo {
    self = [super initWithConfInfo:confInfo];
    if (self) {
        if ([self isUseTupVideo]) {
            _isCameraOpen = YES;
        }else {
            _isCameraOpen = NO;
        }
        _isEnterBackground = NO;
        _cameraCaptureIndex = 1;
        _currentConfMode = EC_CONF_MODE_FIXED;
//        _currentTupCallInfo = [[ManagerService callService] callInfoWithConfId:confInfo.conf_id];
        self.localCameraInfos = [ManagerService dataConfService].localCameraInfos;
        [self.remoteCameraInfos addObjectsFromArray:[ManagerService dataConfService].remoteCameraInfos];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tupLocalVideoViewRefreshViewWithCallId:)
                                                     name:TUP_CALL_REFRESH_VIEW_NOTIFY
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tupRemoteVideoViewDecodeSuccessWithCallId:)
                                                     name:TUP_CALL_DECODE_SUCCESS_NOTIFY
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUIApplicationWillResignActiveNotification)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUIApplicationDidBecomeActiveNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceMotionOrientationChanged)
                                                     name:ESPACE_DEVICE_ORIENTATION_CHANGED
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveConfModeChanged:)
                                                     name:EC_SET_CONF_MODE_NOTIFY
                                                   object:nil];
    }
    return self;
}

- (void)receiveConfModeChanged:(NSNotification *)notify {
    NSDictionary *resultDic = notify.userInfo;
    BOOL result = [resultDic[ECCONF_RESULT_KEY] boolValue];
    NSString *modeStr = nil;
    switch (_currentConfMode) {
        case EC_CONF_MODE_FIXED:
            modeStr = @"Boardcast Mode";
            break;
        case EC_CONF_MODE_VAS:
            modeStr = @"Voice Active Mode";
            break;
        case EC_CONF_MODE_FREE:
            modeStr = @"Free Discuss Mode";
            break;
            
        default:
            break;
    }
    if (result) {
        [self showMessage:[NSString stringWithFormat:@"Set conf mode success. Current mode: %@", modeStr]];
    }else {
        [self showMessage:@"Set conf mode failed."];
    }
}

- (ConfCameraInfo *)currentCameraInfo {
    return [ManagerService dataConfService].currentCameraInfo;
}

- (void)handleUIApplicationWillResignActiveNotification
{
    if ([self isUsmDataConf]) {
        _isEnterBackground = YES;
        [[ManagerService dataConfService] handleUIApplicationWillResignActiveNotification];
    }
}

- (void)handleUIApplicationDidBecomeActiveNotification
{
    if ([self isUsmDataConf]) {
        _isEnterBackground = NO;
        [[ManagerService dataConfService] handleUIApplicationDidBecomeActiveNotification];
    }
}

- (unsigned int)selfUserID {
    if (self.localCameraInfos.count>0) {
        ConfCameraInfo *info = self.localCameraInfos.firstObject;
        return info.userId;
    }
    return 0;
}

- (void)dataConferenceEventCallback:(TUP_DATA_CONFERENCE_EVENT_TYPE)conferenceEvent result:(NSDictionary *)resultDictionary {
    NSDictionary *resultInfo = resultDictionary[TUP_DATACONF_CALLBACK_RESULT_KEY];
    switch (conferenceEvent) {
        case DATA_CONFERENCE_END:
        case DATA_CONFERENCE_LEAVE: {
            [[ManagerService dataConfService].remoteCameraInfos removeAllObjects];
            [[ManagerService dataConfService].localCameraInfos removeAllObjects];
            [[ManagerService confService] restoreConfParamsInitialValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self goToConfListViewController];
            });
            break;
        }
        case DATACONF_VEDIO_ON_SWITCH: {
            DDLogInfo(@"UILOG: DATACONF_VEDIO_ON_SWITCH");
            BOOL videoOpen = [resultInfo[DATACONF_VIDEO_ON_SWITCH_KEY] boolValue];
            int userId = [resultInfo[DATACONF_VIDEO_ON_SWITCH_USERID_KEY] intValue];
            if (NO == videoOpen && YES == _isCameraOpen && userId == self.selfUserID && !_isEnterBackground) {
                [[ManagerService dataConfService] switchLocalCamera];
            }
            if (NO == videoOpen && userId == self.currentCameraInfo.userId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.remoteView = nil;
                    [self.remoteView removeFromSuperview];
                });
            }
            break;
        }
        case DATACONF_USER_LEAVE: {
            NSString *leaveUserName = resultInfo[DATACONF_USER_LEAVE_KEY];
            DDLogInfo(@"user %@ leave",leaveUserName);
            break;
        }
        case DATACONF_REMOTE_CAMETAINFO: {
            DDLogInfo(@"DATACONF_REMOTE_CAMETAINFO");
            [self.remoteCameraInfos removeAllObjects];
            NSArray *tempCameraArray = resultInfo[DATACONF_REMOTE_CAMERA_KEY];
            [self.remoteCameraInfos addObjectsFromArray:tempCameraArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attendTableView reloadData];
            });
            break;
        }
        case DATACONF_VEDIO_ON_NOTIFY: {
            BOOL isOpen = [resultInfo[DATACONF_VIDEO_ON_NOTIFY_KEY] boolValue];
            DDLogInfo(@"DATACONF_VEDIO_ON_NOTIFY isOpen: %d",isOpen);
            break;
        }
        case DATACONF_GET_HOST: {
            DDLogInfo(@"DATACONF_GET_HOST number: %@", self.selfNumber);
            break;
        }
        case DATACONF_GET_PERSENT: {
            DDLogInfo(@"DATACONF_GET_PERSENT number: %@", self.selfNumber);
            break;
        }
        case DATACONF_SET_HOST_RESULT: {
            DDLogInfo(@"DATACONF_SET_HOST_RESULT");
            BOOL result = [resultInfo[UCCONF_SET_HOST_RESULT_KEY] boolValue];
            if (!result) {
                [self showMessage:@"Fali to set host role!"];
            }
            break;
        }
        case DATACONF_SET_PERSENTER_RESULT: {
            DDLogInfo(@"DATACONF_SET_PERSENTER_RESULT");
            BOOL result = [resultInfo[UCCONF_SET_PERSENTER_RESULT_KEY] boolValue];
            if (!result) {
                [self showMessage:@"Fali to set persenter role!"];
            }
            break;
        }
        case DATACONF_HOST_CHANGE: {
            DDLogInfo(@"hoster change number: %d", [resultInfo[UCCONF_NEWHOST_KEY] intValue]);
            break;
        }
        case DATACONF_PERSENTER_CHANGE: {
            DDLogInfo(@"presenter change number: %d", [resultInfo[UCCONF_NEWPERSENTER_KEY] intValue]);
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [ManagerService dataConfService].delegate = self;
    if (![self isVideoConf]) {
        BOOL result = [[ManagerService dataConfService] openLocalCamera];
        if (!result) {
            DDLogInfo(@"Open local camera failed.");
            _isCameraOpen = NO;
            [self updateCameraHandleBtn:NO];
        }else {
            _isCameraOpen = YES;
            DDLogInfo(@"Open camera successs.");
            [self updateCameraHandleBtn:YES];
        }
    }
    [[DeviceMotionManager sharedInstance] startDeviceMotionManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self isVideoConf]) {
       [[ManagerService dataConfService] closeLocalCamera];
    }
    [[DeviceMotionManager sharedInstance] stopDeviceMotionManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view insertSubview:self.backImageView belowSubview:self.bottomView];
    if ((nil != self.currentCameraInfo && [self isUsmDataConf]) || [self isUseTupVideo]) {
        [self.view insertSubview:self.remoteView aboveSubview:self.backImageView];
    }
    [self.bottomView addSubview:self.cameraChangeBtn];
    [self.view addSubview:self.localViewShower];
    if ([self isNeedAddDataBtn]) {
        [self.barView addSubview:self.confDataShareBtn];
    }
    [self.barView addSubview:self.attendCameraChooseBtn];
    if (![self isUseTupVideo] || ([self isVideoConf])) {
        [self.view addSubview:self.attendTableViewBackFullScreenView];
    }
    [self configBottomViewBtns];
    if ([self isSelfMaster] && [self isMediaXDataVideoConf]) {
        [self.bottomView addSubview:self.setConfModeBtn];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.remoteView.frame = CGRectMake(0, 0, [self selfViewWidth], [self selfViewHeight]);
}

- (BOOL)isMediaXDataVideoConf {
    return ([[ManagerService confService] isUportalMediaXConf]
            && (CONF_MEDIATYPE_VIDEO_DATA == self.confStatus.media_type));
}

- (BOOL)isNeedAddDataBtn {
    EC_CONF_MEDIATYPE confType = self.confStatus.media_type;
    BOOL isVideoDataConf = (confType == CONF_MEDIATYPE_VIDEO_DATA);
    BOOL isUSMDataConf = [self isUsmDataConf];
    return isVideoDataConf || isUSMDataConf;
}

- (void)configBottomViewBtns {
    CGFloat width = [self selfViewWidth];
    self.cameraHandleBtn.frame = CGRectMake(width/2-170, 0, 100, 71);
    self.voiceBtn.frame = CGRectMake(width/2-50, 0, 100, 71);
    self.endBtn.frame = CGRectMake(width/2+70, 0, 100, 71);
    [self.bottomView addSubview:self.cameraHandleBtn];
    [self.bottomView addSubview:self.voiceBtn];
    [self.bottomView addSubview:self.endBtn];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.frame = CGRectMake(([self selfViewWidth] - 142)/2, ([self selfViewHeight] - 142)/2, 142, 142);
        _backImageView.image = [UIImage imageNamed:@"image_conf_video_back"];
    }
    return _backImageView;
}

- (UIView *)localViewShower {
    if (nil == _localViewShower) {
        _localViewShower = [[UIView alloc]initWithFrame:CGRectMake(5, 64 + 5, 126, 95)];
        _localViewShower.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image_conf_video_small_video_back"]];
        [_localViewShower addSubview:self.localView];
    }
    return _localViewShower;
}

-(EAGLView *)localView{
    if (nil == _localView) {
        if ([self isUseTupVideo]) {
            _localView = [EAGLView getLocalView];
        }else {
            _localView = [EAGLView getDataLocalView];
        }
        _localView.frame = CGRectMake(0, 0, 126, 95);
    }
    return _localView;
}

-(EAGLView *)remoteView {
    if (nil == _remoteView) {
        if ([self isUseTupVideo]) {
            _remoteView = [EAGLView getRemoteView];
        }
        else {
            _remoteView = [EAGLView getDataRemoteView];
        }
    }
    return _remoteView;
}

- (UIButton *)cameraChangeBtn {
    if (nil == _cameraChangeBtn)
    {
        _cameraChangeBtn = [self createButtonByImage:[UIImage imageNamed:@"btn_conf_video_camera_change_normal"]
                                      highlightImage:nil
                                               title:nil
                                              target:self
                                              action:@selector(cameraChangeBtnClicked:)];
        [_cameraChangeBtn setFrame:CGRectMake(20, 20, 31, 31)];
    }
    return _cameraChangeBtn;
}

- (void)cameraChangeBtnClicked:(id)sender {
    if (_isCameraOpen) {
        if ([self isUseTupVideo]) {
            _cameraCaptureIndex = _cameraCaptureIndex == 1 ? 0 : 1;
            BOOL isSuccess = [[ManagerService callService] switchCameraIndex:_cameraCaptureIndex callId:self.confStatus.callId];
            if (isSuccess) {
                [self deviceMotionOrientationChanged];
            }
        }else {
            [[ManagerService dataConfService] closeLocalCamera];
        }
    }
    
}

- (void)deviceMotionOrientationChanged
{
    NSUInteger cameraRotation = 0;
    NSUInteger displayRotation = 0;
    
    BOOL needAdjust = [[DeviceMotionManager sharedInstance] adjustCamerRotation:&cameraRotation
                                                                displayRotation:&displayRotation
                                                                   byCamerIndex:_cameraCaptureIndex
                                                           interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        return ;
    }
    
    if (!needAdjust) {
        return;
    }
    
    [[ManagerService callService] rotationVideoDisplay:displayRotation callId:self.confStatus.callId];
    [[ManagerService callService] rotationCameraCapture:cameraRotation callId:self.confStatus.callId];
}

- (UIButton *)cameraHandleBtn {
    if (nil == _cameraHandleBtn) {
        UIImage *normalImage = [UIImage imageNamed:_isCameraOpen ? @"btn_conf_video_camera_close_normal" : @"btn_conf_video_camera_open_normal"];
        UIImage *clickImage = [UIImage imageNamed:_isCameraOpen ? @"btn_conf_video_camera_close_click" : @"btn_conf_video_camera_open_click"];
        NSString *title = _isCameraOpen ? @"Close" : @"Open";
        _cameraHandleBtn = [self createButtonByImage:normalImage
                                      highlightImage:clickImage
                                               title:title
                                              target:self
                                              action:@selector(cameraHandleBtnClicked:)];
    }
    return _cameraHandleBtn;
}

- (void)cameraHandleBtnClicked:(id)sender {
    if ([self isUsmDataConf]) {
        if (_isCameraOpen) {
            if ([[ManagerService dataConfService] closeLocalCamera]) {
                [self updateCameraHandleBtn:NO];
                _isCameraOpen = NO;
                [EAGLView hideDataLocalView];
            }
        }else {
            if ([[ManagerService dataConfService] openLocalCamera]) {
                [self updateCameraHandleBtn:YES];
                _isCameraOpen = YES;
                [EAGLView showDataLocalView];
            }
        }
    }else {
        if ([self isVideoConf]) {
            [[ManagerService callService] switchCameraOpen:!_isCameraOpen callId:self.confStatus.callId];
            _isCameraOpen = !_isCameraOpen;
        }
    }
    
}

- (void)updateCameraHandleBtn:(BOOL)isSelfCameraOpen {
    if (isSelfCameraOpen) {
        [self.cameraHandleBtn setImage:[UIImage imageNamed:@"btn_conf_video_camera_close_normal"] forState:UIControlStateNormal];
        [self.cameraHandleBtn setImage:[UIImage imageNamed:@"btn_conf_video_camera_close_click"] forState:UIControlStateHighlighted];
        [self.cameraHandleBtn setTitle:@"Close" forState:UIControlStateNormal];
    }
    else {
        [self.cameraHandleBtn setImage:[UIImage imageNamed:@"btn_conf_video_camera_open_normal"] forState:UIControlStateNormal];
        [self.cameraHandleBtn setImage:[UIImage imageNamed:@"btn_conf_video_camera_open_click"] forState:UIControlStateHighlighted];
        [self.cameraHandleBtn setTitle:@"Open" forState:UIControlStateNormal];
    }
}

- (UIButton *)setConfModeBtn {
    if (nil == _setConfModeBtn) {
        _setConfModeBtn = [self createButtonByImage:[UIImage imageNamed:@"new_login_config"]
                                      highlightImage:nil
                                               title:nil
                                              target:self
                                              action:@selector(setConfModeBtnClicked:)];
        CGFloat width = [self selfViewWidth];
        [_setConfModeBtn setFrame:CGRectMake(width-20-31, 20, 31, 31)];
    }
    return _setConfModeBtn;
}

- (void)setConfModeBtnClicked:(id)sender {
    
    void (^setModeBlock)(EC_CONF_MODE mode) = ^(EC_CONF_MODE mode) {
        if ([[ManagerService confService] isUportalMediaXConf]) {
            [[ManagerService confService] setConfMode:mode];
            _currentConfMode = mode;
        }
    };
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Conf Mode"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionMode1 = [UIAlertAction actionWithTitle:@"Boardcast Mode"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
    {
        if (setModeBlock) {
            setModeBlock(EC_CONF_MODE_FIXED);
        }
    }];
    UIAlertAction *actionMode2 = [UIAlertAction actionWithTitle:@"Voice Active Mode"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
    {
        if (setModeBlock) {
            setModeBlock(EC_CONF_MODE_VAS);
        }
    }];
    UIAlertAction *actionMode3 = [UIAlertAction actionWithTitle:@"Free Discuss Mode"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
    {
        if (setModeBlock) {
            setModeBlock(EC_CONF_MODE_FREE);
        }
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alertController addAction:actionMode1];
    [alertController addAction:actionMode2];
    [alertController addAction:actionMode3];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}

//进入多媒体会场按钮
- (UIButton *)confDataShareBtn {
    if (nil == _confDataShareBtn) {
        _confDataShareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"enter_datashare"]
                                                   highlightedImage:[UIImage imageNamed:@"enter_datashare_highlight"]];
        _confDataShareImageView.animationImages = @[[UIImage imageNamed:@"enter_datashare"],[UIImage imageNamed:@"enter_datashare1"],
                                                    [UIImage imageNamed:@"enter_datashare2"],[UIImage imageNamed:@"enter_datashare3"]];
        _confDataShareImageView.animationDuration = 2;
        
        _confDataShareBtn = [[UIButton alloc]initWithFrame:_confDataShareImageView.bounds];
        
        CGFloat width = [self selfViewWidth];
        [_confDataShareBtn setFrame:CGRectMake(width-80, 15, 34, 34)];
        
        [_confDataShareBtn addTarget:self action:@selector(confDataShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_confDataShareBtn addSubview:_confDataShareImageView];
    }
    return _confDataShareBtn;
}

- (void)confDataShareBtnClicked:(id)sender {
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    if ([ary containsObject:self]) {
        [ary removeObject:self];
    }
    DataShareViewController *dataConfCtrl = [[DataShareViewController alloc] initWithConfInfo:self.confStatus];
    [ary addObject:dataConfCtrl];
    [self.navigationController setViewControllers:ary animated:NO];
}

- (UIButton *)attendCameraChooseBtn {
    BOOL isVideoConf = [self isVideoConf];
    NSString *normalImageName = @"btn_conf_video_attend_camera_choose_normal";
    NSString *highlightImageName = @"btn_conf_video_attend_camera_choose_click";
    if (isVideoConf) {
        normalImageName = @"btn_conf_video_attend_camera_boardcast_normal";
        highlightImageName = @"btn_conf_video_attend_camera_boardcast_click";
    }
    if (nil == _attendCameraChooseBtn) {
        _attendCameraChooseBtn = [self createButtonByImage:[UIImage imageNamed:normalImageName]
                                            highlightImage:[UIImage imageNamed:highlightImageName]
                                                     title:nil
                                                    target:self
                                                    action:@selector(attendCameraChooseBtnClicked:)];
        CGFloat width = [self selfViewWidth];
        [_attendCameraChooseBtn setFrame:CGRectMake(width-40, 15, 34, 34)];
    }
    return _attendCameraChooseBtn;
}

- (void)attendCameraChooseBtnClicked:(id)sender {
    [self.attendTableViewBackFullScreenView setHidden:(!self.attendTableViewBackFullScreenView.hidden)];
}

- (UIView *)attendTableViewBackFullScreenView {
    if(nil == _attendTableViewBackFullScreenView) {
        _attendTableViewBackFullScreenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self selfViewWidth], [self selfViewHeight])];
        _attendTableViewBackFullScreenView.backgroundColor = [UIColor clearColor];
        [_attendTableViewBackFullScreenView addSubview:self.attendTableViewBackImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attendTableViewFullScreenViewTap:)];
        [_attendTableViewBackFullScreenView addGestureRecognizer:tap];
        [tap setCancelsTouchesInView:NO];
    }
    return _attendTableViewBackFullScreenView;
}

- (void)attendTableViewFullScreenViewTap:(UITapGestureRecognizer* )tap {
    _attendTableViewBackFullScreenView.hidden = YES;
}

- (UIView *)attendTableViewBackImageView {
    if (nil == _attendTableViewBackImageView) {
        CGFloat backViewX = [self selfViewWidth]-5-264;
        CGRect frame = CGRectMake(backViewX, 65, 264, [self heightOfRealTableView] + 2*5);
        _attendTableViewBackImageView = [[UIImageView alloc]initWithFrame:frame];
        _attendTableViewBackImageView.userInteractionEnabled = YES;
        UIImage *backImage = [UIImage imageNamed:@"image_conf_video_camera_choose_tableview_back_normal"];
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
        _attendTableViewBackImageView.image = [backImage resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
        [_attendTableViewBackImageView addSubview:self.attendTableView];
        
    }
    return _attendTableViewBackImageView;
}

- (CGFloat)heightOfRealTableView {
    NSInteger rowNumber = self.confStatus.participants.count;
    if (rowNumber <= 4) {
        return rowNumber*44+30;
    }
    return 4*44+30;
}

- (UITableView *)attendTableView {
    if (nil == _attendTableView) {
        CGRect frame = CGRectMake(5, 5, 254, [self heightOfRealTableView]);
        _attendTableView = [[UITableView alloc]initWithFrame:frame];
        _attendTableView.backgroundColor = [UIColor clearColor];
        _attendTableView.delegate = self;
        _attendTableView.dataSource = self;
        _attendTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _attendTableView.layer.masksToBounds = YES;
        _attendTableView.layer.cornerRadius = 5;
        _attendTableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _attendTableView;
}

- (void)updateRemoteViewInTupVideoConf:(BOOL)isAddView {
    if (![self isUseTupVideo]) {
        DDLogInfo(@"not use tup video, ignore!");
        return;
    }
    //如果为使用tup视频能力的会议，使用的是视频呼叫的视频view，需要根据通知做add和remove处理
    if (isAddView) {
        [self.view insertSubview:self.remoteView aboveSubview:self.backImageView];
    }else {
        [self.remoteView removeFromSuperview];
    }
}

- (void)updateLocalViewInTupVideoConf:(BOOL)isAddView {
    if (![self isUseTupVideo]) {
        DDLogInfo(@"not tup video conf, ignore!");
        return;
    }
    if (isAddView) {
        [self.localViewShower addSubview:self.localView];
    }else {
        [self.localView removeFromSuperview];
    }
}

- (void)tupLocalVideoViewRefreshViewWithCallId:(NSNotification *)notify {
    if (![self isUseTupVideo]) {
        DDLogInfo(@"not tup video conf,ignore!");
        return;
    }
    NSNumber *callidNumber = notify.object;
    unsigned int callid = [callidNumber unsignedIntValue];
    if (self.confStatus.callId != callid) {
        DDLogInfo(@"call id is not equal to mcu conf callid, ignore!");
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateLocalViewInTupVideoConf:YES];
    });
}

- (void)tupRemoteVideoViewDecodeSuccessWithCallId:(NSNotification *)notify {
    if (![self isUseTupVideo]) {
        DDLogInfo(@"not tup video conf,ignore!");
        return;
    }
    NSNumber *callidNumber = notify.object;
    unsigned int callid = [callidNumber unsignedIntValue];
    if (self.confStatus.callId != callid) {
        DDLogInfo(@"call id is not equal to mcu conf callid, ignore!");
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRemoteViewInTupVideoConf:YES];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.confStatus.participants.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Please select attendee.";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    VCConfUpdateInfo *attendee = self.confStatus.participants[indexPath.row];
    if ([attendee.aucName isEqualToString:self.selfNumber]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(me)", attendee.aucName];
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", attendee.aucName];
    }
    if ([self isUsmDataConf]) {
        if ([attendee.aucName isEqualToString:self.selfNumber]) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }else {
            BOOL isNeedSelected = [self isReportCameraInfoWithUserID:attendee.userID];
            if (isNeedSelected) {
                cell.textLabel.textColor = [UIColor blackColor];
            }else {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
    }else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (BOOL)isReportCameraInfoWithUserID:(NSString *)userID {
    if (0 == userID.length) {
        return NO;
    }
    BOOL isReport = NO;
    for (ConfCameraInfo *tempCamreaInfo in self.remoteCameraInfos) {
        if (tempCamreaInfo.userId == [userID intValue]) {
            isReport = YES;
            continue;
        }
    }
    return isReport;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VCConfUpdateInfo *attendee = self.confStatus.participants[indexPath.row];
    if ([self isVideoConf]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                                 message:[NSString stringWithFormat:@"Watch %@'s video?", attendee.aucName]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *broadcastAction = [UIAlertAction actionWithTitle:@"Broadcast"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            [[ManagerService confService] boardcastAttendeeM:attendee.ucM T:attendee.ucT isBoardcast:YES];
        }];
        UIAlertAction *watchAction = [UIAlertAction actionWithTitle:@"Watch"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [[ManagerService confService] watchAttendeeM:attendee.ucM T:attendee.ucT];
                                                                }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        if([self isSelfMaster]){
            [alertController addAction:broadcastAction];
        }
        [alertController addAction:watchAction];
        [alertController addAction:cancelAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }else {
        BOOL isExist = NO;
        ConfCameraInfo *cameraInfo = nil;
        for (ConfCameraInfo *tempCamreaInfo in self.remoteCameraInfos) {
            if (tempCamreaInfo.userId == [attendee.userID intValue]) {
                isExist = YES;
                cameraInfo = tempCamreaInfo;
                continue;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isExist) {
                DDLogInfo(@"cameraInfo---- :%@",cameraInfo);
                [[ManagerService dataConfService] selectedCameraInfoToWatch:cameraInfo];
                [self.view insertSubview:self.remoteView aboveSubview:self.backImageView];
            }
        });
    }
}

- (BOOL)isVideoConf {
    BOOL isVideoConf = NO;
    if (CONF_MEDIATYPE_VIDEO == self.confStatus.media_type || CONF_MEDIATYPE_VIDEO_DATA == self.confStatus.media_type) {
        isVideoConf = YES;
    }
    return isVideoConf;
}

- (BOOL)isUseTupVideo {
    return [self isVideoConf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
