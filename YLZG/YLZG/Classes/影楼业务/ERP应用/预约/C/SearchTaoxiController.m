//
//  SearchTaoxiController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/10.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SearchTaoxiController.h"
#import "ZCAccountTool.h"
#import "SearchTableViewCell.h"
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <Masonry.h>
#import <MJExtension.h>

@interface SearchTaoxiController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *searchTableView;

@property (strong,nonatomic) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (strong,nonatomic) NormalIconView *emptyView;

@end

@implementation SearchTaoxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择订单";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.searchBar];
    
//    [self loadEmptyView:@""];
}
- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, SCREEN_HEIGHT - 48 - 64)];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.rowHeight = 120;
        _searchTableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _searchTableView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        _searchBar.delegate = self;
        _searchBar.text = @"18103756638";
        _searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_searchBar becomeFirstResponder];
        _searchBar.backgroundColor = self.view.backgroundColor;
        _searchBar.placeholder = @"手机号或客户姓名，支持模糊查询";
    }
    return _searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self loadSearchViewControllerData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"_dataSource = %@",_dataSource);
    return _dataSource.count;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell * cell = [SearchTableViewCell sharedSearchTableViewCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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

#pragma mark - 请求数据
- (void)loadSearchViewControllerData{
    
    // 取出登录成功的uid
    ZCAccount *account = [ZCAccountTool account];
    NSString * uid = account.userID;
    NSString * url = [NSString stringWithFormat:SEARCH_URL,self.searchBar.text,uid];
    [self showHudMessage:@"请求中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        [self.dataSource removeAllObjects];
        if (code == 1) {
            // 如果multi是1,返回列表成功;0表示显示详情页面,3表示失败
            int multi = [[[responseObject objectForKey:@"multi"] description] intValue];
            if (multi == 1) {
                NSArray * arr = responseObject[@"result"];
                
                self.dataSource = [SearchViewModel mj_objectArrayWithKeyValuesArray:arr];
                for (SearchViewModel *model in self.dataSource) {
                    model.multi = 1;
                }
                // 刷新表格
                [self.view addSubview:self.searchTableView];
                [self.searchTableView reloadData];
            }
            else if (multi == 3) {
                [self loadEmptyView:@"您输入的客人还没有开单"];
            }else if (multi == 0){
                // 直接填充
                
                SearchOrderModel *model = [SearchOrderModel mj_objectWithKeyValues:responseObject];
                
                SearchViewModel *viewModel = [SearchViewModel mj_objectWithKeyValues:responseObject];
                
                [self.dataSource addObject:viewModel];
                [self.view addSubview:self.searchTableView];
                [self.searchTableView reloadData];
                
                if ([self.delegate respondsToSelector:@selector(detialOrderModel:)]) {
                    [self.delegate detialOrderModel:model];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
                
                
            }else if (multi == 5){
                [self loadEmptyView:@"账号未登录，建议退出账号重试"];
            }
        }else {
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (message.length < 1) {
                [self loadEmptyView:@"找不到订单，请检查手机号码"];
            }else{
                [self loadEmptyView:message];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchViewModel *searchModel = _dataSource[indexPath.section];
    
    
    if ([self.delegate respondsToSelector:@selector(searchOrderModel:)]) {
        [self.delegate searchOrderModel:searchModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    [self.searchTableView removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 全部为空值
    
    self.emptyView.label.text = message;
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
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
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
