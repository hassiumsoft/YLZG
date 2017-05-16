//
//  WorkSecretaryViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkSecretaryViewController.h"
#import "WorkSecretTableCell.h"
#import <LCActionSheet.h>
#import <MJRefresh.h>
#import "WXApi.h"

@interface WorkSecretaryViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
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
@property (strong,nonatomic) VersionInfoModel *versionModel;

@end

@implementation WorkSecretaryViewController

- (instancetype)initWithVersionArray:(NSArray *)versionArray
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray arrayWithArray:versionArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"掌柜小秘书";
    [self setupSubViews];
}


- (void)setupSubViews
{
    currentPage = 2;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 150;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[YLZGDataManager sharedManager] getNewVersionPage:currentPage Success:^(NSArray *array) {
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
    WorkSecretTableCell *cell = [WorkSecretTableCell sharedWorkCell:tableView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark - 分享网页链接
- (void)shareAction
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self shareWebPagetoWechat:self.versionModel.extra Type:0];
        }else if(buttonIndex == 2){
            [self shareWebPagetoWechat:self.versionModel.extra Type:1];
        }
        
    } otherButtonTitles:@"微信好友",@"朋友圈", nil];
    [sheet show];
}


- (void)shareWebPagetoWechat:(NSString *)url Type:(int)shareType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.versionModel.title;
    message.description = self.versionModel.content;
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
