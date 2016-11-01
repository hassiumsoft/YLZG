//
//  NoColorTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InComeModel.h"

@interface NoColorTableViewCell : UITableViewCell

@property (strong,nonatomic) InComeModel *model;

+ (instancetype)sharedNoColorTableViewCell:(UITableView *)tableView;

@end
