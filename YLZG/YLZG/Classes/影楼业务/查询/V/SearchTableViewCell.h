//
//  SearchTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
////"guestname" : "zs/ls/王五",
//"phone" : "13656789865/18666532220",
//"tradeID" : "20100511-003"

#import <UIKit/UIKit.h>
#import "SearchViewModel.h"

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) SearchViewModel * model;

// 客人姓名
@property (nonatomic, strong) UILabel * guestnameLabel;
// 客人手机号
@property (nonatomic, strong) UILabel * phoneLabel;
// 套系名称
@property (strong,nonatomic) UILabel *setLabel;
// 门店负责人
@property (strong,nonatomic) UILabel *storeLabel;
// 价格
@property (strong,nonatomic) UILabel *proceLabel;
// 订单号
@property (strong,nonatomic) UILabel *orderIDLabel;


+ (instancetype)sharedSearchTableViewCell:(UITableView *)tableView;


@end
