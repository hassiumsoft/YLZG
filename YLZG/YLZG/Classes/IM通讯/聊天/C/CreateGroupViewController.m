//
//  CreateGroupViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "SelectContacterCell.h"
#import <MJRefresh.h>
#import "ZCAccountTool.h"


@interface CreateGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 另外一个同事。有就是2人聊天时发起群聊的，没有则是消息界面过来的新建群 */
@property (strong,nonatomic) ContactersModel *otherContactModel;

@end

@implementation CreateGroupViewController

- (instancetype)initWithAnother:(ContactersModel *)otherContact
{
    self = [super init];
    if (self) {
        self.otherContactModel = otherContact;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起群聊";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createGroupAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.array = [[YLZGDataManager sharedManager] getAllFriendInfo];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    ContactersModel *model = self.array[indexPath.row];
    model.index = indexPath.row;
    if ([model.name isEqualToString:[ZCAccountTool account].username]) {
        model.isSelected = YES;
    }
    if ([model.name isEqualToString:self.otherContactModel.name]) {
        model.isSelected = YES;
    }
    SelectContacterCell *cell = [SelectContacterCell sharedMutliChoceStaffCell:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactersModel *model = self.array[indexPath.row];
    
    if (model.isSelected) {
        model.isSelected = NO;
    }else{
        model.isSelected = YES;
    }
    
    if ([model.name isEqualToString:[ZCAccountTool account].username]) {
        model.isSelected = YES;
    }
    if ([model.name isEqualToString:self.otherContactModel.name]) {
        model.isSelected = YES;
    }
    [self.tableView reloadData];
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)createGroupAction
{
    NSMutableArray *selectArray = [NSMutableArray array];
    ZCAccount *account = [ZCAccountTool account];
    
    for (ContactersModel *model in self.array) {
        if (model.isSelected) {
            if ([model.uid isEqualToString:account.userID]) {
                // 自己
                
            }else{
                [selectArray addObject:model];
            }
        }
    }
    
    if (selectArray.count >= 1) {
        
        [[YLZGDataManager sharedManager] createGroupWithMembers:selectArray Success:^(YLGroup *groupModel) {
            
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
            
        } Fail:^(NSString *errorMsg) {
            [self sendErrorWarning:errorMsg];
        }];
    }else{
        [MBProgressHUD showError:@"请邀请成员"];
    }
    
}

@end
