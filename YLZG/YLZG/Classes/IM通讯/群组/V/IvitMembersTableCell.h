//
//  IvitMembersTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"

@interface IvitMembersTableCell : UITableViewCell

@property (strong,nonatomic) ContactersModel *model;

@property (strong,nonatomic) UIButton *selectBtn;

+ (instancetype)sharedIvitMembersTableCell:(UITableView *)tableView;

@end
