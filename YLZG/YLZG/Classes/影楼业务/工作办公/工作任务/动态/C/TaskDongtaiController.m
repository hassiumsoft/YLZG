//
//  TaskDongtaiController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDongtaiController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "DongtaiListModel.h"
#import <MJRefresh.h>
#import "ProduceDetialVController.h"
#import "NormalIconView.h"
#import "ShowBigImgVController.h"
#import "HomeNavigationController.h"
#import "DongtaiListTableCell.h"
#import <Masonry.h>

@interface TaskDongtaiController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation TaskDongtaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DongtaiListModel *listModel = self.array[section];
    return listModel.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DongtaiListModel *listModel = self.array[indexPath.section];
    TodayDongtaiModel *detial = listModel.lists[indexPath.row];
    DongtaiListTableCell *cell = [DongtaiListTableCell sharedDongtaiListCell:tableView];
    cell.detialModel = detial;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    DongtaiListModel *listModel = self.array[section];
    
    NSString *time = [listModel.date substringWithRange:NSMakeRange(5, 5)];
    
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor whiteColor];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, 3, 50, 28)];
    dateLabel.text = time;
    dateLabel.backgroundColor = MainColor;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.layer.masksToBounds = YES;
    dateLabel.layer.cornerRadius = 10;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [footV addSubview:dateLabel];
    return footV;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark - 获取数据
- (void)getData
{
    NSString *today = [self getCurrentTime];
//    NSString *testDate = @"2016-11-15";
    NSString *url = [NSString stringWithFormat:TaskDongtai_Url,[ZCAccountTool account].userID,today];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int isEnd = [[[responseObject objectForKey:@"isEnd"] description] intValue];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            self.array = [DongtaiListModel mj_objectArrayWithKeyValuesArray:result];
            
            if (isEnd == 1) {
                // 还有更多记录？   1 没有了   0有
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [self CreateEmptyView:@"近三天内没有动态"];
            }
            [self.tableView reloadData];
        }else{
            [self CreateEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)CreateEmptyView:(NSString *)message
{
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 109)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

@end
