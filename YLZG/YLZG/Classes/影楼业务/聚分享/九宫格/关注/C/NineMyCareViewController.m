//
//  NineMyCareViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineMyCareViewController.h"
#import "NineCareTableViewCell.h"
#import "NineListViewController.h"
#import "HTTPManager.h"
#import "NineCareModel.h"
#import <MJExtension.h>
#import "EditCareCategoryController.h"
#import "ZCAccountTool.h"
#import <MJRefresh.h>
#import "TeamClassListViewController.h"



@interface NineMyCareViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation NineMyCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)editAction
{
    EditCareCategoryController *editVC = [EditCareCategoryController new];
    editVC.listModel = self.listModel;
    editVC.SelectBlock = ^(){
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)getData
{
    NSString *url = [NSString stringWithFormat:NineCareList_Url,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            
            NineCareModel *teamCare = [NineCareModel new];
            teamCare.id = @"group";
            teamCare.name = @"团队制作";
            teamCare.thumb = @"moban_team";
            
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                self.array = [NineCareModel mj_objectArrayWithKeyValuesArray:result];
                [self.array insertObject:teamCare atIndex:0];
                [self.tableView reloadData];
            }else{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有关注分类模板" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"添加关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self editAction];
                }];
                
                
                [alertC addAction:action1];
                [alertC addAction:action2];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NineCareTableViewCell *cell = [NineCareTableViewCell sharedNineCell:tableView];
    cell.model = self.array[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NineCategoryModel *model = self.array[indexPath.section];
    
    if ([model.name isEqualToString:@"团队制作"]) {
        TeamClassListViewController *nineList = [[TeamClassListViewController alloc]init];
        [self.navigationController pushViewController:nineList animated:YES];
    }else{
        NineListViewController *nineList = [[NineListViewController alloc]init];
        nineList.isSuaixuan = NO;
        nineList.cateModel = model;
        nineList.cateModel.id = model.id;
        nineList.title = [NSString stringWithFormat:@"%@详情",model.name];
        [self.navigationController pushViewController:nineList animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor whiteColor];
    return footV;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        
    }
    return _tableView;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

@end
