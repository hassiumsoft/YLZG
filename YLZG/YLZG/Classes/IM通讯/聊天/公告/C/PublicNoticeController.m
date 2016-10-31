//
//  PublicNoticeController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PublicNoticeController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "NoticeModel.h"
#import "NoticeTableCell.h"
#import "NoticeDetialView.h"
#import <Masonry.h>
#import "NormalIconView.h"
#import "NoticeManager.h"
#import "FabuViewController.h"
#import "ClearCacheTool.h"


@interface PublicNoticeController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) UIButton *mengBtn;

@property (strong,nonatomic) NormalIconView *emptyBtn;

@property (strong,nonatomic) NoticeDetialView *noticeDetialV;

@end

@implementation PublicNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影楼公告";
    
    [self setupSubViews];
}


#pragma mark - 表格相关
- (void)setupSubViews
{
    NSString *path = [ClearCacheTool homePath];
    NSLog(@"path = %@",path);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    NSArray *array = [NoticeManager getAllNoticeInfo];
    if (array.count >= 1) {
        // 有缓存
        self.array = [NoticeManager getAllNoticeInfo];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_ReloadBlock) {
                _ReloadBlock();
            }
            [self loadData];
        }];
        [self.tableView reloadData];
        
    }else{
        // 没有缓存，去加载
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
}
- (void)loadData
{
    NSString *url = [NSString stringWithFormat:QueryGongao,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (status == 1) {
            NSArray *tempArr = [responseObject objectForKey:@"result"];
            if (_ReloadBlock) {
                _ReloadBlock();
            }
            if (tempArr.count >= 1) {
                self.array = [NoticeModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.tableView reloadData];
                [NoticeManager deleteAllInfo];
                for (int i = 0; i < self.array.count; i++) {
                    NoticeModel *model = self.array[i];
                    [NoticeManager saveAllNoticeWithNoticeModel:model];
                }
                
            }else{
                [self loadEmptyView:@"暂无公告，点击右侧发布第一条公告吧。"];
            }
        }else{
            [self loadEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self loadEmptyView:error.localizedDescription];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeModel *model = self.array[indexPath.row];
    NoticeTableCell *cell = [NoticeTableCell sharedNoticeTableCell:tableView];
    cell.model = model;
    if (indexPath.row == 1) {
        cell.imageV.image = [UIImage imageNamed:@"gonggao_newest"];
    }
    return cell;
    
}
#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeModel *model = self.array[indexPath.row];
    
    self.mengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mengBtn setFrame:self.view.window.bounds];
    self.mengBtn.backgroundColor = RGBACOLOR(79, 79, 109, 0.8);
    [self.mengBtn addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mengBtn];
    
    NoticeDetialView *noticeDetialV = [NoticeDetialView sharedNoticeDetialView];
    noticeDetialV.model = model;
    [self.view.window addSubview:noticeDetialV];
    [noticeDetialV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(28);
        make.height.equalTo(@380);
    }];
    self.noticeDetialV = noticeDetialV;
    
}
- (void)removeButton
{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"suckEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    [self.mengBtn removeFromSuperview];
    [self.noticeDetialV removeFromSuperview];
}

#pragma mark - 其他设置
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 153 + 内容高度
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    foot.backgroundColor = NorMalBackGroudColor;
    return foot;
}

- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_fabubianji"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender {
    FabuViewController * helpVC = [[FabuViewController alloc] init];
    helpVC.FabuSuccessBlock = ^(){
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mengBtn removeFromSuperview];
    [self.noticeDetialV removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNav];
}


@end
