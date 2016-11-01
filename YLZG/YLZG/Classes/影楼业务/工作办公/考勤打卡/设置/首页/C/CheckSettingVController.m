//
//  CheckSettingVController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/8.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "CheckSettingVController.h"
#import <Masonry.h>
#import "ChangeRulesController.h"
#import "ChengyuanChangeController.h"
#import "KaoqinTableCell.h"
#import "NormalTableCell.h"
#import "ChooseMemVController.h"
#import "AddKaoqinzuController.h"
#import "HomeNavigationController.h"
#import "ZCAccountTool.h"
#import "SVProgressHUD.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "KaoqinModel.h"
#import "SVProgressHUD.h"
#import "LCActionSheet.h"
#import <AFNetworking.h>
#import "TanxingPreViewController.h"
#import "HTTPManager.h"


@interface CheckSettingVController ()<UITableViewDelegate,UITableViewDataSource,KaoqinCellDelegate,LCActionSheetDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation CheckSettingVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤设置";
    [self getData];
}

- (void)getData
{
//    SearchKaoqunGroup_Url
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SearchKaoqunGroup_Url,account.userID];
 
    KGLog(@"url == %@",url);
    [self showHudMessage:@"加载中···"];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [SVProgressHUD dismiss];
            int code = [[[responseObject objectForKey:@"code"]description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                KGLog(@"message = %@",message);
                NSArray *array = [responseObject objectForKey:@"result"];
                // 有已经设置好的考勤组
                // 解析
                // NSArray *kkkk = [KaoqinModel mj_objectArrayWithKeyValuesArray:array];
                self.array = [KaoqinModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView reloadData];
                
            }else if(code == 0){
                [self.tableView reloadData];
            }else{
                [self sendErrorWarning:message];
            }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
    
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= 1) {
        KaoqinModel *model = self.array[indexPath.section - 1];
        KaoqinTableCell *cell = [KaoqinTableCell sharedKaoqinTableCell:tableView];
        cell.model = model;
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.label.text = @"添加考勤组";
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_addwifi"]];
        [cell addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).offset(-16);
            make.width.and.height.equalTo(@28);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        [cell.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
        }];
        return cell;
    }
    
}


#pragma mark - 点击代理-修改成员、规则
- (void)kaoqinDidClickType:(KaoqinClickType)type Model:(KaoqinModel *)model
{
    switch (type) {
        case EditGuizeType:
        {
            ChangeRulesController *changeRule = [ChangeRulesController new];
            [self.navigationController pushViewController:changeRule animated:YES];
            changeRule.model = model;
            break;
        }
        case ChangeMemType:
        {
            ChooseMemVController *changeRule = [ChooseMemVController new];
            HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:changeRule];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 添加考勤组
        AddKaoqinzuController *addKaoqin = [AddKaoqinzuController new];
        [self.navigationController pushViewController:addKaoqin animated:YES];
    }else{
//        // 编辑当前考勤组
//        KaoqinModel *model = self.array[indexPath.section - 1];
//        if ([model.type isEqualToString:@"1"]) {
//            // 固定班制1
//            PaibanPreViewController *paibanPre = [PaibanPreViewController new];
//            paibanPre.title = model.name;
//            [self.navigationController pushViewController:paibanPre animated:YES];
//        }else{
//            // 排班制2
//            TanxingPreViewController *tanxingPre = [TanxingPreViewController new];
//            tanxingPre.title = model.name;
//            [self.navigationController pushViewController:tanxingPre animated:YES];
//        }
        
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定删除该班次？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:^{
            KaoqinModel *model = self.array[indexPath.section - 1];
            // 删除当前考勤组 DeleteKaoqinzu_Url
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
            
            ZCAccount *account = [ZCAccountTool account];
            NSString *url = [NSString stringWithFormat:DeleteKaoqinzu_Url,account.userID,model.id];
            
            [self showHudMessage:@""];
          
            
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

                [SVProgressHUD dismiss];

                    int code = [[[responseObject objectForKey:@"code"] description] intValue];
                    if (code == 1) {
                        [self.array removeObjectAtIndex:indexPath.section - 1];
                        [self.tableView reloadData];
                    }else{
                        [SVProgressHUD dismiss];
                    }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
                [self sendErrorWarning:error.localizedDescription];
            }];
        }];
    }];
            
    NSArray *array = @[action];
    return array;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 1) {
        return 45;
    }else{
        return 245 - 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.array.count == 0) {
        return 25;
    }else{
        return 8;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    if (self.array.count == 0) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"添加考勤组仅限于影楼超级管理员账号";
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor lightGrayColor];
        [foot addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(foot.mas_right).offset(-20);
            make.centerY.equalTo(foot.mas_centerY);
            make.height.equalTo(@21);
        }];
    }
    return foot;
}

#pragma mark - 还没设置好
- (void)setupSettingView
{
//    work_set
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"work_set"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-80);
        make.width.and.height.equalTo(@100);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"当前影楼暂未设置考勤规则";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.textColor = RGBACOLOR(244, 198, 1, 1);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"设置规则" forState:UIControlStateNormal];
    button.backgroundColor = label.textColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button addTarget:self action:@selector(setGuize) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(35);
        make.top.equalTo(label.mas_bottom).offset(16);
        make.height.equalTo(@38);
    }];
    
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
#pragma mark - 前往设置规则
- (void)setGuize
{
    
}
@end
