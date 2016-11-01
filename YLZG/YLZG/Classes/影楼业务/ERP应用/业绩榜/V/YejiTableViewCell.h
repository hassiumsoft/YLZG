//
//  YejiTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffYejiModel.h"

@interface YejiTableViewCell : UITableViewCell

@property (strong,nonatomic) StaffYejiModel *model;

+ (instancetype)sharedYejiTableViewCell:(UITableView *)tableView;

@end
