//
//  DongtaiListTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/1/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayDongtaiModel.h"

@interface DongtaiListTableCell : UITableViewCell


@property (strong,nonatomic) TodayDongtaiModel *detialModel;

//@property (copy,nonatomic) void (^ClickFileBlock)();

+ (instancetype)sharedDongtaiListCell:(UITableView *)tableView;

@end
