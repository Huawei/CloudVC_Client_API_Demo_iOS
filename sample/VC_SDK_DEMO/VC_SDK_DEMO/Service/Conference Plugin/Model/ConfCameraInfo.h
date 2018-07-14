//
//  ConfCameraInfo.h
//  VTMIOSSDK
//
//  Created by applehw on 13-11-22.
//  Copyright (c) 2013年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tup_def.h"

@interface ConfCameraInfo : NSObject

@property (nonatomic) TUP_UINT32 userId;
@property (nonatomic) TUP_UINT32 deviceId;
@property (nonatomic, retain) NSString *cameraName;
@property (nonatomic, strong) id videoView;

@end
