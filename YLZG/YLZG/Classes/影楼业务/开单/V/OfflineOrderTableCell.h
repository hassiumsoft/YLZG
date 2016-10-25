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

@class OfflineOrderTableCell;

@protocol OfflineOrderCellDelegate <NSObject>
/** 为了检测是否全选的按钮状态 */
- (void)offLineOrderCell:(OfflineOrderTableCell *)offCell;

@end


@interface OfflineOrderTableCell : UITableViewCell

/** 模型 */
@property (strong,nonatomic) OffLineOrder *model;

/** 客户名字 */
@property (strong,nonatomic) UILabel *cusNameLabel;
/** 客户电话 */
@property (strong,nonatomic) UILabel *cusPhoneLabel;
/** 套系名称等等 */
@property (strong,nonatomic) UILabel *taoxiLabel;
/** 价格 */
@property (strong,nonatomic) UILabel *priceLabel;
/** 选择按钮 */
@property (strong,nonatomic) UIButton *selectedBtn;
/** 备注 */
@property (strong,nonatomic) UILabel *beizhuLabel;
/** 保存时间 */
@property (strong,nonatomic) UILabel *timeLabel;


@property (weak,nonatomic) id<OfflineOrderCellDelegate> delegate;

/** 初始化 */
+ (instancetype)sharedOfflineOrderCell:(UITableView *)tableView;


@end
