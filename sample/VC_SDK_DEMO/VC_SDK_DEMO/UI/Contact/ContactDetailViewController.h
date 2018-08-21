//
//  ContactDetailViewController.h
//  VC_SDK_DEMO
//
//  Created by tupservice on 2018/1/5.
//  Copyright © 2018年 cWX160907. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuaweiSDKService/TupContactsSDK.h"
@interface ContactDetailViewController : UITableViewController
@property(nonatomic,strong)TupContact *contact;
@end
