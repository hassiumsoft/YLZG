//
//  PreOrderVController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/10.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "PreOrderVController.h"
#import <Masonry.h>
#import "NormalTableCell.h"
#import <LCActionSheet.h>
#import "NSString+StrCategory.h"
#import "SearchTaoxiController.h"
#import "ZCAccountTool.h"
#import "ShekongBenController.h"
#import "HomeNavigationController.h"
#import <PDTSimpleCalendarViewController.h>
#import "HTTPManager.h"
#import "CalendarHomeViewController.h"
#import "ChooseTimeView.h"



@interface PreOrderVController ()<LCActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,SearOrderDelegate,PDTSimpleCalendarViewDelegate>
{
    UIButton *bottomBtn; // 确定预约按钮
    
}

/** UITableView */
@property (strong,nonatomic) UITableView *tableView;
/** 预约项目 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 选择时间 */
@property (strong,nonatomic) UILabel *timeLabel;


/** 订单IDLabel */
@property (strong,nonatomic) UILabel *orderIDLabel;
/** 项目对应的ID */
@property (assign,nonatomic) int typeID;

/** 数据源 */
@property (copy,nonatomic) NSArray *titleArr;

/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;



@end

@implementation PreOrderVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约";
    [self setupSubViews];
}


#pragma mark - 绘制UI
- (void)setupSubViews
{
    
    self.titleArr = @[@[@"预约项目：",@"选择时间："],@[@"订单编号：",@""]];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //  预约项目
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
            
            [cell addSubview:self.nameLabel];
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-30);
                make.height.equalTo(@22);
            }];
            return cell;
        }else{
            //  选择时间
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
            [cell addSubview:self.timeLabel];
            [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-30);
                make.height.equalTo(@22);
            }];
            return cell;
        }
    }else {
        if (indexPath.row == 0) {
            // 订单ID
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
            [cell addSubview:self.orderIDLabel];
            [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-30);
                make.height.equalTo(@40);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            return cell;
            
        }else{
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            cell.backgroundColor = self.view.backgroundColor;
            bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bottomBtn.backgroundColor = MainColor;
            bottomBtn.layer.cornerRadius = 4;
            [bottomBtn setTitle:@"确定预约" forState:UIControlStateNormal];
            [bottomBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:bottomBtn];
            [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.mas_centerX);
                make.bottom.equalTo(cell.mas_bottom).offset(-25);
                make.left.equalTo(@25);
                make.height.equalTo(@40);
            }];
            return cell;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    } else{
        if (indexPath.row == 0) {
            return 55;
        }else{
            return SCREEN_HEIGHT - (55 + 8) * 3 - 80;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 选择项目
            
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"请选择预约项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"选片",@"看样",@"取件", nil];
            [sheet show];
            
        }else{
            // 选择时间
            PDTSimpleCalendarViewController *calendar = [PDTSimpleCalendarViewController new];
            calendar.title = @"预计到店时间";
            calendar.delegate = self;
            calendar.overlayTextColor = MainColor;
            calendar.weekdayHeaderEnabled = YES;
            calendar.firstDate = [NSDate date];
            calendar.lastDate = [NSDate dateWithHoursFromNow:2*30*24]; // 8个月
            
            [self.navigationController pushViewController:calendar animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            // 选择订单ID
            SearchTaoxiController *searchTaoxi = [[SearchTaoxiController alloc]init];
            searchTaoxi.delegate = self;
            
            [self.navigationController pushViewController:searchTaoxi animated:YES];
            
        }
    }
}

//- (void)ChangeDate
//{
//    ZCAccount * account = [ZCAccountTool account];
//    NSString * url = [NSString stringWithFormat:ShekongRili_Url, account.userID, [self getCurrentTime], [self delayThirty],(int)(self.typeID + 1)];
//    KGLog(@"url = %@",url);
//    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        CalendarHomeViewController *calender = [[CalendarHomeViewController alloc]init];
//        if (self.typeID == 1) {
//            calender.calendartitle = @"查看拍照预约数";
//        } else if(self.typeID == 2){
//            calender.calendartitle = @"查看选片预约数";
//        }else if (self.typeID == 3){
//            calender.calendartitle = @"查看化妆预约数";
//        }else{
//            calender.calendartitle = @"查看取件预约数";
//        }
//        [calender.planArray removeAllObjects];
//        calender.planArray = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"result"]];
//        [calender setAirPlaneToDay:365 ToDateforString:nil];
//        __weak PreOrderVController * weakSelf = self;
//        calender.calendarblock = ^(CalendarDayModel *model){
//            NSString *chooseDate = [NSString stringWithFormat:@"%@",[model toString]];
//            if (model.holiday) {
//                self.title = [NSString stringWithFormat:@"摄控本(%@)",model.holiday];
//            }else{
//                self.title = [NSString stringWithFormat:@"摄控本(%@)",chooseDate];
//            }
//            
//            NSString *currentDate = weakSelf.timeLabel.text;
//            if ([currentDate isEqualToString:chooseDate]) {
//                return ;
//            }
//            weakSelf.timeLabel.text = chooseDate;
//            
//            // 通知控制器刷新数据
//            
//            
//        };
//        
//        [self.navigationController pushViewController:calender animated:YES];
//        
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showErrorTips:error.localizedDescription];
//    }];
//}
//- (NSString *)delayThirty {
//    int addDays = 29;
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * str = [self getCurrentTime];
//    NSDate * myDate = [dateFormatter dateFromString:str];
//    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * addDays];
//    
//    NSString * returnStr = [dateFormatter stringFromDate:newDate];
//    return returnStr;
//}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *chooseDate = [time substringWithRange:NSMakeRange(0, 10)];
    
    // 在选择时间
    ChooseTimeView *timeView = [ChooseTimeView sharedChooseTimeView];
    timeView.DidSelectTime = ^(NSString *time){
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",chooseDate,time];
        [self.tableView reloadData];
        [controller.navigationController popViewControllerAnimated:YES];
    };
    [controller.view addSubview:timeView];
    
}
#pragma mark - 订单ID的回调
- (void)searchOrderModel:(SearchViewModel *)model
{
    self.orderIDLabel.text = model.tradeID;
    
    [self.tableView reloadData];
    
}
- (void)detialOrderModel:(SearchOrderModel *)model
{
    self.orderIDLabel.text = model.tradeid;
    [self.tableView reloadData];
}

#pragma mark - 选择套系名称
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            self.nameLabel.text = @"拍照";
            self.typeID = 1;
            [self.tableView reloadData];
            break;
        }
        case 2:
        {
            self.nameLabel.text = @"选片";
            self.typeID = 2;
            [self.tableView reloadData];
            break;
        }
        case 3:
        {
            self.nameLabel.text = @"看样";
            self.typeID = 3;
            [self.tableView reloadData];
            break;
        }
        case 4:
        {
            self.nameLabel.text = @"取件";
            self.typeID = 4;
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
        
}
#pragma mark - 确定预约
- (void)yuyueAction:(UIButton *)sender
{
    
    if ([self.nameLabel.text isEqualToString:@"选择预约项目"]) {
        [self sendErrorWarning:@"请选择预约项目"];
        return;
    }
    if ([self.timeLabel.text isEqualToString:@"预计到店时间"]) {
        [self sendErrorWarning:@"请选择预计到店时间"];
        return;
    }
    if ([self.orderIDLabel.text isEqualToString:@"根据号码查询"]) {
        [self sendErrorWarning:@"请输入号码查询订单编号"];
        return;
    }
    
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *date = [self.timeLabel.text substringWithRange:NSMakeRange(0, 10)];
    NSString *time = [self.timeLabel.text substringWithRange:NSMakeRange(11, 5)];
    NSString *url = [NSString stringWithFormat:Yuyue_URL,self.orderIDLabel.text,self.typeID,date,time,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确定预约" forState:UIControlStateNormal];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        if (status == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
            
        }else{
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.indicatorV stopAnimating];
        [self sendErrorWarning:error.localizedDescription];
        [sender setTitle:@"确定预约" forState:UIControlStateNormal];
    }];
    
    
    
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [bottomBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->bottomBtn.mas_centerX);
            make.centerY.equalTo(self->bottomBtn.mas_centerY);
            make.width.and.height.equalTo(@40);
        }];
    }
    return _indicatorV;
}

#pragma mark - 懒加载
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"选择预约项目";
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"预计到店时间";
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UILabel *)orderIDLabel
{
    if (!_orderIDLabel) {
        _orderIDLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _orderIDLabel.text = @"根据号码查询";
        _orderIDLabel.textColor = [UIColor grayColor];
        _orderIDLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _orderIDLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderIDLabel;
}

@end
