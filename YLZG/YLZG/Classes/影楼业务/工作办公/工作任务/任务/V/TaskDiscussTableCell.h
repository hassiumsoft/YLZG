//
//  TaskDiscussTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetialDiscussModel.h"

@interface TaskDiscussTableCell : UITableViewCell

@property (strong,nonatomic) TaskDetialDiscussModel *discussModel;

@property (copy,nonatomic) void (^DidBlock)(NSInteger am_type);

+ (instancetype)sharedTaskDiscussCell:(UITableView *)tableView;

@end
