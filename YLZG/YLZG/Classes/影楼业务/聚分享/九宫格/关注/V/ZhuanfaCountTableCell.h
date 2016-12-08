//
//  ZhuanfaCountTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanfaListModel.h"

@interface ZhuanfaCountTableCell : UITableViewCell

@property (strong,nonatomic) ZhuanfaListModel *model;

+ (instancetype)sharedZhuanfaCountCell:(UITableView *)tableView;

@end
