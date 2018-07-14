//
//  AttendeeListCell.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "AttendeeListCell.h"
//#import "AttendeeEntity+ServiceObject.h"
//#import "EmployeeEntity+ServiceObject.h"
//#import "ConferenceService.h"
#import "ManagerService.h"
#import "ConfAttendeeInConf.h"
#import "VCConfUpdateInfo.h"
#define USER_HEAD_IMAGE_WIDTH 40
#define USER_HEAD_IMAGE_HEIGHT 40
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define dispatch_async_main_safe(block) \
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface AttendeeListCell ()
@property (nonatomic, strong) IBOutlet UIImageView          *roleIconView;
@property (nonatomic, strong) IBOutlet UILabel              *topLabel;
@property (nonatomic, strong) IBOutlet UILabel              *bottomLabel;
@property (nonatomic, strong) IBOutlet UIImageView          *voiceStatusView;
@property (nonatomic, strong) IBOutlet UIImageView          *dataConfStatusView;
@property (nonatomic, strong) IBOutlet UIImageView          *presenterIconView;
@property (weak, nonatomic) IBOutlet UIImageView *speakReportView;
@end

@implementation AttendeeListCell

- (void)removeFromSuperview
{
    [self stopInvitingAnimation];
    [super removeFromSuperview];
}

- (void)dealloc
{
    [self stopInvitingAnimation];
    self.attendee = nil;
}

- (BOOL)isSelf
{
    NSString *selfNumber = [ManagerService callService].sipAccount;
    return [selfNumber isEqualToString:self.attendee.aucName];
}

- (void)updateMediaStatus
{
    if (self.attendee.dataState == DataConfAttendeeMediaStateIn
        || self.attendee.dataState == DataConfAttendeeMediaStatePresent) {
        [self.dataConfStatusView setHidden:NO];
    }
    else {
        [self.dataConfStatusView setHidden:YES];
    }
}

- (void)updateName
{
    NSString *strName = [self.attendee aucName].length == 0 ? self.attendee.aucName : self.attendee.aucName;
    self.topLabel.text = [self isSelf] ? [NSString stringWithFormat:@"%@(%@)", strName, NSLocalizedString(@"me", @"我")] : strName;
    self.bottomLabel.text = self.attendee.aucName;
}


- (void)updateStatus
{
    NSString *strImageName = nil;
    if(self.attendee.ucJoinConf){
        strImageName = @"attendee_in";
    }
    if(self.attendee.ucMute){
        strImageName = @"attendee_mute";
    }
   if(!self.attendee.ucJoinConf){
        strImageName = @"attendee_leave";
    }

    self.voiceStatusView.image = [UIImage imageNamed:strImageName];
}

- (void)updateRole
{
    BOOL isPresent = self.attendee.dataState == DataConfAttendeeMediaStatePresent;
    self.presenterIconView.hidden = !isPresent;
//    BOOL isChairman = self.attendee.role == CONF_ROLE_CHAIRMAN;
    self.roleIconView.hidden = (self.attendee.isChair == NO);
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    if ((VC_ATTENDEE_UPDATE_JOIN == self.attendee.updateType)
        && !self.voiceStatusView.isAnimating){
        [self.voiceStatusView startAnimating];
    }
}

- (void)stopInvitingAnimation
{
    if (self.voiceStatusView.isAnimating) {
        [self.voiceStatusView stopAnimating];
    }
}

- (void)startInvitingAnimation
{
    [self stopInvitingAnimation];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i=1; i<=3; i++) {
        NSString *strImageName = [NSString stringWithFormat:@"attendee_inviting%02d", i];
        UIImage *image = [UIImage imageNamed:strImageName];
        if (nil == image) {
            continue;
        }
        [images addObject:image];
    }
    self.voiceStatusView.highlighted = NO;
    self.voiceStatusView.image = [UIImage imageNamed:@"attendee_inviting01"];
    self.voiceStatusView.animationImages = images;
    self.voiceStatusView.highlightedAnimationImages = images;
    self.voiceStatusView.animationDuration = 2.25;
    [self.voiceStatusView startAnimating];
}

- (void)updateDisplayInfo
{
    [self updateName];
    [self updateStatus];
    [self updateMediaStatus];
    [self updateRole];
    [self setIsSpeaking];
}

-(void)setAttendee:(VCConfUpdateInfo *)attendee
{
    _attendee = attendee;
    if (nil != _attendee) {
        [self updateDisplayInfo];
        [self setNeedsUpdateConstraints];
    }
    
}

- (void)setIsSpeaking
{
    self.speakReportView.hidden = !self.attendee.isSpeaking;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.attendee = nil;
    [self stopInvitingAnimation];
    self.topLabel.text = self.bottomLabel.text = nil;
}

@end
