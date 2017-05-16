//
//  TeamClassListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TeamClassListViewController.h"
#import "TeamClassViewController.h"
#import "NineCareTableViewCell.h"
#import <MJRefresh.h>
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <LCActionSheet.h>


@interface TeamClassListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation TeamClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队制作分类列表";
    [self setupSubViews];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getClassListAction];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addClassAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
}

- (void)addClassAction
{
    __weak TeamClassListViewController *copySelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加分类" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 添加团队分类模板
        [self addTeamClassName:[alertController.textFields lastObject].text Completion:^(TeamClassModel *lastModel) {
            [copySelf.tableView.mj_header beginRefreshing];
        }];
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = copySelf;
    }];
    
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
#pragma mark - 添加分类
- (void)addTeamClassName:(NSString *)name Completion:(void (^)(TeamClassModel *lastModel))completion
{
    NSString *url = [NSString stringWithFormat:NineAddTeamClass_Url,[ZCAccountTool account].userID,name];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            TeamClassModel *model = [TeamClassModel mj_objectWithKeyValues:result];
            completion(model);
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"删除分类后，该分类下的模板也将删除" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                TeamClassModel *model = self.array[indexPath.section];
                [self deleteClassActionClassID:model.cid];
            }
        } otherButtonTitles:@"确定删除", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
        
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
}
#pragma mark - 删除某分类
- (void)deleteClassActionClassID:(NSString *)classID
{
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.160/index.php/wei/retransmission/del_category?uid=%@&id=%@",[ZCAccountTool account].userID,classID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 获取团队分类列表
- (void)getClassListAction
{
    NSString *url = [NSString stringWithFormat:TeamClasses_Url,[ZCAccountTool account].userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"result"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                
                NSArray *classArr = [TeamClassModel mj_objectArrayWithKeyValuesArray:result];
                
                self.array = classArr;
                [self.tableView reloadData];
                
            }else{
                
                [self sendErrorWarning:@"您的团队还没有创建分类，点击右上角创建分类"];
            }
        }else{
            
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamClassModel *model = self.array[indexPath.section];
    TeamClassViewController *teamClass = [TeamClassViewController new];
    teamClass.classModel = model;
    [self.navigationController pushViewController:teamClass animated:YES];
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
    cell.teamClassModel = self.array[indexPath.section];
    return cell;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 150;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    return _tableView;
}

@end
