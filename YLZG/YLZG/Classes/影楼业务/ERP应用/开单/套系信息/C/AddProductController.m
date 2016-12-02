//
//  AddProductController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AddProductController.h"
#import "NormalTableCell.h"
#import <MJExtension.h>
#import "AddProductCell.h"
#import "ZCAccountTool.h"
#import "AllProductModel.h"
#import <Masonry.h>
#import "HTTPManager.h"



@interface AddProductController ()<UITableViewDelegate,UITableViewDataSource,AddProductCellDelegate>

/** 母表格 */
@property (strong,nonatomic) UITableView *momTableV;
/** 子表格 */
@property (strong,nonatomic) UITableView *sonTableV;
/** 大数据源 */
@property (strong,nonatomic) NSMutableArray *momArray;
/** 子数据源 */
@property (strong,nonatomic) NSArray *sonArray;


@end

@implementation AddProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加套系产品";
    [self loadData];
    [self setupMomTableView];
    
}
#pragma mark - 获取数据
- (void)loadData
{
//    AFHTTPSessionManager
    self.momArray = [NSMutableArray array];
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:AllTaoxiProduct_Url,account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        if (status == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            
            for (NSDictionary *dic in result) {
                AllProductModel *model  = [AllProductModel mj_objectWithKeyValues:dic];
                [self->_momArray addObject:model];
            }
            
            [self.momTableV reloadData];
            
        }else{
            NSString *message = [[responseObject objectForKey:@"message"] description];
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
    
    
    
}
#pragma mark - 左边的表格
- (void)setupMomTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.definesPresentationContext = YES;
    
    self.momTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.34, SCREEN_HEIGHT - 64)];
    self.momTableV.backgroundColor = [UIColor whiteColor];
    self.momTableV.delegate = self;
    self.momTableV.dataSource = self;
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
        AllProductModel *model = self.momArray[indexPath.row];
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.label.text = model.name;
        [cell.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(12);
        }];
        [cell.xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
        }];
        
        return cell;
    }else{
        AddProductCell *cell = [AddProductCell sharedAddProductCell:tableView];
        cell.delegate = self;
        AllProductList *model = self.sonArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.momTableV) {
        // 先取数据，再刷新
        AllProductModel *model = self.momArray[indexPath.row];
        self.sonArray = model.productList;
        [self.sonTableV reloadData];
    }else{
        // 回调
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}

#pragma mark - AddProduct代理
- (void)addProduct:(AllProductList *)model
{
    // 自己再设置一个代理，把选中的模型传递给上一个界面
    if (self.DidBlock) {
        _DidBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableView *)sonTableV
{
    if (!_sonTableV) {
        _sonTableV = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34, 0, SCREEN_WIDTH * 0.66, SCREEN_HEIGHT - 64)];
        _sonTableV.backgroundColor = self.view.backgroundColor;
        _sonTableV.delegate = self;
        _sonTableV.dataSource = self;
        _sonTableV.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _sonTableV.rowHeight = 90.f;
        [self.view addSubview:_sonTableV];
        
    }
    return _sonTableV;
}


@end
