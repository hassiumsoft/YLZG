//
//  AllQiaodaoDetailViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllQiaodaoDetailModel.h"

@interface AllQiaodaoDetailViewCell : UITableViewCell

@property (nonatomic, strong) AllQiaodaoDetailModel * model;
@property (nonatomic, strong) UIImageView * headImageV;
@property (nonatomic, strong) UILabel * realnameLabel;
@property (nonatomic, strong) UILabel * intimeLabel;
@property (nonatomic, strong) UIButton * addressBtn;

+ (instancetype)sharedAllQiaodaoDetailViewCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
