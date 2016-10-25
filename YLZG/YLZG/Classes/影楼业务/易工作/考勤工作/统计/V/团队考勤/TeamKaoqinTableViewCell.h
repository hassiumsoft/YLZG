//
//  TeamKaoqinTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeptTeamKaoqinModel.h"

@interface TeamKaoqinTableViewCell : UITableViewCell

@property (nonatomic, strong) DeptTeamKaoqinModel * model;
// cell白色底部
@property (nonatomic, strong) UIView * whiteView;
// 部门名称
@property (nonatomic, strong) UILabel * departLabel;
// 应到
@property (nonatomic, strong) UILabel * shouldLabel;
// 实到
@property (nonatomic, strong) UILabel * realLabel;

+ (instancetype)sharedTeamKaoqinTableViewCell:(UITableView *)tableView;

@end
