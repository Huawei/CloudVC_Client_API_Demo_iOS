//
//  CallHistoryCell.h
//  EC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>
@class TupHistory;
@interface CallHistoryCell : UITableViewCell
@property (nonatomic, strong)TupHistory *callLogMessage;    // current call log message
@end
