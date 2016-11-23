//
//  ProduceDetialDiscussCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceDiscussModel.h"

@interface ProduceDetialDiscussCell : UITableViewCell

@property (strong,nonatomic) ProduceDiscussModel *discussModel;

+ (instancetype)sharedDetialDiscussCell:(UITableView *)tableView;

@end
