//
//  TeamPaihangbangTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamPaihangbangModel.h"

@interface TeamPaihangbangTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * iconImageV;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) TeamPaihangbangModel * model;

+ (instancetype)sharedTeamPaihangbangTableViewCell:(UITableView *)tableView;

@end
