//
//  EditCareCategoryController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "EditCareCategoryController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "CareMobanModel.h"
#import "EditCareTableViewCell.h"


@interface EditCareCategoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation EditCareCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑关注";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getCareListAction];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    // 确定关注按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    [button setFrame:CGRectMake(20, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH - 40, 40)];
    [button setTitle:@"确定关注" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        // 提取被选中的
        NSMutableArray *selectArray = [NSMutableArray array];
        for (CareMobanModel *model in self.array) {
            if (model.status) {
                [selectArray addObject:model.id];
            }
        }
        
        if (selectArray.count < 1) {
            [MBProgressHUD showError:@"请点击选中"];
            return ;
        }
        
        NSString *careIDJson = [self toJsonStr:selectArray];
        NSString *url = [NSString stringWithFormat:NineCareEdit_Url,[ZCAccountTool account].userID,careIDJson];
        
        
        [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"]description];
            
            if (code == 1) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (self.SelectBlock) {
                        _SelectBlock();
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }else{
                [self sendErrorWarning:message];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
            [self sendErrorWarning:error.localizedDescription];
        }];
        
    }];
    [self.view addSubview:button];
    
}

- (void)getCareListAction
{
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.160/index.php/wei/retransmission/care_status?uid=%@",[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSArray *tempArray = [responseObject objectForKey:@"result"];
            self.array = [CareMobanModel mj_objectArrayWithKeyValuesArray:tempArray];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
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
    EditCareTableViewCell *cell = [EditCareTableViewCell sharedEditCareCell:tableView];
    CareMobanModel *model = self.array[indexPath.row];
    cell.careModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 0; i < self.array.count; i++) {
        CareMobanModel *careModel = self.array[i];
        if (indexPath.row == i) {
            if (careModel.status) {
                careModel.status = NO;
            }else{
                careModel.status = YES;
            }
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        
    }
    return _tableView;
}


@end
