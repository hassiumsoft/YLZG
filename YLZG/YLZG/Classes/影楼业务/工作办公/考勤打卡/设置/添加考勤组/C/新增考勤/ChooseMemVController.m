//
//  ChooseMemVController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ChooseMemVController.h"
#import "MutliChoceStaffCell.h"
#import "SVProgressHUD.h"
#import "ZCAccountTool.h"
#import "StaffInfoModel.h"
#import <MJExtension.h>
#import "HTTPManager.h"


@interface ChooseMemVController ()<UITableViewDelegate,UITableViewDataSource>

/** 已选中的数组 */
@property (strong,nonatomic) NSMutableArray *chooseArray;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation ChooseMemVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择人员";
    [self getData];
    [self setupTableView];
}
#pragma mark - 加载模拟数据
- (void)getData
{
    self.array = [NSMutableArray array];
    
    // http://zsylou.wxwkf.com/index.php/home/contacts/query?uid=2
    [self showHudMessage:@"加载中···"];
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:YLHome_Url, account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            int status = [[[responseObject objectForKey:@"code"] description] intValue];
            [SVProgressHUD dismiss];
            switch (status) {
                case 0:
                {
                    // 获取失败
                    [self sendErrorWarning:@"获取联系人失败"];
                    break;
                }
                case 1:
                {
                    // 获取成功 sid：店铺员工ID。type：1是店长、0是店员
                    NSArray *array = [responseObject objectForKey:@"result"];
                    self.array = [StaffInfoModel mj_objectArrayWithKeyValuesArray:array];
                    [self.tableView reloadData];
                    break;
                }
                default:
                    break;
            }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MutliChoceStaffCell *cell = [MutliChoceStaffCell sharedMutliChoceStaffCell:tableView];
    StaffInfoModel *model = self.array[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StaffInfoModel *model = self.array[indexPath.row];
    if (!model.isSelected) {
        for (int i = 0; i < self.array.count; i++) {
            if (i == indexPath.row) {
                StaffInfoModel *mm = self.array[i];
                mm.isSelected = YES;
                [self.array replaceObjectAtIndex:indexPath.row withObject:mm];
                [self.tableView reloadData];
                
                [self.chooseArray addObject:mm];
            }
        }
    }else{
        for (int i = 0; i < self.array.count; i++) {
            if (i == indexPath.row) {
                StaffInfoModel *kk = self.array[i];
                kk.isSelected = NO;
                [self.array replaceObjectAtIndex:indexPath.row withObject:kk];
                [self.tableView reloadData];
                
                [self.chooseArray removeObject:kk];
            }
        }
    }
    
    [self setupNav:self.chooseArray];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNav:self.chooseArray];
    
}
- (void)setupNav:(NSMutableArray *)array
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_nav"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    NSString *title;
    if (self.chooseArray.count > 0) {
        title = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.chooseArray.count];
    }else{
        title = @"确定";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:MainColor];
}
- (void)doneAction
{
    if ([self.delegate respondsToSelector:@selector(chooseMemWithArray:)]) {
        [self.delegate chooseMemWithArray:self.chooseArray];
        [self dismiss];
    }
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}

@end
