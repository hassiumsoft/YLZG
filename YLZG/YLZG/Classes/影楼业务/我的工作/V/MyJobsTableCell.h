//
//  MyJobsTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyjobModel.h"

@interface MyJobsTableCell : UITableViewCell

@property (strong,nonatomic) MyjobModel *model;

+ (instancetype)sharedMyJobsTableCell:(UITableView *)tableView;

@end
