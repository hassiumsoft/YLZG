//
//  MyApproveVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyApproveVController.h"
#import "ZCAccountTool.h"
#import "NormalTableCell.h"
#import "AppearHeadView.h"
#import "HTTPManager.h"
#import "ApproveModel.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "QingjiaViewController.h"
#import "WaichuViewController.h"
#import "WuPingViewController.h"
#import "CommonApplyController.h"
#import "ApproveListViewController.h"


@interface MyApproveVController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) AppearHeadView *headView;

/** 待我审批数组 */
@property (strong,nonatomic) NSMutableArray *waitArray;
/** 我已审批 */
@property (strong,nonatomic) NSMutableArray *appredArr;
/** 我发起的 */
@property (strong,nonatomic) NSMutableArray *myApplyArr;

@end

@implementation MyApproveVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批";
    [self setupSubViews];
    [self getData];
}
- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url1 = [NSString stringWithFormat:ShenpiWait_URL,account.userID];
    NSString *url2 = [NSString stringWithFormat:ShenpiAlready_URL,account.userID];
    NSString *url3 = [NSString stringWithFormat:ShenpiStart_URL,account.userID];

    dispatch_async(ZCGlobalQueue, ^{
        [HTTPManager GET:url1 params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            
            if (code == 1) {
                NSArray *tempArray = [responseObject objectForKey:@"result"];
                if (tempArray.count >= 1) {
                    self.waitArray = [ApproveModel mj_objectArrayWithKeyValuesArray:tempArray];
                    self.headView.waitArray = self.waitArray;
                }else{
                    // 0.0.0
                    
                }
            }else{
                // 0.0.0
                
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            // 0.0.0
            
        }];
    });
    
    dispatch_async(ZCGlobalQueue, ^{
        [HTTPManager GET:url2 params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            
            if (code == 1) {
                NSArray *tempArray = [responseObject objectForKey:@"result"];
                if (tempArray.count >= 1) {
                    self.appredArr = [ApproveModel mj_objectArrayWithKeyValuesArray:tempArray];
                    self.headView.appredArr = self.appredArr;
                }else{
                    // 0.0.0
                    
                }
            }else{
                // 0.0.0
                
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            // 0.0.0
            
        }];
    });
    
    dispatch_async(ZCGlobalQueue, ^{
        [HTTPManager GET:url3 params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            
            if (code == 1) {
                NSArray *tempArray = [responseObject objectForKey:@"result"];
                if (tempArray.count >= 1) {
                    self.myApplyArr = [ApproveModel mj_objectArrayWithKeyValuesArray:tempArray];
                    self.headView.myApplyArr = self.myApplyArr;
                }else{
                    // 0.0.0
                    
                }
            }else{
                // 0.0.0
                
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            // 0.0.0
            
        }];
    });
    
}



#pragma mark - 表格
- (void)setupSubViews
{
    self.array = @[@"请假",@"外出",@"物品领用",@"通用"];
    [self.view addSubview:self.tableView];
    
    self.headView = [[AppearHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    __block typeof(self) weakSelf = self;
    self.headView.ClickBlock = ^(AppearType type){
        switch (type) {
            case WaitAppearType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.index = 0;
                app.title = @"待我审批";
                app.array = weakSelf.waitArray;
                app.RefreshData = ^(NSArray *newArray){
                    [weakSelf.waitArray removeAllObjects];
                    weakSelf.waitArray = (NSMutableArray *)newArray;
                    weakSelf.headView.waitArray = weakSelf.waitArray;
                };
                [weakSelf.navigationController pushViewController:app animated:YES];
                break;
            }
            case AppearedType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.title = @"我已审批";
                app.index = 1;
                app.array = weakSelf.appredArr;
                app.RefreshData = ^(NSArray *newArray){
                    [weakSelf.appredArr removeAllObjects];
                    weakSelf.appredArr = (NSMutableArray *)newArray;
                    weakSelf.headView.appredArr = weakSelf.appredArr;
                };
                [weakSelf.navigationController pushViewController:app animated:YES];
                break;
            }
            case MyApplyType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.index = 2;
                app.title = @"我发起的";
                app.array = weakSelf.myApplyArr;
                app.RefreshData = ^(NSArray *newArray){
                    [weakSelf.myApplyArr removeAllObjects];
                    weakSelf.myApplyArr = (NSMutableArray *)newArray;
                    weakSelf.headView.myApplyArr = weakSelf.myApplyArr;
                };
                [weakSelf.navigationController pushViewController:app animated:YES];
                break;
            }
                
            default:
                break;
        }
    };
    self.tableView.tableHeaderView = self.headView;
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
    NSArray *iconArr = @[@"btn_leave",@"btn_go_out",@"btn_items_of_recipients",@"btn_general"];
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    [cell.xian removeFromSuperview];
    cell.imageV.image = [UIImage imageNamed:iconArr[indexPath.row]];
    [cell.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    cell.label.text = self.array[indexPath.row];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        QingjiaViewController *qingjia = [QingjiaViewController new];
        [self.navigationController pushViewController:qingjia animated:YES];
    } else if(indexPath.row == 1){
        WaichuViewController *waichu = [WaichuViewController new];
        [self.navigationController pushViewController:waichu animated:YES];
    }else if (indexPath.row == 2){
        WuPingViewController *wuping = [WuPingViewController new];
        [self.navigationController pushViewController:wuping animated:YES];
    }else{
        CommonApplyController *comm = [CommonApplyController new];
        [self.navigationController pushViewController:comm animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectNull];
    head.backgroundColor = self.view.backgroundColor;
    return head;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

- (NSMutableArray *)waitArray
{
    if (!_waitArray) {
        _waitArray = [[NSMutableArray alloc]init];
    }
    return _waitArray;
}
- (NSMutableArray *)appredArr
{
    if (!_appredArr) {
        _appredArr = [[NSMutableArray alloc]init];
    }
    return _appredArr;
}
- (NSMutableArray *)myApplyArr
{
    if (!_myApplyArr) {
        _myApplyArr = [[NSMutableArray alloc]init];
    }
    return _myApplyArr;
}

@end
