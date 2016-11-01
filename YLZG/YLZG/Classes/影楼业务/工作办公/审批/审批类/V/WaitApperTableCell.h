//
//  WaitApperTableCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/21.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveModel.h"

@interface WaitApperTableCell : UITableViewCell


@property (strong,nonatomic) ApproveModel *model;

+ (instancetype)sharedWaitApperTableCell:(UITableView *)tableView;

@end
