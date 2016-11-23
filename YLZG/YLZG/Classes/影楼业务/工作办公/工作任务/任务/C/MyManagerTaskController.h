//
//  MyManagerTaskController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface MyManagerTaskController : SuperViewController

/** 今后的任务 */
@property (copy,nonatomic) NSArray *laterArray;
/** 今天的任务 */
@property (copy,nonatomic) NSArray *todayArray;


@end
