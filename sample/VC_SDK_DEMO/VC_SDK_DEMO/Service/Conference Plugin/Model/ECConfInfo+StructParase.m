//
//  ECSConfInfo+StructParase.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ECConfInfo+StructParase.h"
#import "CommonUtils.h"
#import "HuaweiSDKService/tup_confctrl_def.h"

@implementation ECConfInfo (StructParase)

/**
 *This method is used to parse C struct CONFCTRL_S_CONF_LIST_INFO to instance of class ECConfInfo
 *将头文件的结构体CONFCTRL_S_CONF_LIST_INFO转换为类ECConfInfo的实例
 */
+(ECConfInfo *)returnECConfInfoWith:(CONFCTRL_S_CONF_LIST_INFO)confListInfo
{
    ECConfInfo *ecConfInfo = [[ECConfInfo alloc] init];
    ecConfInfo.conf_id = [NSString stringWithUTF8String:confListInfo.conf_id];
    ecConfInfo.cycle_conf_id = [NSString stringWithUTF8String:confListInfo.cycle_conf_id];
    ecConfInfo.conf_subject = [NSString stringWithUTF8String:confListInfo.conf_subject];
    ecConfInfo.access_number = [NSString stringWithUTF8String:confListInfo.access_number];
    ecConfInfo.chairman_pwd = [NSString stringWithUTF8String:confListInfo.chairman_pwd];
    ecConfInfo.general_pwd = [NSString stringWithUTF8String:confListInfo.general_pwd];
    NSString *utcDataStartString = [NSString stringWithUTF8String:confListInfo.start_time];
    ecConfInfo.start_time = [CommonUtils getLocalDateFormateUTCDate:utcDataStartString];
    NSString *utcDataEndString = [NSString stringWithUTF8String:confListInfo.end_time];
    ecConfInfo.end_time = [CommonUtils getLocalDateFormateUTCDate:utcDataEndString];
    ecConfInfo.scheduser_number = [NSString stringWithUTF8String:confListInfo.scheduser_number];
    ecConfInfo.scheduser_name = [NSString stringWithUTF8String:confListInfo.scheduser_name];
    ecConfInfo.media_type = [self transformByUportalMediaType:confListInfo.media_type];
    ecConfInfo.conf_state = (CONF_E_CONF_STATE)confListInfo.conf_state;
    return ecConfInfo;
}

/**
 *This method is used to get EC_CONF_MEDIATYPE enum value by param mediaType
 *根据传入的会议类型int值获取会议类型枚举值
 */
+ (EC_CONF_MEDIATYPE)transformByUportalMediaType:(TUP_UINT32)mediaType {
    EC_CONF_MEDIATYPE type = CONF_MEDIATYPE_VOICE;
    switch (mediaType) {
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE:
            type = CONF_MEDIATYPE_VOICE;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO:
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO:
            type = CONF_MEDIATYPE_VIDEO;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
            type = CONF_MEDIATYPE_DATA;
            break;
            
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
        case CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE | CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA:
            type = CONF_MEDIATYPE_VIDEO_DATA;
            break;
            
        default:
            break;
    }
    return type;
}
@end
