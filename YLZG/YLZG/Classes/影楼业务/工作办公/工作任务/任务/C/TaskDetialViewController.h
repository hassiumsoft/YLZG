//
//  TaskDetialViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "TaskListModel.h"


typedef void(^CompleteBlock)();

@interface TaskDetialViewController : SuperViewController

@property (strong,nonatomic) TaskListModel *listModel;


@end
