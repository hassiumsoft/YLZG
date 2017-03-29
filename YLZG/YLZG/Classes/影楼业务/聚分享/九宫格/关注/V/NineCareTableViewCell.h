//
//  NineCareTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineHotCommentModel.h"
#import "TeamClassModel.h"

@interface NineCareTableViewCell : UITableViewCell

@property (strong,nonatomic) NineHotCommentModel *model;

@property (strong,nonatomic) TeamClassModel *teamClassModel;

+ (instancetype)sharedNineCell:(UITableView *)tableView;

@end
