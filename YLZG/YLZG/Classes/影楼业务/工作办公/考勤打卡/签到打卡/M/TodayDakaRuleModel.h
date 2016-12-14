//
//  TodayDakaRuleModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/********* 今日打卡规则模型 *********/

@interface TodayDakaRuleModel : NSObject

/** 规则ID */
@property (copy,nonatomic) NSString *classid;
/** 班次名称 */
@property (copy,nonatomic) NSString *classname;
/** 上班时间 */
@property (copy,nonatomic) NSString *start;
/** 下班时间 */
@property (copy,nonatomic) NSString *end;

@end
