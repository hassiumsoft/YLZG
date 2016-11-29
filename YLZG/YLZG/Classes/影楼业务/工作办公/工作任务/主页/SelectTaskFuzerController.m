//
//  SelectTaskFuzerController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SelectTaskFuzerController.h"
#import "StaffTableViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "ProduceDetialModel.h"
#import "ZCAcCountTool.h"
#import "UserInfoViewController.h"
#import "HTTPManager.h"

@interface SelectTaskFuzerController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@end

@implementation SelectTaskFuzerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}
- (void)getDetialData
{
    NSString *url = [NSString stringWithFormat:ProduceDetial_URL,[ZCAccountTool account].userID,self.produceID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        [self.tableView.mj_header endRefreshing];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            ProduceDetialModel *model = [ProduceDetialModel mj_objectWithKeyValues:result];
            self.array = model.member;
            [self.tableView reloadData];
            
        }else{
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
    }];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDetialData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 表格相关
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
    StaffTableViewCell *cell = [StaffTableViewCell sharedStaffTableViewCell:tableView];
    ProduceMemberModel *model = self.array[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    cell.nameLabel.text = model.nickname;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProduceMemberModel *model = self.array[indexPath.row];
    ZCAccount *account = [ZCAccountTool account];
    if ([model.uid isEqualToString:account.username]) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfo animated:YES];
    }else{
        // 选择审批人
        if (self.SelectBlock) {
            _SelectBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}


@end
