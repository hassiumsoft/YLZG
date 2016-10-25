//
//  NormalTableCell.h
//  佛友圈
//
//  Created by Chan_Sir on 16/1/16.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableCell : UITableViewCell

@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIView *xian;
+ (instancetype)sharedNormalTableCell:(UITableView *)tableView;

@end
