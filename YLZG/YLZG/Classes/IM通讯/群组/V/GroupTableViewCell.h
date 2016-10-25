//
//  GroupTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLGroup.h"

@interface GroupTableViewCell : UITableViewCell

@property (strong,nonatomic) YLGroup *model;

+ (instancetype)sharedGroupTableViewCell:(UITableView *)tableView;

@end
