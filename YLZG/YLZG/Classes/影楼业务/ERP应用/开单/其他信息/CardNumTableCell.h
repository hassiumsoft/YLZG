//
//  CardNumTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrderCardModel.h"

@interface CardNumTableCell : UITableViewCell

@property (strong,nonatomic) OpenOrderCardModel *model;

+ (instancetype)sharedCardNumTableCell:(UITableView *)tableView;

@end
