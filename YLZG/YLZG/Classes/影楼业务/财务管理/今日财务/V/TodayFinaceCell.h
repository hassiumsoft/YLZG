//
//  TodayFinaceCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayFinaceDetialModel.h"

@interface TodayFinaceCell : UITableViewCell

@property (strong,nonatomic) TodayFinaceDetialModel *model;

+ (instancetype)sharedTodayFinaceCell:(UITableView *)tableView;

@end
