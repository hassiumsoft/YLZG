//
//  SelectTaskFuzerController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "StaffInfoModel.h"

@interface SelectTaskFuzerController : SuperViewController

@property (copy,nonatomic) void (^SelectBlock)(StaffInfoModel *model);

@end
