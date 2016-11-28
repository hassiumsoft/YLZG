//
//  TaskDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDetialViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "TaskDetialModel.h"
#import "NormalTableCell.h"
#import "TaskInputView.h"
#import "HomeNavigationController.h"
#import "ShowBigImgVController.h"
#import "TaskRecordTableCell.h"
#import "TaskDiscussTableCell.h"


@interface TaskDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) TaskDetialModel *detialModel;
/** 输入框 */
@property (strong,nonatomic) TaskInputView *taskInputView;


@end

@implementation TaskDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self getData];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.taskInputView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if(section == 1){
        return self.detialModel.dynamic.count;
    }else{
        return self.detialModel.discuss.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 项目
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        
        return cell;
    }else if (indexPath.section == 1){
        // 任务记录
        TaskRecordTableCell *cell = [TaskRecordTableCell sharedTaskRecordTableCell:tableView];
        cell.dynamicModel = self.detialModel.dynamic[indexPath.row];
        return cell;
    }else{
        // 项目评论记录
        TaskDiscussTableCell *cell = [TaskDiscussTableCell sharedTaskDiscussCell:tableView];
        TaskDetialDiscussModel *disModel = self.detialModel.discuss[indexPath.row];
        cell.discussModel = disModel;
        cell.DidBlock = ^(NSInteger am_type){
            [self.view endEditing:YES];
            if (am_type == 1) {
                // 查看大图
                
                ShowBigImgVController *show = [ShowBigImgVController new];
                HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:show];
                show.iconStr = disModel.am_uri;
                [self presentViewController:nav animated:NO completion:^{
                    
                }];
                
            }else{
                // 查看文件
                NSArray *itemArr = @[disModel.am_uri];
                UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:itemArr applicationActivities:nil];
                [self presentViewController:activity animated:TRUE completion:nil];
            }
        };
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 24;
    }else {
        TaskDetialDiscussModel *disModel = self.detialModel.discuss[indexPath.row];
        if (disModel.am_type == 0) {
            // 没有附件
            return 60;
        }else if (disModel.am_type == 1){
            // 附件是图片
            return 150;
        }else {
            // 附件是文件
            return 150;
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // 任务详细
        return 28;
    }else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *proStr = [NSString stringWithFormat:@"项目：%@",self.detialModel.name ];
    NSArray *headArr = @[proStr,@"任务记录",@"评论记录"];
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 28)];
    headV.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
    label.text = headArr[section];
    label.font = [UIFont systemFontOfSize:14];
    [headV addSubview:label];
    return headV;
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
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (TaskInputView *)taskInputView
{
    if (!_taskInputView) {
        _taskInputView = [[TaskInputView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 50)];
    }
    return _taskInputView;
}
#pragma mark - 获取数据
- (void)getData
{
    NSString *url = [NSString stringWithFormat:TaskDetial_Url,[ZCAccountTool account].userID,self.listModel.id];
    [self showHudMessage:@"正在加载···"];
    NSLog(@"任务详情url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud:0];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.detialModel = [TaskDetialModel mj_objectWithKeyValues:result];
            [self setupSubViews];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

@end
