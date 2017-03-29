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
#import <MJRefresh.h>
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
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建分类" style:UIBarButtonItemStylePlain target:self action:@selector(createClass)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getTeamClassArray];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)createClass
{
    __weak SelectClassesController *copySelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加分类" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 添加团队分类模板
        [self addTeamClassName:[alertController.textFields lastObject].text Completion:^(TeamClassModel *lastModel) {
            if (copySelf.SelectClassBlock) {
                copySelf.SelectClassBlock(lastModel);
                [copySelf.navigationController popViewControllerAnimated:YES];
            }
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}


#pragma mark - 获取分类数组
- (void)getTeamClassArray
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
                
                self.classArray = classArr;
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


@end
