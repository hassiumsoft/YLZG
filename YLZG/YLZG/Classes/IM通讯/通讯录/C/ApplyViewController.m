//
//  ApplyViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ApplyViewController.h"
#import "ZCAccountTool.h"
#import "ApplyModel.h"
#import "HTTPManager.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ApplyTableViewCell.h"
#import "AddFriendViewController.h"
#import "UserInfoManager.h"
#import "UserInfoModel.h"
#import "ZCAccount.h"


static ApplyViewController *controller = nil;

@interface ApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//但是得状态是申请还是拒绝
@property (nonatomic,assign) int status;
//拼接网址的时候需要的参数
@property (nonatomic,copy) NSString *message;

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请通知";
    [self setupSubViews];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- UI创建
- (void)setupSubViews
{
    self.title = @"新的朋友";
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
#pragma mark -- 请求好友列表的数据请求
- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/get_msg?uid=%@",account.userID];
    
    UserInfoModel *myModel = [[UserInfoManager sharedManager] getUserInfo];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self.tableView.mj_header endRefreshing];
            
            [self.dataSource removeAllObjects];
            
            NSMutableArray *result = [responseObject objectForKey:@"result"];
            NSMutableArray *array = [ApplyModel mj_objectArrayWithKeyValuesArray:result];
            for (int i = 0; i < array.count; i++) {
                ApplyModel *model = array[i];
                if (![myModel.uid isEqualToString:model.auid]) {
                    [self.dataSource addObject:model];
                }
            }
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self showErrorTips:message];
            [self hideHud:1];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        KGLog(@"error = %@",error.localizedDescription);
    }];
}
#pragma mark -- 上传加的好友的数据
- (void)putData:(NSInteger)indexPathRow URL:(NSString *)url
{
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            [self hideHud:1];
            
            [self.dataSource removeObjectAtIndex:indexPathRow];
            [YLNotificationCenter postNotificationName:HXUpdataContacts object:nil];
            [YLNotificationCenter postNotificationName:HXSetupUntreatedApplyCount object:nil];
            [self.tableView reloadData];
            
        }else{
            [self showErrorTips:message];
            [self hideHud:1];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:1];
        KGLog(@"error = %@",error.localizedDescription);
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoModel *myModel = [[UserInfoManager sharedManager] getUserInfo];
    ApplyTableViewCell *cell = [ApplyTableViewCell sharedAddFriendTableViewCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell.xian removeFromSuperview];
    ApplyModel *applyModel = self.dataSource[indexPath.row];
    cell.aModel = applyModel;
    cell.agreeBtn = ^(BUTTON_FLAG flag){
        //添加好友
        if (flag == 0) {
            if (indexPath.row < [self.dataSource count]) {
                
                _status = 2;
                self.message = [NSString stringWithFormat:@"我是%@我同意添加好友",myModel.nickname];
            }
            
        }else if(flag == 1){
            
            self.message = [NSString stringWithFormat:@"我是%@我拒绝添加好友",myModel.nickname];
            _status = 3;
            [YLNotificationCenter postNotificationName:HXSetupUntreatedApplyCount object:nil];
        }
        NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/handle_ask?uid=%@&auid=%@&msg=%@&id=%@&status=%d",myModel.uid,applyModel.auid,self.message,applyModel.id,self.status];
        
        [self putData:indexPath.row URL:url];
        
        [YLNotificationCenter postNotificationName:HXSetupUntreatedApplyCount object:nil];
        
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma  mark -- UIBar的点击事件
- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}
#pragma mark -- 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 5) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -- 单例创建
+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}


@end
