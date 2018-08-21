//
//  UIImage+Stretchable.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//
#import <UIKit/UIKit.h>
#import "Defines.h"

@interface UIImage (Stretchable)

+ (UIImage *)stretchableImageNamed:(NSString *)imageName;
+ (UIImage *)stretchableImageNamed:(NSString *)imageName relativeImageWidth:(double)width relativeImageHeight:(double)height;
+ (UIImage *)stretchableImageNamed:(NSString *)imageName withLeftCapWidth:(NSInteger)width topCapHeight:(NSInteger)height;

@end
