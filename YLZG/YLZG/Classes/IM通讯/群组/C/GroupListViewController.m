//
//  GroupListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupListViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "YLGroup.h"
#import <MJExtension.h>
#import "NormalconButton.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "GroupTableViewCell.h"
#import "CreateGroupViewController.h"
#import "GroupMsgManager.h"
#import "HomeNavigationController.h"
#import "YLChatGroupDetailController.h"




@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (nonatomic,strong)UITableView *tableView;
/** 群组数据 */
@property(copy,nonatomic) NSArray *groupArray;

@end


@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊";
    
    [self setupSubViews];
    [YLNotificationCenter addObserver:self selector:@selector(UpdataGroupInfo) name:HXUpdataGroupInfo object:nil];
    
}
-(void)setupSubViews{
    
    self.groupArray = [GroupMsgManager getAllGroupInfo];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    
    [self UpdataGroupInfo];
}

- (void)UpdataGroupInfo
{
    // 网络获取最新群组信息，并且更新本地缓存
    [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
        NSArray *groupArray = [GroupMsgManager getAllGroupInfo];
        self.groupArray = groupArray;
        [self.tableView reloadData];
    }];
}


#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableViewCell:tableView];
    cell.model = self.groupArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLChatGroupDetailController *group = [[YLChatGroupDetailController alloc]initWithConversation:nil];
    YLGroup *model = self.groupArray[indexPath.row];
    group.groupModel = model;
    group.isRootPush = YES;
    [self.navigationController pushViewController:group animated:YES];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}



@end
