//
//  MutliChoceStaffCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffInfoModel.h"

@interface MutliChoceStaffCell : UITableViewCell

@property (strong,nonatomic) UIButton *selectedBtn;

@property (strong,nonatomic) UIImageView *headImageV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *deptLabel;

@property (strong,nonatomic) StaffInfoModel *model;

+ (instancetype)sharedMutliChoceStaffCell:(UITableView *)tableView;

@end
