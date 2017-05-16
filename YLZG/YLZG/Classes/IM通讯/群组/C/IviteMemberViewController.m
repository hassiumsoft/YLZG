//
//  IviteMemberViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IviteMemberViewController.h"
#import "IvitMembersTableCell.h"
#import "StudioContactManager.h"
#import "HuanxinContactManager.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJRefresh.h>

@interface IviteMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据呀 */
@property (strong,nonatomic) NSMutableArray *array;


@property (strong,nonatomic) NSMutableArray *selectArray;

@end

@implementation IviteMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"选择联系人";
    
    [self.view addSubview:self.tableView];
    
    if (self.type == AddMemberType) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[YLZGDataManager sharedManager] getIvitersByGroupID:self.groupModel.id Success:^(NSArray *memberArray) {
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (ContactersModel *model in memberArray) {
                    if (model.status == NO) {
                        // 未加群的
                        [tempArray addObject:model];
                    }
                }
                
                [self.tableView.mj_header endRefreshing];
                self.array = tempArray;
                [self.tableView reloadData];
            } Fail:^(NSString *errorMsg) {
                [self.tableView.mj_header endRefreshing];
                [self sendErrorWarning:errorMsg];
            }];
        }];
        self.tableView.mj_header.ignoredScrollViewContentInsetTop = 12;
        [self.tableView.mj_header beginRefreshing];
    }else{
        // 获取可以剔除的人
        self.array = self.groupArr.mutableCopy;
    }
    
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
    ContactersModel *model = self.array[indexPath.row];
    IvitMembersTableCell *cell = [IvitMembersTableCell sharedIvitMembersTableCell:tableView];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZCAccount *account = [ZCAccountTool account];
    ContactersModel *model = self.array[indexPath.row];
    
    if (self.type == DeleteMemberType) {
        if ([model.name isEqualToString:account.username]) {
            [self showErrorTips:@"不能踢自己"];
            return;
        }
    }else{
        if ([model.name isEqualToString:account.username]) {
            [self showErrorTips:@"您已在群里"];
            return;
        }
    }
    
    
    if (model.isSelected) {
        model.isSelected = NO;
        [self.array replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
        [self.selectArray removeObject:model];
    }else{
        model.isSelected = YES;
        [self.tableView reloadData];
        [self.selectArray addObject:model];
    }
    
    [self setupRightBars:self.selectArray];
}
#pragma mark - 操作
- (void)buttonClick
{
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url;
    NSArray *dicArr = [ContactersModel mj_keyValuesArrayWithObjectArray:self.selectArray];
    NSString *memberJson = [self toJsonStr:dicArr];
    if (self.type == AddMemberType) {
        url = [NSString stringWithFormat:@"http://192.168.0.160/index.php/home/easemob/invite_to_group?uid=%@&sid=%@&gid=%@&id=%@&members=%@",account.userID,self.groupModel.sid,self.groupModel.gid,self.groupModel.id,memberJson];
    }else{
        url = [NSString stringWithFormat:@"http://192.168.0.160/index.php/home/easemob/kick_out_group?uid=%@&sid=%@&gid=%@&id=%@&members=%@",account.userID,self.groupModel.sid,self.groupModel.gid,self.groupModel.id,memberJson];
    }
    
    [MBProgressHUD showMessage:@"请稍后"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        [MBProgressHUD hideHUD];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self showSuccessTips:message];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            NSString *kkk = [NSString stringWithFormat:@"[%@]:建议您每次选择一个成员",message];
            [self sendErrorWarning:kkk];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self showErrorTips:error.localizedDescription];
    }];
    
}
- (void)setupRightBars:(NSMutableArray *)members
{
    NSString *message;
    if (members.count >= 1) {
        message = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)members.count];
    }else{
        message = @"";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:message style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
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
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
