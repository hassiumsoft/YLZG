//
//  ApproveListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ApproveListViewController.h"
#import "ApproveModel.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "NormalIconView.h"
#import "WaitApperTableCell.h"
#import "ApproveDetialViewController.h"
#import <Masonry.h>


@interface ApproveListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** UITableView */
@property (strong,nonatomic) UITableView *tableView;
/** 空图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;

@end

@implementation ApproveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YLNotificationCenter addObserver:self selector:@selector(refreshData) name:YLReloadShenpiData object:nil];
    [self setupSubViews];
}

- (void)refreshData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url;
    if (self.index == 0) {
        url = [NSString stringWithFormat:ShenpiWait_URL,account.userID];
    }else if (self.index == 1){
        url = [NSString stringWithFormat:ShenpiAlready_URL,account.userID];
    }else{
        url = [NSString stringWithFormat:ShenpiStart_URL,account.userID];
    }
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *tempArray = [responseObject objectForKey:@"result"];
            if (tempArray.count >= 1) {
                
                [self.array removeAllObjects];
                self.array = [ApproveModel mj_objectArrayWithKeyValuesArray:tempArray];
                if (_RefreshData) {
                    _RefreshData(self.array);
                }
                
                [self.tableView reloadData];
            }else{
                [self loadEmptyView:@"暂无审批"];
            }
        }else{
            [self loadEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self loadEmptyView:error.localizedDescription];
    }];
}

#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn = [NormalIconView sharedHomeIconView];
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.numberOfLines = 0;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.emptyBtn];
    
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}


#pragma mark - UI视图
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    if (self.array.count >= 1) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
        }];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaitApperTableCell *cell = [WaitApperTableCell sharedWaitApperTableCell:tableView];
    ApproveModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApproveModel *model = self.array[indexPath.row];
    ApproveDetialViewController *waitAppro = [[ApproveDetialViewController alloc]init];
    waitAppro.ReloadBlock = ^(){
        [self refreshData];
    };
    waitAppro.model = model;
    if (self.index == 0) {
        waitAppro.titleStr = @"待我审核";
        waitAppro.isMe = NO;
    }else if (self.index == 1){
        waitAppro.titleStr = @"我已审核";
        waitAppro.haveShenpi = YES;
        waitAppro.isMe = NO;
    }else{
        waitAppro.titleStr = @"我发起的请求";
        waitAppro.isMe = YES;
    }
    [self.navigationController pushViewController:waitAppro animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


@end
