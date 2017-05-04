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
#import "SearchContacterController.h"



@interface ContactListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 索引数据源 */
@property (copy,nonatomic) NSArray *sectionArray;
/** 搜索框 */
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) SearchContacterController *searchResultController;


@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self setupSubViews];
    
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    [YLNotificationCenter addObserver:self selector:@selector(refreshDataAction) name:HXUpdataContacts object:nil];
    
    __weak ContactListViewController *copySelf = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.estimatedSectionHeaderHeight = 44;
    self.tableView.sectionIndexColor = MainColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.searchResultController = [[SearchContacterController alloc] initWithStyle:UITableViewStylePlain];
    self.searchResultController.ClickUserBlock = ^(ContactersModel *model){
        // 查看同事详情
        if ([[ZCAccountTool account].username isEqualToString:model.name]) {
            UserInfoViewController *user = [UserInfoViewController new];
            [copySelf.navigationController pushViewController:user animated:YES];
        }else{
            FriendDetialController *friend = [FriendDetialController new];
            friend.contactModel = model;
            friend.isRootPush = YES;
            [copySelf.navigationController pushViewController:friend animated:YES];
        }
    };
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索昵称";
    self.searchController.searchBar.height = 50.f;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDataAction];
    }];
    
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ColleaguesModel *collModel = array[i];
        if (collModel.dept.length == 0) {
            collModel.dept = @"X";
        }
        NSString *firstKey;
        if (i == array.count - 1) {
            firstKey = @"友";
        }else{
            firstKey = [collModel.dept substringWithRange:NSMakeRange(0, 1)];
        }
        [tempArr addObject:firstKey];
    }
    
    self.sectionArray = tempArr;
    [self.tableView reloadData];
}
// 接受到通知，刷新数据
- (void)refreshDataAction
{
    [[YLZGDataManager sharedManager] refreshContactersSuccess:^(NSArray *userArray) {
        [self.tableView.mj_header endRefreshing];
        self.array = userArray;
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < self.array.count; i++) {
            ColleaguesModel *collModel = self.array[i];
            if (collModel.dept.length == 0) {
                collModel.dept = @"X";
            }
            NSString *firstKey;
            if (i == self.array.count - 1) {
                firstKey = @"友";
            }else{
                firstKey = [collModel.dept substringWithRange:NSMakeRange(0, 1)];
            }
            [tempArr addObject:firstKey];
        }
        
        self.sectionArray = tempArr;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } Fail:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:errorMsg];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[YLZGDataManager sharedManager] searchUserByName:searchText Success:^(NSArray *userArray) {
        
        self.searchResultController.searchArray = userArray;
        
        
    } Fail:^(NSString *errorMsg) {
        self.searchResultController.searchArray = @[];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        ColleaguesModel *model = self.array[section - 1];
        return model.member.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *titleArray = @[@"新的朋友",@"群聊"];
        ContactTableViewCell *cell = [ContactTableViewCell sharedContactTableViewCell:tableView];
        cell.headImageV.image = [UIImage imageWithColor:HWRandomColor];
        cell.nickNameLabel.text = titleArray[indexPath.row];
        return cell;
    }else{
        ColleaguesModel *model = self.array[indexPath.section - 1];
        ContactersModel *contactModel = model.member[indexPath.row];
        ContactTableViewCell *cell = [ContactTableViewCell sharedContactTableViewCell:tableView];
        cell.contactModel = contactModel;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ApplyViewController *apply = [ApplyViewController new];
            [self.navigationController pushViewController:apply animated:YES];
        }else{
            GroupListViewController *group = [[GroupListViewController alloc]init];
            [self.navigationController pushViewController:group animated:YES];
        }
    }else{
        // 查看同事详情
        ColleaguesModel *model = self.array[indexPath.section - 1];
        ContactersModel *contactModel = model.member[indexPath.row];
        if ([[ZCAccountTool account].username isEqualToString:contactModel.name]) {
            UserInfoViewController *user = [UserInfoViewController new];
            [self.navigationController pushViewController:user animated:YES];
        }else{
            FriendDetialController *friend = [FriendDetialController new];
            friend.contactModel = contactModel;
            friend.isRootPush = YES;
            [self.navigationController pushViewController:friend animated:YES];
        }
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionArray;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index + 1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 33;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NULL;
    }else{
        ColleaguesModel *model = self.array[section - 1];
        UIView *headView = [UIView new];
        headView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 1.5, self.view.width - 36, 30)];
        headLabel.text = model.dept;
        headLabel.font = [UIFont systemFontOfSize:15];
        [headView addSubview:headLabel];
        return headView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

#pragma mark - 系统通知
//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyViewWithBadgeNumber:(NSInteger)number{
    
//    self.applyBtn.count = number;
}

- (void)refreshUntreatedApplys
{
    [[YLZGDataManager sharedManager] loadUnApplyApplyFriendArr:^(NSMutableArray *array) {
//        self.applyBtn.count = array.count;
    }];
}

#pragma mark - 搜索代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    searchBar.text = nil;
    
    [[YLZGDataManager sharedManager] searchUserByName:searchBar.text Success:^(NSArray *userArray) {
        
        self.searchResultController.searchArray = userArray;
        
    } Fail:^(NSString *errorMsg) {
        self.searchResultController.searchArray = @[];
    }];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    searchBar.text = nil;
    [self.searchController dismissViewControllerAnimated:YES completion:^{
        self.searchResultController.searchArray = @[];
    }];
    
}


@end
