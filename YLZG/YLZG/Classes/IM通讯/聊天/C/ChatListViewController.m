//
//  ChatListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChatListViewController.h"
#import "PublicNoticeController.h"
#import "MessageListTableCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ChatListHeadView.h"
#import "ChatViewController.h"
#import "YLZGDataManager.h"
#import "ClearCacheTool.h"
#import "GroupMsgManager.h"
#import "CreateGroupViewController.h"
#import "AddFriendViewController.h"
#import "EaseConversationModel.h"
#import "HomeNavigationController.h"
#import "AddMoreView.h"
#import "WorkAssistViewController.h"
#import "WorkSecretaryViewController.h"


@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,EMGroupManagerDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** TableHeadView */
@property (strong,nonatomic) ChatListHeadView *headView;
/** 断网时的红色提示 */
@property (nonatomic, strong) UIView *networkStateView;

/** 掌柜工作助手(登录信息) */
@property (copy,nonatomic) NSArray *loginArray;
/** 掌柜小秘书(版本信息) */
@property (copy,nonatomic) NSArray *versionArray;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupSubViews];
}
#pragma mark - 环信相关
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotifications];
    [self getDataFromRAM];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}


-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}



#pragma mark - 表格相关
- (void)setupSubViews
{
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataFromRAM];
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 8;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMoreAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    [self getNewestWorkData];
    
}

#pragma mark - 获取最新的工作信息
- (void)getNewestWorkData
{
    // 获取掌柜数据
    [[YLZGDataManager sharedManager] getLoginInfoPage:1 Success:^(NSArray *array) {
        
        LoginInfoModel *loginModel = [array firstObject];
        self.headView.loginModel = loginModel;
        self.loginArray = array;
        
    } Fail:^(NSString *errorMsg) {
        self.loginArray = nil;
    }];
    [[YLZGDataManager sharedManager] getNewVersionPage:1 Success:^(NSArray *array) {
        
        VersionInfoModel *versionModel = [array firstObject];
        self.headView.versionModel = versionModel;
        self.versionArray = array;
        
    } Fail:^(NSString *errorMsg) {
        self.versionArray = nil;
    }];
}

- (void)addMoreAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    AddMoreView *moreView = [[AddMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.DidSelectBlock = ^(ClickIndex index) {
        if (index == CreateGroupIndex) {
            CreateGroupViewController *createGroup = [[CreateGroupViewController alloc]initWithAnother:nil];
            HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:createGroup];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }else if (index == AddFriendIndex){
            AddFriendViewController *createGroup = [AddFriendViewController new];
            HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:createGroup];
            createGroup.isPresent = YES;
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
    };
    [keyWindow addSubview:moreView];
}
#pragma mark - 从内存中获取聊天列表
- (void)getDataFromRAM
{
    self.array = [NSMutableArray arrayWithArray:[[EMClient sharedClient].chatManager getAllConversations]];
    
    [self refreshAndSortView];
    
    [self.tableView.mj_header endRefreshing];
    
    
    [self.tableView reloadData];
}

// 数组排序
-(void)refreshAndSortView
{
    if (self.array.count < 1) {
        return;
    }
    
    if ([[self.array firstObject] isKindOfClass:[EMConversation class]]) {
        
        NSArray *sortedArr = [self.array sortedArrayUsingComparator:^NSComparisonResult(EMConversation *obj1, EMConversation *obj2) {
            EMMessage *message1 = obj1.latestMessage;
            EMMessage *message2 = obj2.latestMessage;
            
            if(message1.timestamp > message2.timestamp) {
                return(NSComparisonResult)NSOrderedAscending;
            }else {
                return(NSComparisonResult)NSOrderedDescending;
            }
            
        }];
        [self.array removeAllObjects];
        [self.array addObjectsFromArray:sortedArr];
        
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *model = self.array[indexPath.row];
    MessageListTableCell *cell = [MessageListTableCell sharedMessageListCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    EMConversation *model = self.array[indexPath.row];
    ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:model.conversationId conversationType:model.type];
    if (model.type == EMConversationTypeChat) {
        [[YLZGDataManager sharedManager] getOneStudioByUserName:model.conversationId Block:^(ContactersModel *model) {
            chat.contactModel = model;
            [self.navigationController pushViewController:chat animated:YES];
        }];
    }else{
        [GroupMsgManager getGroupInfoByGroupID:model.conversationId Completion:^(YLGroup *groupModel) {
            chat.groupModel = groupModel;
            [self.navigationController pushViewController:chat animated:YES];
        }];
        
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EMConversation *model = self.array[indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            
        }];
        [self.array removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
}
#pragma mark - 其他设置
- (void)networkChanged:(EMConnectionState)connectionState;
{
    if (connectionState == EMConnectionDisconnected) {
        // 失去连接
        self.title = @"消息（未连接）";
    }else{
        // 获得连接
        self.title = @"消息";
        [self getNewestWorkData];
    }
    
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        
    }
    return _tableView;
}
- (ChatListHeadView *)headView
{
    if (!_headView) {
        _headView = [[ChatListHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        __weak ChatListViewController *copySelf = self;
        _headView.ClickBlock = ^(ClickType clickType) {
            if (clickType == WorkZhushouType) {
                // 工作助手
                WorkAssistViewController *assist = [[WorkAssistViewController alloc]initWithLoginArray:copySelf.loginArray];
                [copySelf.navigationController pushViewController:assist animated:YES];
            }else if (clickType == WorkMishuType){
                // 掌柜小秘书
                WorkSecretaryViewController *secret = [[WorkSecretaryViewController alloc]initWithVersionArray:copySelf.versionArray];
                secret.RefrashBlock = ^{
                  // 刷新数据
                    [[YLZGDataManager sharedManager] getNewVersionPage:1 Success:^(NSArray *array) {
                        
                        VersionInfoModel *versionModel = [array firstObject];
                        copySelf.headView.versionModel = versionModel;
                        copySelf.versionArray = array;
                        
                    } Fail:^(NSString *errorMsg) {
                        copySelf.versionArray = nil;
                    }];
                };
                [copySelf.navigationController pushViewController:secret animated:YES];
            }
        };
    }
    return _headView;
}




@end
