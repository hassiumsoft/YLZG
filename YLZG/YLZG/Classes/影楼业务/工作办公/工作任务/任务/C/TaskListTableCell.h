//
//  TaskListTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListModel.h"

@interface TaskListTableCell : UITableViewCell

@property (strong,nonatomic) TaskListModel *model;

+ (instancetype)sharedTaskListTableCell:(UITableView *)tableView;

@end
