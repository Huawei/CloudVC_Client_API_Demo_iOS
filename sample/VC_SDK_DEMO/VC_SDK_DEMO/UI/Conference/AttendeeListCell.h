//
//  AttendeeListCell.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>
@class VCConfUpdateInfo;

@interface AttendeeListCell : UITableViewCell
@property (nonatomic,strong) VCConfUpdateInfo *attendee;

- (void)startInvitingAnimation;
@end
