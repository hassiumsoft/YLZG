//
//  TaskRecordTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetialDynamicModel.h"

@interface TaskRecordTableCell : UITableViewCell

/** 动态记录模型 */
@property (strong,nonatomic) TaskDetialDynamicModel *dynamicModel;

+ (instancetype)sharedTaskRecordTableCell:(UITableView *)tableView;

@end
