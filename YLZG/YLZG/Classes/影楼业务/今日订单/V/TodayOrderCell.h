//
//  TodayOrderCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/27.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayOrderModel.h"

@protocol TodayOrderCellDelegate <NSObject>

- (void)openPhoneWebView:(TodayOrderModel *)model;

@end

@interface TodayOrderCell : UITableViewCell

/** 订单ID */
@property (strong,nonatomic) UILabel *orderLabel;
/** 顾客 */
@property (strong,nonatomic) UILabel *guestLabel;

/** 套系 */
@property (nonatomic, strong) UILabel * setLabel;
/** 价格 */
@property (nonatomic, strong) UILabel * priceLabel;
/** 门市(开单员工) */
@property (nonatomic, strong) UILabel * storeLabel;
/** 时间 */
@property (nonatomic, strong) UILabel * dateLabel;




///** 拨打电话 */
@property (strong,nonatomic) UIButton *callBtn;
///** 代理 */
@property (weak,nonatomic) id<TodayOrderCellDelegate> delegate;

/** 模型 */
@property (strong,nonatomic) TodayOrderModel *model;

+ (instancetype)sharedTodayOrderCell:(UITableView *)tableView;

@end
