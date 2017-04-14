//
//  CardNumViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CardNumViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "UserInfoManager.h"
#import "OpenOrderCardModel.h"
#import "CardNumTableCell.h"


@interface CardNumViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UISearchBar *searchBar;

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation CardNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡号";
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
}
- (void)getData:(NSString *)searchText
{
    NSString *url = [NSString stringWithFormat:CardNum_URL,[ZCAccountTool account].userID,searchText];
    [MBProgressHUD showMessage:@"查询中···"];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (code == 1) {
            [MBProgressHUD hideHUD];
            NSArray *result = [responseObject objectForKey:@"result"];
            
            if (result.count >= 1) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.array = [OpenOrderCardModel mj_objectArrayWithKeyValuesArray:result];
                [self.tableView reloadData];
            }else{
                [self showErrorTips:@"查无此卡"];
                [MBProgressHUD hideHUD];
            }
        }else{
            [MBProgressHUD showError:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
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
    CardNumTableCell *cell = [CardNumTableCell sharedCardNumTableCell:tableView];
    OpenOrderCardModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    OpenOrderCardModel *model = self.array[indexPath.row];
    if (_SelectCardNum) {
        _SelectCardNum(model.number);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"📱" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([[[UserInfoManager sharedManager] getUserInfo].type intValue] == 1) {
            OpenOrderCardModel *model = self.array[indexPath.row];
            NSString *tel = [NSString stringWithFormat:@"tel:%@",model.phone];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tel]]];
            [self.view addSubview:webView];
        }else{
            [self sendErrorWarning:@"您的账号暂无拨号功能，可联系店长。"];
        }
        
    }];
    action.backgroundColor = WechatRedColor;
    return @[action];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self getData:searchBar.text];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        
        _tableView.tableHeaderView = self.searchBar;
    }
    return _tableView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [_searchBar becomeFirstResponder];
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.placeholder = @"姓名、手机号码或会员卡号";
        
    }
    return _searchBar;
}

@end
