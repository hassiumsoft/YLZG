//
//  SelectClassesController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/3/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectClassesController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "NormalTableCell.h"


@interface SelectClassesController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (copy,nonatomic) NSArray *classArray;

@property (strong,nonatomic) UITableView *tableView;
/** 新添加的分类名字 */
@property (copy,nonatomic) NSString *addClassName;


@end

@implementation SelectClassesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择模板分类";
    [self getTeamClassArray];
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建分类" style:UIBarButtonItemStylePlain target:self action:@selector(createClass)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
}

- (void)createClass
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加分类" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TeamClassModel *teamModel = [TeamClassModel new];
        teamModel.isNewAdd = YES;
        teamModel.name = self.addClassName;
        teamModel.id = @"-1";
        if (self.SelectClassBlock) {
            _SelectClassBlock(teamModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    __weak SelectClassesController *copySelf = self;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = copySelf;
    }];
    
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.addClassName = textField.text;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamClassModel *model = self.classArray[indexPath.row];
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    cell.textLabel.text = model.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamClassModel *model = self.classArray[indexPath.row];
    if (self.SelectClassBlock) {
        _SelectClassBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _tableView;
}


#pragma mark - 获取分类数组
- (void)getTeamClassArray
{
    NSString *url = [NSString stringWithFormat:TeamClasses_Url,[ZCAccountTool account].userID];
    [MBProgressHUD showMessage:@"加载中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"result"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                
                NSArray *classArr = [TeamClassModel mj_objectArrayWithKeyValuesArray:result];
                for (TeamClassModel *model in classArr) {
                    model.isNewAdd = NO;
                }
                self.classArray = classArr;
                [self.tableView reloadData];
            }else{
                
                [self sendErrorWarning:@"您的团队还没有创建模板，快去创建模板界面创建吧。"];
            }
        }else{
            
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
}


@end
