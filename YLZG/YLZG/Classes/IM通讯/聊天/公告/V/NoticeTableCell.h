//
//  NoticeTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@interface NoticeTableCell : UITableViewCell

/** 置顶还是最新 */
@property (strong,nonatomic) UIImageView *imageV;

/** 公告模型 */
@property (strong,nonatomic) NoticeModel *model;

/** 初始化NoticeTableCell */
+ (instancetype)sharedNoticeTableCell:(UITableView *)tableView;

@end
