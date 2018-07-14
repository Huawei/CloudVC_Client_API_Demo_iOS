//
//  ConfCameraInfo.m
//  VTMIOSSDK
//
//  Created by applehw on 13-11-22.
//  Copyright (c) 2013年 huawei. All rights reserved.
//

#import "ConfCameraInfo.h"

@implementation ConfCameraInfo

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
-(NSString*)description
{
    NSString *descriptionStr = [NSString stringWithFormat:@"CameraInfo: userId=%u,deviceId=%u,cameraName=%@,videoView=%p",self.userId,self.deviceId,self.cameraName,self.videoView];
    return descriptionStr;
}

-(void)dealloc
{
    self.cameraName = nil;
    self.videoView = nil;
}
@end
