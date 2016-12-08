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
#import "EditCareTableViewCell.h"


@interface EditCareCategoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *selectArray;

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    [button setFrame:CGRectMake(20, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH - 40, 40)];
    [button setTitle:@"确定关注" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.selectArray.count >= 1) {
            NSMutableArray *IDArray = [NSMutableArray array];
            for (NineCategoryModel *model in self.selectArray) {
                [IDArray addObject:model.id];
            }
            NSString *careIDJson = [self toJsonStr:IDArray];
            NSString *url = [NSString stringWithFormat:NineCareEdit_Url,[ZCAccountTool account].userID,careIDJson];
            [self showHudMessage:@"添加关注中···"];
            
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [[responseObject objectForKey:@"message"]description];
                [self hideHud:0];
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
                [self hideHud:0];
                [self sendErrorWarning:error.localizedDescription];
            }];
        }else{
            [self showErrorTips:@"请选中要关注的类"];
        }
    }];
    [self.view addSubview:button];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.category.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCareTableViewCell *cell = [EditCareTableViewCell sharedEditCareCell:tableView];
    NineCategoryModel *model = self.listModel.category[indexPath.row];
    cell.cateModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NineCategoryModel *cateModel = self.listModel.category[indexPath.row];
    if (cateModel.isSelected) {
        // 取消选中
        cateModel.isSelected = NO;
        [self.listModel.category replaceObjectAtIndex:indexPath.row withObject:cateModel];
        [self.selectArray removeObject:cateModel];
        [self.tableView reloadData];
    }else{
        // 确定选中
        cateModel.isSelected = YES;
        [self.listModel.category replaceObjectAtIndex:indexPath.row withObject:cateModel];
        [self.selectArray addObject:cateModel];
        [self.tableView reloadData];
    }
    
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

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
