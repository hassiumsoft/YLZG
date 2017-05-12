//
//  SelectContacterCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"

@interface SelectContacterCell : UITableViewCell

@property (strong,nonatomic) ContactersModel *model;

+ (instancetype)sharedMutliChoceStaffCell:(UITableView *)tableView;

@end
