//
//  ChooseBanciVController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChooseBanciVController.h"
#import "BanciSettingCell.h"
#import "NormalTableCell.h"
#import <Masonry.h>

#import "AddNewBanciController.h"
#import "HomeNavigationController.h"
#import <AFNetworking.h>
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "LCActionSheet.h"
#import "HTTPManager.h"

@interface ChooseBanciVController ()<BanciSettingDelegate,UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

/** 多选中的班次 */
@property (strong,nonatomic) NSMutableArray *selectedArr;

@end

@implementation ChooseBanciVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.type intValue] == 1) {
        // 固定班次
        self.title = @"单选固定班次";
    }else{
        // 排班制
        self.title = @"可多选多个班次";
        [self setupRightBar];
    }
    [self getData];
    [self setupSubViews];
    [YLNotificationCenter addObserver:self selector:@selector(getData) name:YLRequestData object:nil];
}

- (void)getData
{
    if (self.selectedArr.count >= 1) {
        [self.selectedArr removeAllObjects];
        [self setupRightBar];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:AllBanci_Url,account.userID];
    KGLog(@"url == %@",url);
    [self showHudMessage:@"努力加载中···"];

    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
            [MBProgressHUD hideHUD];

            int code = [[[responseObject objectForKey:@"code"]description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                NSArray *array = [responseObject objectForKey:@"result"];
                
                self.array = [BanciModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView reloadData];
            }else{
                [self sendErrorWarning:message];
               
            }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];

    
}


- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 48;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array.count; // 已经
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BanciModel *model = self.array[indexPath.row];
        BanciSettingCell *cell = [BanciSettingCell sharedBanciSettingCell:tableView];
        cell.model = model;
        cell.delegate = self;
        
        return cell;
    }else{
        // 新增班次
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = @"新增全局班次";
        cell.textLabel.textColor = RGBACOLOR(79, 143, 246, 1);
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_addwifi"]];
        [cell addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.width.and.height.equalTo(@30);
        }];
        return cell;
    }
    
}
#pragma mark - 去编辑班次代理
- (void)banciSetPushAction:(BanciModel *)model
{
    // 新增班次
    AddNewBanciController *addBanci = [AddNewBanciController new];
    HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:addBanci];
    addBanci.titleStr = [NSString stringWithFormat:@"编辑%@班次",model.classname];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([self.type intValue] == 1) {
            // 单选固定班次
            if ([self.delegate respondsToSelector:@selector(chooseOneBanciWithModel:)]) {
                BanciModel *model = self.array[indexPath.row];
                [self.delegate chooseOneBanciWithModel:model];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            // 多选弹性班次
            
            BanciModel *model = self.array[indexPath.row];
            if (model.isSelected) {
                model.isSelected = NO;
                [self.selectedArr removeObject:model];
            }else{
                model.isSelected = YES;
                [self.selectedArr addObject:model];
            }
            [self.array replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadData];
            
            [self setupRightBar];
            
        }
    }else{
        // 新增班次
        AddNewBanciController *addBanci = [AddNewBanciController new];
        HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:addBanci];
        addBanci.titleStr = @"新增全局班次";
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return  nil;
    }else{
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定删除该班次？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                BanciModel *model = self.array[indexPath.row];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
                ZCAccount *account = [ZCAccountTool account];
                NSString *url = [NSString stringWithFormat:DeleteOneBanci_Url,account.userID,model.classid];
                KGLog(@"url == %@",url);
                [self showHudMessage:@"处理中···"];
                [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

                    [MBProgressHUD hideHUD];
                        NSString *message = [responseObject objectForKey:@"message"];
                        int code = [[[responseObject objectForKey:@"code"] description] intValue];
                        if (code == 1) {
                            [MBProgressHUD hideHUD];
                            [self.array removeObjectAtIndex:indexPath.row];
                            [self.selectedArr removeAllObjects];
                            [self setupRightBar];
                            [self.tableView reloadData];
                        }else{
                            [self sendErrorWarning:message];
                        }
 

                } fail:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD hideHUD];
                    
                    [self sendErrorWarning:error.localizedDescription];
                }];
            }];
            
            [alertC addAction:action1];
            [alertC addAction:action2];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        
        }];
        NSArray *array = @[delete];
        return array;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    }else{
        return 0.1f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
        headLabel.text = @"   从全局班次中选中你想用的班次";
        headLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        headLabel.backgroundColor = self.view.backgroundColor;
        return headLabel;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}

- (void)setupRightBar
{
    NSString *kkk;
    if (self.selectedArr.count >= 1) {
        kkk = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)_selectedArr.count];
    }else{
        kkk = [NSString stringWithFormat:@"确定"];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:kkk style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

#pragma mark - 确定
- (void)rightBarClick
{
    if ([self.delegate respondsToSelector:@selector(chooseMoreBanciWithArray:)]) {
        
        [self.delegate chooseMoreBanciWithArray:self.selectedArr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)selectedArr
{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

@end
