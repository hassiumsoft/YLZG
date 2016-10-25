//
//  MineKaoqinTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineKaoqinTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * dateLabel;
// 迟到的时间数
@property (nonatomic, strong) UILabel * timeLabel;

+ (instancetype)sharedMineKaoqinTableViewCell:(UITableView *)tableView;

@end
