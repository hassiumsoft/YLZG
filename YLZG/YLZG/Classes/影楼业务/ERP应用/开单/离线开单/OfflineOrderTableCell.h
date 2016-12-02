//
//  OfflineOrderTableCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/24.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffLineOrder.h"


/*********** 离线订单的CELL **********/

@interface OfflineOrderTableCell : UITableViewCell

/** 模型 */
@property (strong,nonatomic) OffLineOrder *model;




/** 初始化 */
+ (instancetype)sharedOfflineOrderCell:(UITableView *)tableView;


@end
