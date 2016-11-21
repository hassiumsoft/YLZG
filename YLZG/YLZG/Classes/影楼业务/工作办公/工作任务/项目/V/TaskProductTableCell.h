//
//  TaskProductTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskProduceListModel.h"

@interface TaskProductTableCell : UITableViewCell

@property (strong,nonatomic) TaskProduceListModel *proModel;

+ (instancetype)sharedTaskProductCell:(UITableView *)tableView;

@end
