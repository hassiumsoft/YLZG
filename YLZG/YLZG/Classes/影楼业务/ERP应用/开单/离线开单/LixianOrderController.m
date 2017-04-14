//
//  LixianOrderController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "LixianOrderController.h"
#import <LCActionSheet.h>
#import "OfflineDataManager.h"
#import "HTTPManager.h"
#import "NormalIconView.h"
#import "OffLineOrder.h"
#import "ClearCacheTool.h"
#import "OfflineOrderTableCell.h"
#import <Masonry.h>

@interface LixianOrderController ()<UITableViewDataSource,UITableViewDelegate,LCActionSheetDelegate>


/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 选中的数组 */
@property (strong,nonatomic) NSMutableArray *selectArray;




@end

@implementation LixianOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离线订单";
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    
    NSArray *array = [OfflineDataManager getAllOffLineOrderFromSandBox];
    self.array = [NSMutableArray arrayWithArray:array];
    if (self.array.count >= 1) {
        [self.view addSubview:self.tableView];
    }else{
        [self CreateEmptyView:@"还没有离线订单"];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendOrder)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}
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
    
    OffLineOrder *model = self.array[indexPath.section];
    OfflineOrderTableCell *cell = [OfflineOrderTableCell sharedOfflineOrderCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OffLineOrder *model = self.array[indexPath.section];
    if (model.isSelect) {
        model.isSelect = NO;
    }else{
        model.isSelect = YES;
    }
    
    [self.array replaceObjectAtIndex:indexPath.section withObject:model];
    [self.tableView reloadData];
    
    [self.selectArray removeAllObjects];
    for (OffLineOrder *model in self.array) {
        if (model.isSelect) {
            [self.selectArray addObject:model];
        }
    }
    [self setupRightBar:self.selectArray];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OffLineOrder *model = self.array[indexPath.section];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"除移" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除该产品
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定删除该订单？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 先删除数据库
                BOOL result = [OfflineDataManager deleteOrderAtIndex:model.id];
                if (result) {
                    [self.array removeObjectAtIndex:indexPath.section];
                    if (self.array.count > 0) {
                        [self.tableView reloadData];
                    }else{
                        [self CreateEmptyView:@"暂无离线订单"];
                        
                    }
            }
                
            }
        } otherButtonTitles:@"确定删除", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *jiajiAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"📱" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 联系客户
        
        NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.mobile]];
        UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
        [self.view addSubview:phoneWebView];
        
    }];
    jiajiAction.backgroundColor = [UIColor brownColor];
    
    return @[deleteAction,jiajiAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footV = [[UIView alloc]init];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (UITableView *)tableView
{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 120;
    }
    return _tableView;
}
- (void)CreateEmptyView:(NSString *)message
{
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (void)setupRightBar:(NSArray *)selectOrderArr
{
    if (selectOrderArr.count < 1) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    NSString *message = [NSString stringWithFormat:@"发送(%ld)",(unsigned long)selectOrderArr.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:message style:UIBarButtonItemStylePlain target:self action:@selector(sendOrder)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}
#pragma mark - 发送订单
- (void)sendOrder
{
    if (self.selectArray.count < 1) {
        [self showErrorTips:@"请选中订单"];
        return;
    }
    
    [MBProgressHUD showMessage:@"上传订单中···"];
    dispatch_async(ZCGlobalQueue, ^{
        for (int i = 0; i < self.selectArray.count; i++) {
            OffLineOrder *model = self.selectArray[i];
            [HTTPManager GET:model.allUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *message = [[responseObject objectForKey:@"message"] description];
                int status = [[[responseObject objectForKey:@"code"] description] intValue];
                
                if (status == 1) {
                    
                    [MBProgressHUD hideHUD];
                    // 除移
                    BOOL result = [OfflineDataManager deleteOrderAtIndex:model.id];
                    if (result) {
                        [self.array removeAllObjects];
                        NSArray *tempArr = [OfflineDataManager getAllOffLineOrderFromSandBox];
                        if (tempArr.count >=1 ) {
                            self.array = [NSMutableArray arrayWithArray:tempArr];
                            [self.tableView reloadData];
                        }else{
                            [self.tableView removeFromSuperview];
                            [self setupRightBar:self.selectArray];
                            [self CreateEmptyView:@"暂无离线订单"];
                        }
                        
                    }
                }else{
                    [MBProgressHUD hideHUD];
                    [self sendErrorWarning:message];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [self sendErrorWarning:error.localizedDescription];
            }];
            
            
        }
    });
    
}
@end
