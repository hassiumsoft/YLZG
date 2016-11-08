//
//  MutableSpotTableCell.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutableSelectedModel.h"

@interface MutableSpotTableCell : UITableViewCell

@property (strong,nonatomic) UIButton *selectBtn;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) MutableSelectedModel *model;

+ (instancetype)sharedMutableSpotTableCell:(UITableView *)tableView;

@end
