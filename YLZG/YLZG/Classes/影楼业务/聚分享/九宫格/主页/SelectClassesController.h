//
//  SelectClassesController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/3/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "TeamClassModel.h"

@interface SelectClassesController : SuperViewController

@property (copy,nonatomic) void (^SelectClassBlock)(TeamClassModel *model);

@end
