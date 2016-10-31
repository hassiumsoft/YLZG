//
//  EaseRefreshTableViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

#define KCELLDEFAULTHEIGHT 50

@interface EaseRefreshTableViewController : SuperViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}

@property (strong, nonatomic) NSArray *rightItems;
@property (strong, nonatomic) UIView *defaultFooterView;
@property (strong, nonatomic) UITableView *tableView;

/** 数据源 */
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic) int page;

@property (nonatomic) BOOL showRefreshHeader;//是否支持下拉刷新
@property (nonatomic) BOOL showRefreshFooter;//是否支持上拉加载
@property (nonatomic) BOOL showTableBlankView;//是否显示无数据时默认背景

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;//下拉刷新事件
- (void)tableViewDidTriggerFooterRefresh;//上拉加载事件

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
