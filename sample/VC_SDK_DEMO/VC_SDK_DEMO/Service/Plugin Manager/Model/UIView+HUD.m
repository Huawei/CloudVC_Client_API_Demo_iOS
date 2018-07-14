//
//  UIView+HUD.m
//  eSpace
//
//  Created by heleiwu on 6/18/15.
//  Copyright (c) 2015 www.huawei.com. All rights reserved.
//

#import "UIView+HUD.h"
#import "ESpaceUtile.h"

@implementation UIView (HUD)

- (void)showTextHUD:(NSString *)title message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    ESpaceProgressHUD *hud = [ESpaceProgressHUD showHUDAddedTo:self animated:animated];
    hud.mode = ESpaceProgressHUDModeText;
    hud.labelText = title;
    hud.detailsLabelText = message;
    [hud show:animated];
    [hud hide:animated afterDelay:delay];
}

- (BOOL)hadLoadedHUD {
    ESpaceProgressHUD *hud = [ESpaceProgressHUD HUDForView:self];
    if (hud) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showLoadingHUD:(NSString *)labelText animated:(BOOL)animated {
    ESpaceProgressHUD *hud = [ESpaceProgressHUD showHUDAddedTo:self animated:animated];
    hud.labelText = labelText;
}

- (void)hideHUD:(BOOL)animated {
    [ESpaceProgressHUD hideHUDForView:self animated:animated];
}

- (ESpaceProgressHUD *)HUDView {
    return [ESpaceProgressHUD HUDForView:self];
}

- (void)hideHUDAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    [[self HUDView] hide:animated afterDelay:delay];
}

@end
