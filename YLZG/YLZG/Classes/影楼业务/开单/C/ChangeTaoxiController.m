//
//  ChangeTaoxiController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ChangeTaoxiController.h"
#import "ZCAccountTool.h"
#import "TaoxiModel.h"
#import <MJExtension.h>
#import "NormalTableCell.h"
#import "SVProgressHUD.h"
#import <FMDB.h>
#import "HTTPManager.h"

@interface ChangeTaoxiController ()<UITableViewDelegate,UITableViewDataSource>
/** 母表格 */
@property (strong,nonatomic) UITableView *momTableV;
/** 子表格 */
@property (strong,nonatomic) UITableView *sonTableV;
/** 大数据源 */
@property (strong,nonatomic) NSMutableArray *momArray;
/** 子数据源 */
@property (strong,nonatomic) NSArray *sonArray;

/** 依次离线缓存 */
@property (strong,nonatomic) NSMutableArray *lixianArray;

@end

@implementation ChangeTaoxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择套系";
    
    [self loadData];
}


#pragma mark - 获取数据
- (void)loadData
{
    // 先判断沙盒是否有数据
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SearchTaoxi_URL,account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        if (status == 1) {
            // 解析成功
            NSArray *jsonArr = [responseObject objectForKey:@"result"];
            if (jsonArr.count < 1) {
                [self sendErrorWarning:@"您的影楼暂未设置套系名称，请前往ERP客户端设置。"];
            }else{
                self.momArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in jsonArr) {
                    TaoxiModel *model  = [TaoxiModel mj_objectWithKeyValues:dic];
                    [self.momArray addObject:model];
                    
                }
                
                // 绘制选择套系的嵌套TableView
                [self setupMomTableView];
                
                // 绘制rightbar
                
            }
        }else{
            [self sendErrorWarning:@"获取失败"];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}
#pragma mark - 绘制母表格
- (void)setupMomTableView
{
    self.momTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.34, self.view.height)];
    self.momTableV.backgroundColor = [UIColor whiteColor];
    self.momTableV.delegate = self;
    self.momTableV.dataSource = self;
    self.momTableV.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.momTableV.rowHeight = 50.f;
    [self.view addSubview:self.momTableV];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.momTableV) {
        return self.momArray.count;
    } else {
        return self.sonArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.momTableV) {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        TaoxiModel *model = self.momArray[indexPath.row];
        cell.textLabel.text = model.set;
        return cell;
    }else{
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        TaoxiNamePrice *model = self.sonArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@  ￥%@",model.set_name,model.set_price];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.momTableV) {
        // 先取数据，再刷新
        TaoxiModel *model = self.momArray[indexPath.row];
        self.sonArray = model.child_set;
        [self.sonTableV reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 回调
        TaoxiNamePrice *namePrice = self.sonArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(changeTaoxiModel:)]) {
            [self.delegate changeTaoxiModel:namePrice];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UITableView *)sonTableV
{
    if (!_sonTableV) {
        _sonTableV = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34, 0, SCREEN_WIDTH * 0.66, self.view.height)];
        _sonTableV.backgroundColor = self.view.backgroundColor;
        _sonTableV.delegate = self;
        _sonTableV.dataSource = self;
        UIView *kk = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.66, 12)];
        kk.backgroundColor = [UIColor whiteColor];
        _sonTableV.tableHeaderView = kk;
        _sonTableV.rowHeight = 50.f;
        [self.view addSubview:_sonTableV];
        
    }
    return _sonTableV;
}
- (NSMutableArray *)lixianArray
{
    if (!_lixianArray) {
        _lixianArray = [NSMutableArray array];
    }
    return _lixianArray;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"一键缓存" style:UIBarButtonItemStylePlain target:self action:@selector(lixianAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}
#pragma mark - 先获取全部套系下产品，为离线做准备
- (void)lixianAction
{
    [self showHudMessage:@"操作中"];
    
    NSMutableArray *taoxiNameArr = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (TaoxiModel *model in self.momArray) {
        [tempArr addObjectsFromArray:model.child_set];
    }
    
    for (TaoxiNamePrice *model in tempArr) {
        [taoxiNameArr addObject:model.set_name];
    }
    
    ZCAccount *account = [ZCAccountTool account];
    for (NSString *taoxiName in taoxiNameArr) {
        //    self.taoName = @"";  // ⚠️⚠️后面需要注释⚠️⚠️
        NSString *str = [NSString stringWithFormat:TaoxiProduct_Url,taoxiName,account.userID];
        
        dispatch_async(ZCGlobalQueue, ^{
            [HTTPManager GETCache:str params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                int status = [[[responseObject objectForKey:@"code"] description] intValue];
                if (status == 1) {
                    KGLog(@"json成功 = %@",responseObject);
                }else{
                    KGLog(@"json失败 = %@",responseObject);
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [self showErrorTips:error.localizedDescription];
            }];
        });
        
  }
    
    [self hideHud:0];
    
    [self sendErrorWarning:@"产品列表缓存成功，在无网络状况时您也可实现开单。"];
    
}

@end
