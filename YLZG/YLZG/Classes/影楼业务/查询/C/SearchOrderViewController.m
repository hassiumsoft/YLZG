//
//  SearchOrderViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "SearchTableViewCell.h"
#import "SearchDetailViewController.h"
#import "NSString+StrCategory.h"
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <Masonry.h>
#import <MJExtension/MJExtension.h>
#import "ZCAccountTool.h"

@interface SearchOrderViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UITableView * searchTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (strong,nonatomic) NormalIconView *emptyView;


@end

@implementation SearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    // 初始化
    [self selfInitSearchViewControllerVC];
    // 搭建UI
    [self createSearchBar];
}

#pragma mark - 初始化
- (void)selfInitSearchViewControllerVC{
    //    detailVC = [[SearchDetailViewController alloc] init];
    self.title = @"查询";
    self.dataSource = [NSMutableArray array];
}


#pragma mark - 请求数据
- (void)loadSearchViewControllerData{
    
    // 取出登录成功的uid
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:SEARCH_URL,self.searchBar.text,account.userID];
    [self showHudMessage:@"查询中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        if (code == 1) {
            // 如果multi是1,返回列表成功;0表示显示详情页面,3表示失败
            int multi = [[[responseObject objectForKey:@"multi"] description] intValue];
            if (multi == 1) {
                NSArray * arr = responseObject[@"result"];
                self.dataSource.array = [SearchViewModel mj_objectArrayWithKeyValuesArray:arr];
                // 刷新表格
                [self.view addSubview:self.searchTableView];
                [self.searchTableView reloadData];
                
            }else if (multi == 3) {
                [self.searchTableView removeFromSuperview];
                [self loadEmptyView:@"您输入的客人还没有开单"];
                
            }else if (multi == 5){
                [self.searchTableView removeFromSuperview];
                [self loadEmptyView:@"账号未登录，建议退出账号重试"];
                
            }else{
                [self.searchTableView removeFromSuperview];
                NSString *message = [[responseObject objectForKey:@"message"] description];
                [self loadEmptyView:message];
            }
        }else {
            [self.searchTableView removeFromSuperview];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            [self loadEmptyView:message];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
    
}

#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    
    self.emptyView.label.text = message;
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}

- (void)babyClicked:(NSNotification *)notice {
    if ([self.searchBar.text isEqualToString:notice.object]) {
        //        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark -创建UISearchBar相关
- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入姓名或电话号码";
    [self.view addSubview:_searchBar];
}


- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.rowHeight = 120;
        _searchTableView.backgroundColor = self.view.backgroundColor;
    }
    return _searchTableView;
}
- (NormalIconView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [NormalIconView sharedHomeIconView];
        _emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
        _emptyView.label.numberOfLines = 0;
        _emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
        _emptyView.backgroundColor = [UIColor clearColor];
    }
    return _emptyView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell * cell = [SearchTableViewCell sharedSearchTableViewCell:tableView];
    SearchViewModel * searchModel = _dataSource[indexPath.section];
    cell.model = searchModel;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = NorMalBackGroudColor;
    return foot;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"📱" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除该产品
        SearchViewModel * searchModel = self.dataSource[indexPath.section];
        NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",searchModel.phone]];
        UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
        [self.view addSubview:phoneWebView];
    }];
    deleteAction.backgroundColor = [UIColor lightGrayColor];
    
    return @[deleteAction];
}


#pragma mark - UISearchBarDelegate相关
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    [self loadSearchViewControllerData];
}

#pragma mark -在文字改变的时候去掉tableview
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_dataSource removeAllObjects];
    [_searchTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchDetailViewController *detailVC = [SearchDetailViewController new];
    SearchViewModel * model = _dataSource[indexPath.section];
    detailVC.detailTradeID = model.tradeID;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
