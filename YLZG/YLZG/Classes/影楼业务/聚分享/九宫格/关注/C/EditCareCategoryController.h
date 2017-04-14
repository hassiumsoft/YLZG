//
//  EditCareCategoryController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


@interface EditCareCategoryController : SuperViewController


/**
 告诉上个界面刷新数据
 */
@property (copy,nonatomic) void (^SelectBlock)();

@end
