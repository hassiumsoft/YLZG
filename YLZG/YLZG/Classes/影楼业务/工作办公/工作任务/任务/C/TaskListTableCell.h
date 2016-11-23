//
//  TaskListTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListModel.h"
#import "ProduceTaskModel.h"

@interface TaskListTableCell : UITableViewCell

/** 在任务列表里 */
@property (strong,nonatomic) TaskListModel *taskListmodel;
/** 在任务详情列表里 */
@property (strong,nonatomic) ProduceTaskModel *produceDetialModel;

+ (instancetype)sharedTaskListTableCell:(UITableView *)tableView;

@end
