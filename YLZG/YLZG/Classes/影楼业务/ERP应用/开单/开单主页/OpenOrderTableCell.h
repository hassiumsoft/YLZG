//
//  OpenOrderTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenOrderTableCell : UITableViewCell


/** 名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;

+ (instancetype)sharedOpenOrderTableCell:(UITableView *)tableView;

@end
