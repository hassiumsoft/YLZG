//
//  TeamZhengchangTableCell.h
//  NewHXDemo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamZhengchangdakaModel.h"

@interface TeamZhengchangTableCell : UITableViewCell

@property (nonatomic, strong) TeamZhengchangdakaModel * model;
@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UILabel * nameLabel;
//@property (nonatomic, strong) UILabel * deptLabel;


+ (instancetype)sharedTeamZhengchangTableCell:(UITableView *)tableView;

@end
