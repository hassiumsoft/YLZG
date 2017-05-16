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
    currentPage = 2;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 35 + 75 + 2 + 46 + 10;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[YLZGDataManager sharedManager] getLoginInfoPage:currentPage Success:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            self.tableView.hidden = NO;
            [self hideMessageAction];
            [self.array addObject:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            self.tableView.hidden = YES;
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 20;
}


#pragma mark - 表格相关
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


- (void)shareAction
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self shareWebPagetoWechat:self.loginModel.url Type:0];
        }else if(buttonIndex == 2){
            [self shareWebPagetoWechat:self.loginModel.url Type:1];
        }
        
    } otherButtonTitles:@"微信好友",@"朋友圈", nil];
    [sheet show];
}

#pragma mark - 分享网页链接
- (void)shareWebPagetoWechat:(NSString *)url Type:(int)shareType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.loginModel.title;
    message.description = [NSString stringWithFormat:@"未登录人数：%@",self.loginModel.not_login];
    [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = url;
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = shareType;
    [WXApi sendReq:req];
    
}



@end
