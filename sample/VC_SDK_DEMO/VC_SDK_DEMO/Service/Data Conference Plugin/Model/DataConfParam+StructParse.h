//
//  DataConfParam+StructParse.h
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "DataConfParam.h"
#import "tup_confctrl_def.h"

@interface DataConfParam (StructParse)
/**
 *This method is used to transform CONFCTRL_S_DATACONF_PARAMS data to DataConfParam data;
 *将CONFCTRL_S_DATACONF_PARAMS数据结构 转换成 DataConfParam实例
 *@param confParam CONFCTRL_S_DATACONF_PARAMS
 *@return DataConfParam
 */
+ (DataConfParam *)transformFromTupStruct:(CONFCTRL_S_DATACONF_PARAMS *)confParam;

@end
