//
//  WorkSecretaryViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkSecretaryViewController.h"
#import "WorkSecretTableCell.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import "FromSystermTableCell.h"
#import "SecreterWebViewController.h"
#import <LCActionSheet.h>
#import <MJRefresh.h>
#import "FromUserTableCell.h"


@interface WorkSecretaryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int currentPage; // 页码
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

/** 底部输入框 */
@property (strong,nonatomic) UITextField *textField;

@end

@implementation WorkSecretaryViewController

- (instancetype)initWithVersionArray:(NSArray *)versionArray
{
    self = [super init];
    if (self) {
        // 还得倒叙一遍数组
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < versionArray.count; i++) {
            VersionInfoModel *model = versionArray[i];
            [tempArray insertObject:model atIndex:0];
        }
        self.array = [NSMutableArray arrayWithArray:tempArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"掌柜小秘书";
    [self setupSubViews];
}

#pragma mark - 绘制界面
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    currentPage = 2;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];

    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getFootVersionSuccess:^(int page, NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 20;
    
    // 底部输入框
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 50)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.textField.placeholder = @"输入您的问题或反馈";
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.borderColor = RGBACOLOR(235, 235, 238, 1).CGColor;
    self.textField.layer.borderWidth = 5;
    self.textField.layer.cornerRadius = 3;
    [self.view addSubview:self.textField];
    
    // 滚动到底部
    [self scrollToBottomView];
    
}
- (void)scrollToBottomView
{
    if (self.array.count < 1) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:
                                            [self.tableView numberOfRowsInSection:0]-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - 发送文本信息
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [[YLZGDataManager sharedManager] sendToSecretWithMessage:textField.text Success:^(VersionInfoModel *versionModel) {
        
        // 先插入用户的
        VersionInfoModel *userVersionModel = [[VersionInfoModel alloc]init];
        userVersionModel.content = textField.text;
        userVersionModel.type = 3;
        userVersionModel.from = 2;
        userVersionModel.date = @"刚刚";
        [self.array addObject:userVersionModel];
        // 再插入系统的
        versionModel.date = @"刚刚";
        [self.array addObject:versionModel];
        [self.tableView reloadData];
        [self scrollToBottomView];
        self.textField.text = nil;
        // 告诉上个界面刷新数据
        if (self.RefrashBlock) {
            _RefrashBlock();
        }
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    return YES;
}

- (void)getFootVersionSuccess:(void (^)(int page,NSArray *array))success Fail:(void (^)(NSString *errorMsg))fail
{
    ZCAccount *account = [ZCAccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/admin/article/secretary_list?page=%d&uid=%@",currentPage,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            int page = [[[responseObject objectForKey:@"page"] description] intValue];
            if (page == currentPage) {
                fail(@"暂无更多");
            }else{
                currentPage++;
                NSArray *modelArray = [VersionInfoModel mj_objectArrayWithKeyValuesArray:result];
                if (modelArray.count >= 1) {
                    success(page,modelArray);
                }else{
                    //fail(@"暂无更多消息");
                    [self.tableView.mj_header endRefreshing];
                }
            }
            
        }else{
            [self.tableView.mj_header endRefreshing];
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        fail(error.localizedDescription);
    }];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VersionInfoModel *model = self.array[indexPath.row];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (model.from == 1) {
        // 公告的：版本信息
        WorkSecretTableCell *cell = [WorkSecretTableCell sharedWorkCell:tableView];
        cell.versionModel = model;
        return cell;
    }else if (model.from == 2){
        // 客户发送
        FromUserTableCell *cell = [FromUserTableCell sharedUserCell:tableView];
        cell.versionModel = model;
        return cell;
    }else {
        // 服务器返回
        FromSystermTableCell *cell = [FromSystermTableCell sharedSystermCell:tableView];
        cell.versionModel = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VersionInfoModel *model = self.array[indexPath.row];
    if (model.from == 1) {
        // 公告的：版本信息
        SecreterWebViewController *secret = [[SecreterWebViewController alloc]initWithVersionModel:model];
        [self.navigationController pushViewController:secret animated:YES];
    }else if (model.from == 2){
        // 客户发送
        [self.view endEditing:YES];
    }else if (model.from == 3){
        // 服务器返回
        [self.view endEditing:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VersionInfoModel *model = self.array[indexPath.row];
    if (model.from == 1) {
        // 公告的：版本信息
        return 153 + 50;
    }else if (model.from == 2){
        // 客户发送
        CGSize textSize = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 51 - 80, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
        
        return textSize.height + 34 + 50;
    }else{
        // 服务器返回
        CGSize textSize = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 51 - 80, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
        return textSize.height + 34 + 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}



@end
