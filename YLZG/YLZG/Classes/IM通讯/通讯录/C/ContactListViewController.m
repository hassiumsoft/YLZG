//
//  ContactListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ContactListViewController.h"
#import <MJExtension.h>
#import "ContactTableViewCell.h"
#import "ZCAccountTool.h"
#import <MJRefresh.h>
#import "NormalconButton.h"
#import "ColleaguesModel.h"
#import "HTTPManager.h"
#import "YLZGDataManager.h"
#import "ColleaguesModel.h"
#import "NSString+StrCategory.h"
#import "ContactersModel.h"
#import "ContactHeadView.h"
#import <Masonry.h>
#import "AddFriendViewController.h"
#import "HuanxinContactManager.h"
#import "StudioContactManager.h"
#import "UserInfoViewController.h"
#import "ApplyViewController.h"
#import "GroupListViewController.h"
#import "FriendDetialController.h"


#define CellContentH 50
#define TopContentH (64 + CellContentH * 2 + 44) //
#define ContactTableWH (SCREEN_HEIGHT - TopContentH) // 联系人表格高度

@interface ContactListViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableDictionary *_showDic;//用来判断分组展开与收缩的
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 全部数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 同事数组 */
@property (strong,nonatomic) NSMutableArray *studioArray;
/** 环信数组 */
@property (strong,nonatomic) NSMutableArray *huanxinArray;
/** HeadView */
@property (strong,nonatomic) UIView *headV;
/** 新的朋友 */
@property (strong,nonatomic) NormalconButton *applyBtn;
/** 搜索数据源 */
@property (strong,nonatomic) NSMutableArray *searchArray;

/** 搜索框 */
@property (strong, nonatomic) UISearchBar *searchBar;
/** 搜索结果控制器 */
//@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (assign, nonatomic) NSInteger badNumber;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self setupSubViews];
    
    [YLNotificationCenter addObserver:self selector:@selector(reloadData) name:HXUpdataContacts object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(reloadData) name:YLHeadImageChanged object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(reloadData) name:YLNickNameChanged object:nil];
    
    self.studioArray = [StudioContactManager getAllStudiosContactsInfo]; // 4个
    self.huanxinArray =  [HuanxinContactManager getAllHuanxinContactsInfo]; // 18个
    if (self.huanxinArray.count >= 1 || self.studioArray.count >= 1) {
        [self OperationStudios:self.studioArray HuanxinArr:self.huanxinArray];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData:NO];
        }];
        
    }else{
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSArray *studioArray = [StudioContactManager getAllStudiosContactsInfo]; // 4个
            NSArray *huanxinArray =  [HuanxinContactManager getAllHuanxinContactsInfo]; // 18个
            if (huanxinArray.count >= 1 || studioArray.count >= 1) {
                [self getData:NO];
            }else{
                [self getData:YES];
            }
        }];
        [self.tableView.mj_header beginRefreshing];
    }
}
- (void)reloadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData:NO];
    });
}
#pragma mark - 操作数据
- (void)OperationStudios:(NSArray *)studioArray HuanxinArr:(NSArray *)huanxinArray
{
    ColleaguesModel *lastModel = [ColleaguesModel new];
    lastModel.member = huanxinArray;
    lastModel.dept = @"全部好友";
    
    
    [self.array addObjectsFromArray:studioArray];
    [self.array addObject:lastModel];
    
    
    // 保存搜索数据源
    for (ContactersModel *contact in huanxinArray) {
        [self.searchArray addObject:contact];
    }
    
    [self.tableView reloadData];
}
- (void)getData:(BOOL)isFirst
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *str = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/my_contacts?uid=%@",account.userID];
    
    [HTTPManager POST:str params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSArray *colleagues = [result objectForKey:@"colleagues"];
            NSArray *friends = [result objectForKey:@"friends"];
            
            
            if (!isFirst) {
                // 先删除全部数据
                [StudioContactManager deleteAllInfo];
                [HuanxinContactManager deleteAllInfo];
                [self.array removeAllObjects];
                [self.searchArray removeAllObjects];
                [self.huanxinArray removeAllObjects];
                [self.studioArray removeAllObjects];
            }
            
            self.studioArray = [ColleaguesModel mj_objectArrayWithKeyValuesArray:colleagues]; // 同事数组
            NSArray *huanxinArray = [ContactersModel mj_objectArrayWithKeyValuesArray:friends]; // 全部好友数组
            
            
            // 第一次进来获取数据，并且添加到数据库
            ColleaguesModel *lastModel = [ColleaguesModel new];
            lastModel.member = huanxinArray;
            lastModel.dept = @"全部好友";
            
            [self.huanxinArray addObject:lastModel];
            
            [self.array addObjectsFromArray:self.studioArray];
            [self.array addObject:lastModel];
            
            KGLog(@"__%@__",_array);
            
            // 保存环信好友
            for (int i = 0;i < lastModel.member.count;i++) {
                ContactersModel *model = lastModel.member[i];
                [HuanxinContactManager saveAllHuanxinContactsInfo:model];
                
            }
            // 保存影楼同事好友
            for (int i = 0; i < self.studioArray.count; i++) {
                [StudioContactManager saveAllStudiosContactsInfo:self.studioArray[i]];
                
            }
            
            // 保存搜索数组
            for (ContactersModel *contact in huanxinArray) {
                [self.searchArray addObject:contact];
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
        KGLog(@"error = %@",error.localizedDescription);
    }];
    
    
}

#pragma mark - 绘制UI
- (void)setupSubViews
{
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewFriendAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headV;
    
    // footer
    UILabel * footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    footer.backgroundColor = self.view.backgroundColor;
    footer.numberOfLines = 2;
    footer.text = @"CopyRight © 2016\r智诚科技(北京实验室)";
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor grayColor];
    footer.font = [UIFont fontWithName:@"Iowan Old Style" size:12];
    self.tableView.tableFooterView = footer;
}

- (void)addNewFriendAction
{
    AddFriendViewController *addFriend = [AddFriendViewController new];
    [self.navigationController pushViewController:addFriend animated:YES];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = self.array.count;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ColleaguesModel *model = self.array[section];
    return model.member.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [ContactTableViewCell sharedContactTableViewCell:tableView];
    [cell.xian removeFromSuperview];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    ColleaguesModel *model = self.array[indexPath.section];
    ContactersModel *contactModel = model.member[indexPath.row];
    cell.contactModel = contactModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        return CellContentH;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"📱" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ColleaguesModel *guesModel = self.array[indexPath.section];
        ContactersModel *model = guesModel.member[indexPath.row];
        if (![model.mobile isPhoneNum]) {
            [self showErrorTips:@"对方号码有误"];
            return ;
        }
        NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.mobile]];
        UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
        [self.view addSubview:phoneWebView];
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ColleaguesModel *model = self.array[section];
    
    ContactHeadView *headView = [ContactHeadView sharedContactHeadView];
    headView.deptLabel.text = model.dept;
    headView.memNumLabel.text = [NSString stringWithFormat:@"%ld人",(unsigned long)model.member.count];
    
    NSString * key = [NSString stringWithFormat:@"%ld", (long)section];
    if (![_showDic objectForKey:key]) {
        
        [headView.jiantouV setImage:[UIImage imageNamed:@"contact_jiantou_right"]];
    }else{
        [headView.jiantouV setImage:[UIImage imageNamed:@"contact_jiantou_down"]];
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
        NSInteger didSection = section; // tap.view.tag
        // 展开
        if (!_showDic) {
            _showDic = [NSMutableDictionary dictionary];
        }
        // 旋转效果
        NSString *key = [NSString stringWithFormat:@"%ld",(long)didSection];
        if (![_showDic objectForKey:key]) {
            [_showDic setObject:@"1" forKey:key];
            
            for (UIImageView *jiantouV in headView.subviews) {
                if ([jiantouV isKindOfClass:[UIImageView class]]) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        jiantouV.transform = CGAffineTransformMakeRotation(M_PI);
                    }];
                }
            }
            
        }else{
            [_showDic removeObjectForKey:key];
            
            for (UIImageView *jiantouV in headView.subviews) {
                if ([jiantouV isKindOfClass:[UIImageView class]]) {
                    
                    [UIView animateWithDuration:0.6 animations:^{
                        jiantouV.transform = CGAffineTransformRotate(jiantouV.transform, M_PI);
                    }];
                }
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView setContentOffset:CGPointMake(0, 1) animated:YES];
        
    }];
    [headView addGestureRecognizer:tap];
    
    return headView;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footV = [UIView new];
//    footV.backgroundColor = [UIColor clearColor];
//    return footV;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}
#pragma mark - 一些方法
- (void)buttonClick:(NormalconButton *)sender
{
    if (sender.tag == 31) {
        // 新朋友
        
        //        [self showSuccessTips:@"看通知"];
        ApplyViewController *Avc = [[ApplyViewController alloc] init];
        [self.navigationController pushViewController:Avc animated:YES];
    }else{
        // 群聊
        //[self showSuccessTips:@"去群聊"];
        
        GroupListViewController *Vc =[[GroupListViewController alloc] init];
        [self.navigationController pushViewController:Vc animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ColleaguesModel *model = self.array[indexPath.section];
    ContactersModel *contactModel = model.member[indexPath.row];
    if ([[ZCAccountTool account].username isEqualToString:contactModel.name]) {
        UserInfoViewController *user = [UserInfoViewController new];
        [self.navigationController pushViewController:user animated:YES];
    }else{
        FriendDetialController *friend = [FriendDetialController new];
        friend.userName = contactModel.name;
        friend.isRootPush = YES;
        [self.navigationController pushViewController:friend animated:YES];
    }
    
}

#pragma mark - 系统通知
//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyViewWithBadgeNumber:(NSInteger) number{
    
    
    self.applyBtn.count = number;
}

- (void)refreshUntreatedApplys
{
    [[YLZGDataManager sharedManager] loadUnApplyApplyFriendArr:^(NSMutableArray *array) {
        self.applyBtn.count = array.count;
    }];
}

//好友个数变化时，重新获取数据
- (void)reloadDataSource{
    // 先删除缓存
    [StudioContactManager deleteAllInfo];
    [HuanxinContactManager deleteAllInfo];
    [self.array removeAllObjects];
    [self.searchArray removeAllObjects];
    [self.huanxinArray removeAllObjects];
    [self.studioArray removeAllObjects];
    // 再获取一遍数据
    [self getData:YES];
}

//添加好友的操作被触发
- (void)addFriendAction{
    // 先删除缓存
    [StudioContactManager deleteAllInfo];
    [HuanxinContactManager deleteAllInfo];
    [self.array removeAllObjects];
    [self.searchArray removeAllObjects];
    [self.huanxinArray removeAllObjects];
    [self.studioArray removeAllObjects];
    // 再获取一遍数据
    [self getData:YES];
}
#pragma mark - 懒加载
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
//        _searchBar.showsCancelButton = YES;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}


- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)studioArray
{
    if (!_studioArray) {
        _studioArray = [NSMutableArray array];
    }
    return _studioArray;
}
- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}
- (NSMutableArray *)huanxinArray
{
    if (!_huanxinArray) {
        _huanxinArray = [NSMutableArray array];
    }
    return _huanxinArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CellContentH)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headV
{
    if (!_headV) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 82 + 44)];
        _headV.backgroundColor = self.view.backgroundColor;
        _headV.userInteractionEnabled = YES;
        
        [_headV addSubview:self.searchBar];
        
        NSArray *titleArr = @[@"新的朋友",@"影楼社区"];
        NSArray *imageArr = @[@"contact_newmsg",@"contact_newfri"];
        for (int i = 0; i < 2; i++) {
            NormalconButton *button = [NormalconButton sharedHomeIconView];
            button.label.text = titleArr[i];
            button.tag = i+31;
            button.label.textColor = MainColor;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.iconView.image = [UIImage imageNamed:imageArr[i]];
            button.backgroundColor = [UIColor whiteColor];
            CGFloat space = 0;
            CGFloat W = (SCREEN_WIDTH - space * 3)/2;
            CGFloat X = (i%3) * (W + space) + space;
            CGFloat Y = space + 44;
            [button setFrame:CGRectMake(X, Y, W, 78 - space * 2)];
            [_headV addSubview:button];
            if (i == 0) {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *count = [ud objectForKey:UDUnApplyCount];
                _applyBtn = button;
                _applyBtn.count = [count intValue];
                [self reloadApplyViewWithBadgeNumber:[count intValue]];
            }else{
                button.count = 0;
            }
        }
        
    }
    return _headV;
}

@end
