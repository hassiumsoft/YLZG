//
//  SuperSettingController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperSettingController.h"
#import <MJRefresh.h>
#import "WaichuTableCell.h"
#import <MJExtension.h>
#import "WholeSetModel.h"
#import "ZCAccountTool.h"
#import "TimeSliderView.h"
#import "HTTPManager.h"

@interface SuperSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *titleArray;

@property (strong,nonatomic) WholeSetModel *model;

@property (strong,nonatomic) UISwitch *outTipSwitchV;

@property (strong,nonatomic) UISwitch *isBangSwitchV;

@property (strong,nonatomic) TimeSliderView *sliderView;

@end

@implementation SuperSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高级设置";
    [self setupSubViews];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [YLNotificationCenter addObserver:self selector:@selector(timeObser:) name:KaoqinSettingNoti object:nil];
}
- (void)timeObser:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    NSString *key = [dict objectForKey:@"timeTypeKey"];
    NSString *value = [dict objectForKey:@"timeTypeValue"];
    if ([key isEqualToString:@"absent"]) {
        self.model.absent = value;
        [self.tableView reloadData];
    } else if([key isEqualToString:@"earlytime"]){
        self.model.earlytime = value;
        [self.tableView reloadData];
    }else if([key isEqualToString:@"latetime"]){
        self.model.latetime = value;
        [self.tableView reloadData];
    }else if ([key isEqualToString:@"privilege_time"]){
        self.model.privilege_time = value;
        [self.tableView reloadData];
    }else if ([key isEqualToString:@"offtip"]){
        self.model.offtip = value;
        [self.tableView reloadData];
    }else if ([key isEqualToString:@"ontip"]){
        self.model.ontip = value;
        [self.tableView reloadData];
    }
}
- (void)getData
{
    
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SuperSet_Url,account.userID];

    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSDictionary *dict = [responseObject objectForKey:@"whole"];
            self.model = [WholeSetModel mj_objectWithKeyValues:dict];
            [self.tableView reloadData];
        }else{
            [self showErrorTips:message];
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
    }];
    

}
- (void)setupSubViews
{
    self.titleArray = @[@[@"设置上班弹性时间",@"设置严重迟到时间",@"设置旷工时间"],@[@"是否绑定审批",@"外勤打卡通知"],@[@"上班打卡提醒",@"下班打卡提醒"],@[@"上班最早打卡时间"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 48;
    self.tableView.contentInset = UIEdgeInsetsMake(2, 0, 50, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 弹性上班时间privilege_time
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            int seconds = [self.model.privilege_time intValue];
            cell.infoLabel.text = [NSString stringWithFormat:@"%d分钟",seconds];
            return cell;
        }else if(indexPath.row == 1){
            // 严重迟到时间latetime
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            int seconds = [self.model.latetime intValue];
            cell.infoLabel.text = [NSString stringWithFormat:@"%d分钟",seconds];
            
            return cell;
        }else{
            // 旷工时间absent
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            int seconds = [self.model.absent intValue];
            cell.infoLabel.text = [NSString stringWithFormat:@"迟到%d分钟",seconds];
            
            return cell;
        }
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 是否绑定审批
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            [cell.infoLabel removeFromSuperview];
            [cell addSubview:self.isBangSwitchV];
            _isBangSwitchV.on = self.model.sply;
            
            return cell;
        }else{
            // 外勤打卡通知outtip
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.infoLabel removeFromSuperview];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            
            [cell addSubview:self.outTipSwitchV];
            _outTipSwitchV.on = self.model.outtip;
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            // 上班打卡提示ontip
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            int seconds = [self.model.ontip intValue];
            cell.infoLabel.text = [NSString stringWithFormat:@"提前%d分钟",seconds];
            return cell;
        }else{
            // 下班打卡提示offtip
            WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
            cell.label.text = self.titleArray[indexPath.section][indexPath.row];
            int seconds = [self.model.offtip intValue];
            cell.infoLabel.text = [NSString stringWithFormat:@"延后%d分钟",seconds];
            return cell;
        }
    }else{
        // 上班最早打卡时间earlytime
        WaichuTableCell *cell = [WaichuTableCell sharedWaichuCell:tableView];
        cell.label.text = self.titleArray[indexPath.section][indexPath.row];
        int seconds = [self.model.earlytime intValue];
        cell.infoLabel.text = [NSString stringWithFormat:@"弹性%d分钟",seconds];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 弹性上班时间
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            coverBtn.backgroundColor = CoverColor;
            [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
            [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
            [self.view.window addSubview:coverBtn];
            
            self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
            self.sliderView.timeTypeKey = @"privilege_time";
            [self.view.window addSubview:self.sliderView];
            
        }else if(indexPath.row == 1){
            // 严重迟到时间
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            coverBtn.backgroundColor = CoverColor;
            [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
            [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
            [self.view.window addSubview:coverBtn];
            
            self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
            self.sliderView.timeTypeKey = @"latetime";
            [self.view.window addSubview:self.sliderView];
            
        }else{
            // 旷工时间
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            coverBtn.backgroundColor = CoverColor;
            [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
            [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
            [self.view.window addSubview:coverBtn];
            
            self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
            self.sliderView.timeTypeKey = @"absent";
            [self.view.window addSubview:self.sliderView];
        }
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 是否绑定审批
            
        }else{
            // 外勤打卡通知
            
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            // 上班打卡提示
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            coverBtn.backgroundColor = CoverColor;
            [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
            [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
            [self.view.window addSubview:coverBtn];
            
            self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
            self.sliderView.timeTypeKey = @"ontip";
            [self.view.window addSubview:self.sliderView];
        }else{
            // 下班打卡提示
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            coverBtn.backgroundColor = CoverColor;
            [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
            [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
            [self.view.window addSubview:coverBtn];
            
            self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
            self.sliderView.timeTypeKey = @"offtip";
            [self.view.window addSubview:self.sliderView];
        }
    }else{
        // 上班最早打卡时间
        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        coverBtn.backgroundColor = CoverColor;
        [coverBtn addTarget:self action:@selector(removeSubViews:) forControlEvents:UIControlEventTouchUpInside];
        [coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
        [self.view.window addSubview:coverBtn];
        
        self.sliderView = [[TimeSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverBtn.frame), SCREEN_WIDTH, 80)];
        self.sliderView.timeTypeKey = @"earlytime";
        [self.view.window addSubview:self.sliderView];
    }
}
- (void)removeSubViews:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.sliderView removeFromSuperview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0 || section == 1) {
        return 28;
    } else if(section == 2){
        return 8;
    }else{
        return 110;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *array = @[@"上班后超过几分钟打开算弹性范围、严重迟到、旷工",@"绑定考勤类相关审批，系统将自动计算出勤情况、方便统计。",@"",@""];
    
    if (section == self.titleArray.count - 1) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH - 12, 21)];
        label.text = array[section];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [footView addSubview:label];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.backgroundColor = MainColor;
        [saveBtn setTitle:@"保存设置" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.layer.cornerRadius = 4;
        [saveBtn setFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 20, SCREEN_WIDTH - 40, 38)];
        [footView addSubview:saveBtn];
        
        return footView;
    }else{
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH - 12, 21)];
        label.text = array[section];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [footView addSubview:label];
        return footView;
    }
}
#pragma mark - 保存设置
- (void)saveAction
{
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:GaojiSetting_Url,account.userID,self.model.privilege_time,self.model.latetime,self.model.absent,self.model.ontip,self.model.offtip,self.model.earlytime,self.model.outtip,self.model.sply];
    KGLog(@"高级设置url = %@",url);
    
   
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    //                    [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                }];
            }else{
                [self sendErrorWarning:message];
            }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
 
    
}
- (UISwitch *)outTipSwitchV
{
    if (!_outTipSwitchV) {
        _outTipSwitchV = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 5, 44, 35)];
        _outTipSwitchV.onTintColor = MainColor;
        [_outTipSwitchV addTarget:self action:@selector(splySwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_outTipSwitchV setOn:YES animated:YES];
    }
    return _outTipSwitchV;
}
- (UISwitch *)isBangSwitchV
{
    if (!_isBangSwitchV) {
        _isBangSwitchV = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 5, 44, 35)];
        _isBangSwitchV.onTintColor = MainColor;
        [_isBangSwitchV addTarget:self action:@selector(bangSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_isBangSwitchV setOn:YES animated:YES];
    }
    return _isBangSwitchV;
}
- (void)splySwitchClick:(UISwitch *)sender
{
    self.model.outtip = sender.on;
    
    [self.tableView reloadData];
}
- (void)bangSwitchClick:(UISwitch *)sender
{
    self.model.sply = sender.on;
    
    [self.tableView reloadData];
}
@end
