//
//  DataConfBaseViewController.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>
#import "ConfStatus.h"

@interface DataConfBaseViewController : UIViewController

@property (nonatomic,strong) UIView  *barView;
@property (nonatomic,strong) UIButton* endBtn;
@property (nonatomic,strong) UIButton* voiceBtn;
@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic, strong) ConfStatus *confStatus;
@property (nonatomic, copy) NSString *selfNumber;
@property (nonatomic, strong)ConfAttendeeInConf *selfConfInfo;
@property (nonatomic, strong)VCConfUpdateInfo *attendee;

- (instancetype)initWithConfInfo:(ConfStatus *)confInfo;

- (CGFloat)selfViewWidth;
- (CGFloat)selfViewHeight;
- (BOOL)isSelfMaster;
- (BOOL)isUsmDataConf;
- (void)goToConfListViewController;
- (void)showMessage:(NSString *)msg;

- (UIButton *)createButtonByImage:(UIImage *)btnImage
                   highlightImage:(UIImage *)highlightImage
                            title:(NSString *)title
                           target:(id)target
                           action:(SEL)action;

@end
