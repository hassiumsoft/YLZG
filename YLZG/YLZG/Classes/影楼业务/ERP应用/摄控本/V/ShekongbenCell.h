//
//  ShekongbenCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShekongbenModel.h"

@interface ShekongbenCell : UITableViewCell

@property (strong,nonatomic) ShekongbenModel *model;

+ (instancetype)sharedShekongbenCell:(UITableView *)tableView;

@end
