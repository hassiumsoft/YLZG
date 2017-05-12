//
//  GroupTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLGroup.h"

@interface GroupTableViewCell : UITableViewCell

/** 群聊信息 */
@property (strong,nonatomic) YLGroup *model;
/** 初始化 */
+ (instancetype)sharedGroupTableViewCell:(UITableView *)tableView;

@end
