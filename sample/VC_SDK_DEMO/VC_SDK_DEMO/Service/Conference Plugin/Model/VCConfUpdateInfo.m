//
//  VCConfUpdateInfo.m
//  VC_SDK_DEMO
//
//  Created by 毛建成 on 2017/12/29.
//  Copyright © 2017年 cWX160907. All rights reserved.
//

#import "VCConfUpdateInfo.h"

@implementation VCConfUpdateInfo

+(VCConfUpdateInfo *)returnVCConfInfoWith:(TE_ATTENDEE_DATA_IN_LIST *)attendeeList
{
    VCConfUpdateInfo *updateInfo = [[VCConfUpdateInfo alloc]init];
    updateInfo.ucM = attendeeList->ucM;
    updateInfo.ucT = attendeeList->ucT;
    updateInfo.aucName = [NSString stringWithUTF8String:attendeeList->aucName];
    updateInfo.aucNumber = [NSString stringWithUTF8String:attendeeList->aucNumber];
    updateInfo.udwUnJoinReason = attendeeList->udwUnJoinReason;
    updateInfo.uwAutoViewSeq = attendeeList->uwAutoViewSeq;
    updateInfo.uwAutoBroadSeq = attendeeList->uwAutoBroadSeq;
    updateInfo.ucAutoView = attendeeList->ucAutoView;
    updateInfo.ucAutoBroad = attendeeList->ucAutoBroad;
    updateInfo.ucSiteNum = attendeeList->ucSiteNum;
    updateInfo.ucIsUsed = attendeeList->ucIsUsed;
    updateInfo.ucJoinConf = attendeeList->ucJoinConf;
    updateInfo.ucType = attendeeList->ucType;
    updateInfo.ucIsPSTN = attendeeList->ucIsPSTN;
    updateInfo.ucGetName = attendeeList->ucGetName;
    updateInfo.ucGetNumber = attendeeList->ucGetNumber;
    updateInfo.ucMute = attendeeList->ucMute;
    updateInfo.ucReqTalk = attendeeList->ucReqTalk;
    updateInfo.ucTPMain = attendeeList->ucTPMain;
    updateInfo.ucScreenNum = attendeeList->ucScreenNum;
    updateInfo.ucHasRefresh = attendeeList->ucHasRefresh;
    updateInfo.ucChair = attendeeList->ucChair;
    updateInfo.ucLocalMute = attendeeList->ucLocalMute;
    return updateInfo;
}
@end

@implementation ConfCtrlSpeaker


@end
