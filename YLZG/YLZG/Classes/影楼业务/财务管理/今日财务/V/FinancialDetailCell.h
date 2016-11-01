//
//  FinancialDetailCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//
/**
 "info" : "预约补款：20100511-003;张三;客户:zsls,王五",
 "money" : "1000",
 "payee" : ">管理员",
 "time" : "2016-01-23 14:41:45"
 */

#import <UIKit/UIKit.h>
#import "FinacialDetailModel.h"

@interface FinancialDetailCell : UITableViewCell




@property (nonatomic, strong) FinacialDetailModel * model;
@property (nonatomic, strong) UIImageView * iconImageV;
// 时间
@property (nonatomic, strong) UILabel * timeLabel;
// 店员名字
@property (nonatomic, strong) UILabel * payeeLabel;

/** 后台未返回 */
// 顾客姓名
@property (nonatomic, strong) UILabel * guestLabel;

// 生活支出
@property (nonatomic, strong) UILabel * moneyLabel;

+ (instancetype)sharedFinancialDetailCell:(UITableView *)tableView;

@end
