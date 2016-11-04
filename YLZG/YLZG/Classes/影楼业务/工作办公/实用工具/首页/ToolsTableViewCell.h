//
//  ToolsTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsModel.h"

@interface ToolsTableViewCell : UITableViewCell

@property (strong,nonatomic) ToolsModel *model;

+ (instancetype)sharedToolsCell:(UITableView *)tableView;

@property (copy,nonatomic) void (^DidSelectBlock)();

@end
