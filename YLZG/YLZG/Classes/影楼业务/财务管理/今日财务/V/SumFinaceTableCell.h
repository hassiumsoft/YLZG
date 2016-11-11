//
//  SumFinaceTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayFinaceModel.h"

@interface SumFinaceTableCell : UITableViewCell

@property (strong,nonatomic) TodayFinaceModel *model;

+ (instancetype)sharedSumFinaceTableCell:(UITableView *)tableView;

@end
