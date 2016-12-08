//
//  TeamUsedTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamUsedModel.h"
#import "MyUsedModel.h"
#import "MyMobanModel.h"

/********* 团队已用 ***********/

@interface TeamUsedTableCell : UITableViewCell


@property (strong,nonatomic) TeamUsedModel *teamUsedModel;

@property (strong,nonatomic) MyUsedModel *myUsedModel;

@property (strong,nonatomic) MyMobanModel *myMobanModel;

+ (instancetype)sharedTeamUsedTableCell:(UITableView *)tableView;

@end
