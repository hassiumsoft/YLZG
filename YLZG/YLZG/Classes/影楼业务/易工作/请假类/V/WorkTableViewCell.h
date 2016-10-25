//
//  WorkTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *label;

@property (strong,nonatomic) UILabel *infoLabel;

+ (instancetype)sharedWorkCell:(UITableView *)tableView;

@end
