//
//  CallEndView.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>
@protocol CallEndViewDelegate <NSObject>

-(void)transferButtonAction;

@end

@interface CallEndView : UIView
@property (assign, nonatomic)id<CallEndViewDelegate> delegate;
@property (assign, nonatomic)int callId;
+(instancetype)shareInstance;

-(void)showCallEndViewInUIView:(UIView *)superView;

-(void)removeCallEndView;

@end
