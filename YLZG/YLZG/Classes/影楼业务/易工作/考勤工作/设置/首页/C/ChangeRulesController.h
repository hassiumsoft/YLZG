//
//  ChangeRulesController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/8.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "KaoqinModel.h"

@interface ChangeRulesController : SuperViewController

/** 大模型 */
@property (strong,nonatomic) KaoqinModel *model;

/** 考勤组名称 */
@property (copy,nonatomic) NSString *name;
/** 考勤类型 */
@property (copy,nonatomic) NSString *type;
/** 管理员json数组 */
@property (copy,nonatomic) NSString *adminArrJson;
/** 考勤组成员json数组 */
@property (copy,nonatomic) NSString *memArrJson;

/** 排班制时用到的员工数组 */
@property (strong,nonatomic) NSArray *staffArray;

@end
