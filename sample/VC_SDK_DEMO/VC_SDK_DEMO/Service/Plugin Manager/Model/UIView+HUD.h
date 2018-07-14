//
//  UIView+HUD.h
//  eSpace
//
//  Created by heleiwu on 6/18/15.
//  Copyright (c) 2015 www.huawei.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESpaceProgressHUD.h"

@interface UIView (HUD)

- (void)showTextHUD:(NSString *)title message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;
- (BOOL)hadLoadedHUD;
- (void)showLoadingHUD:(NSString *)labelText animated:(BOOL)animated;
- (void)hideHUD:(BOOL)animated;
- (void)hideHUDAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;
- (ESpaceProgressHUD*) HUDView;
@end
