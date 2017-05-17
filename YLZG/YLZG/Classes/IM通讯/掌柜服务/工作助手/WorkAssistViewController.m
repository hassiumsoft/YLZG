//
//  WorkAssistViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkAssistViewController.h"
#import "WorkAssistTableCell.h"
#import <LCActionSheet.h>
#import "WXApi.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "ZCAccountTool.h"
#import "LoginWebViewController.h"
#import <MJRefresh.h>

@interface WorkAssistViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    int currentPage; // 页码
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

/** 网页 */
@property (strong,nonatomic) UIWebView *webView;
/** 数据源 */
@property (strong,nonatomic) LoginInfoModel *loginModel;

@end

@implementation WorkAssistViewController

- (instancetype)initWithLoginArray:(NSArray *)loginArray
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray arrayWithArray:loginArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作助手";
    [self setupSubViews];
    
}


#pragma mark - 表格相关
- (void)setupSubViews
{
    currentPage = 2;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 35 + 55 + 2 + 46 + 10;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getFootLoginSuccess:^(int page, NSArray *array) {
            [self.tableView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    
}

- (void)getFootLoginSuccess:(void (^)(int page,NSArray *array))success Fail:(void (^)(NSString *errorMsg))fail
{
    ZCAccount *account = [ZCAccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/helper_list?page=%d&uid=%@",currentPage,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            int page = [[[responseObject objectForKey:@"page"] description] intValue];
            if (page > currentPage) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                fail(@"暂无更多");
            }else{
                currentPage++;
                NSArray *modelArray = [LoginInfoModel mj_objectArrayWithKeyValuesArray:result];
                success(page,modelArray);
                
                if (modelArray.count >= 1) {
                    success(page,modelArray);
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        fail(error.localizedDescription);
    }];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkAssistTableCell *cell = [WorkAssistTableCell sharedWorkAssistCell:tableView];
    cell.loginModel = self.array[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LoginInfoModel *model = self.array[indexPath.section];
    LoginWebViewController *web = [[LoginWebViewController alloc]initWithLoginModel:model];
    [self.navigationController pushViewController:web animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}





@end
