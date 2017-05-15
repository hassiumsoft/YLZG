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
#import <MJRefresh.h>

@interface WorkAssistViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

/** 网页 */
@property (strong,nonatomic) UIWebView *webView;
/** 数据源 */
@property (strong,nonatomic) LoginInfoModel *loginModel;

@end

@implementation WorkAssistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作助手";
//    [self setupSubViews];
    [self setupWebView];
}

- (void)setupWebView
{
    [[YLZGDataManager sharedManager] getContactersLoginInfoSuccess:^(LoginInfoModel *model) {
        [self hideMessageAction];
        self.loginModel = model;
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        self.webView.delegate = self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.158/index.php/admin/article/detail?&sid=9&time=1494751542"]];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
    } Fail:^(NSString *errorMsg) {
        [self showEmptyViewWithMessage:errorMsg];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)shareAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
        }else if (buttonIndex == 2){
            
        }
    } otherButtonTitles:@"朋友圈",@"微信好友", nil];
    [sheet show];
}

#pragma mark - 网页相关
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideMessageAction];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showEmptyViewWithMessage:error.localizedDescription];
}

#pragma mark - 表格相关
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 35 + 75 + 2 + 46 + 10;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.array.count;
//    return 12;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkAssistTableCell *cell = [WorkAssistTableCell sharedWorkAssistCell:tableView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
