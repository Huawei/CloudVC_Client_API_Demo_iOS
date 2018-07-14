//
//  CallRingMode.h
//  VC_SDK_DEMO
//
//  Created by tupservice on 2018/1/19.
//  Copyright © 2018年 cWX160907. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallRingMode : NSObject
+ (instancetype)shareInstace;
- (void)playRing;
- (void)stopRing;

@end
