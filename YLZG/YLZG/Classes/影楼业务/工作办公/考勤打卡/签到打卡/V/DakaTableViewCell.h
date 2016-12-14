//
//  DakaTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayDakaRuleModel.h"

@interface DakaTableViewCell : UITableViewCell

@property (strong,nonatomic) TodayDakaRuleModel *ruleModel;

+ (instancetype)sharedDakaTableViewCell:(UITableView *)tableView;


@end
