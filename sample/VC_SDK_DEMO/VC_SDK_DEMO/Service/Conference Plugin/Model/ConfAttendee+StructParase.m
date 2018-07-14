//
//  ConfAttendee+StructParase.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ConfAttendee+StructParase.h"

@implementation ConfAttendee (StructParase)

/**
 *This method is used to parse C struct CONFCTRL_S_ATTENDEE to instance of class ConfAttendee
 *将头文件的结构体CONFCTRL_S_ATTENDEE转换为类ConfAttendee的实例
 */
+(ConfAttendee *)returnConfAttendeeWith:(CONFCTRL_S_ATTENDEE)attendee
{
    ConfAttendee *confAttendee = [[ConfAttendee alloc] init];
    confAttendee.name = [NSString stringWithUTF8String:attendee.name];
    confAttendee.number = [NSString stringWithUTF8String:attendee.number];
    confAttendee.email = [NSString stringWithUTF8String:attendee.email];
    confAttendee.sms = [NSString stringWithUTF8String:attendee.sms];
    confAttendee.is_mute = attendee.is_mute;
    confAttendee.role = (CONFCTRL_CONF_ROLE)attendee.role;
    confAttendee.type = (CONFCTRL_ATTENDEE_TYPE)attendee.type;
    return confAttendee;
}
@end
