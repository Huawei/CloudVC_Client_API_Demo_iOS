//
//  ConfChatTableViewController.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>

@class VCConfUpdateInfo;
@interface ConfChatViewController : UIViewController
@property (nonatomic, strong)NSArray *confAttendees;
@property (nonatomic, strong) VCConfUpdateInfo *selfInfo;

@end
