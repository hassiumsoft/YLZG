//
//  WorkAssistTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfoModel.h"

@interface WorkAssistTableCell : UITableViewCell

@property (strong,nonatomic) LoginInfoModel *loginModel;

+ (instancetype)sharedWorkAssistCell:(UITableView *)tableView;

@end
