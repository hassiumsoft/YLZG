//
//  TodayFinanceController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TodayFinanceController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "TodayFinaceModel.h"
#import "TodayFinaceDetialModel.h"
#import "NormalTableCell.h"
#import "TodayFinaceCell.h"
#import "SumFinaceTableCell.h"
#import "HuangzhuangBingTu.h"
#import "FinaceIconView.h"
#import "CaiwuDetialViewController.h"
#import <PDTSimpleCalendarViewController.h>

@interface TodayFinanceController ()<PDTSimpleCalendarViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 头部数组 */
@property (copy,nonatomic) NSArray *headArray;
/** 饼状图 */
@property (strong,nonatomic) HuangzhuangBingTu *bingtuV;

/** 定金 */
@property (strong,nonatomic) FinaceIconView *dingjinIconV;
/** 补款 */
@property (strong,nonatomic) FinaceIconView *bukuanIconV;
/** 二销 */
@property (strong,nonatomic) FinaceIconView *erxiaoIconV;
/** 其他 */
@property (strong,nonatomic) FinaceIconView *otherIconV;

/** 财务详细数据源 */
@property (copy,nonatomic) NSArray *detialArray;
/** 今日财务模型 */
@property (strong,nonatomic) TodayFinaceModel *finaceModel;

@property (strong,nonatomic) UIView *bingBottomV;

@end

@implementation TodayFinanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日财务";
    [self setupSubViews];
    NSString *date = [self getCurrentTime];
    [self getData:date];
    
}
#pragma mark - UI
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"change_calender"] style:UIBarButtonItemStylePlain target:self action:@selector(changeDate)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.headArray = @[@"今日财务",@"财务详情"];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return self.detialArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 今日财务概况
        if (indexPath.row == 0) {
            SumFinaceTableCell *cell = [SumFinaceTableCell sharedSumFinaceTableCell:tableView];
            cell.model = self.finaceModel;
            return cell;
        } else {
            // 饼图
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.xian removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            self.bingtuV = [[HuangzhuangBingTu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
            self.bingtuV.model = self.finaceModel;
            [cell.contentView addSubview:self.bingtuV];
            // 颜色
            
            [cell.contentView addSubview:self.bingBottomV];
            
            NSArray *titleArr = @[@"定金",@"补款",@"二销",@"其他"];
            
            NSArray *numArr = [self getNumArray];
            
            CGFloat spaceH = 1; // 横向间距
            CGFloat spaceZ = 6; // 纵向间距
            for (int i = 0; i < titleArr.count; i++) {
                CGRect frame;
                frame.size.width = self.view.width/2;
                frame.size.height = 25;
                frame.origin.x = (i%2) * (frame.size.width + spaceH) + spaceH;
                frame.origin.y = floor(i/2) * (frame.size.height + spaceZ) + 6;
                
                
                if (i == 0) {
                    [self.dingjinIconV setFrame:frame];
                    self.dingjinIconV.num = numArr[i];
                    [_bingBottomV addSubview:self.dingjinIconV];
                }else if (i == 1){
                    [self.bukuanIconV setFrame:frame];
                    self.bukuanIconV.num = numArr[i];
                    [_bingBottomV addSubview:self.bukuanIconV];
                }else if (i == 2){
                    [self.erxiaoIconV setFrame:frame];
                    self.erxiaoIconV.num = numArr[i];
                    [_bingBottomV addSubview:self.erxiaoIconV];
                }else{
                    [self.otherIconV setFrame:frame];
                    self.otherIconV.num = numArr[i];
                    [_bingBottomV addSubview:self.otherIconV];
                }
                
                
                
            }
            
            return cell;
            
        }
    } else {
        // 财务明细
        TodayFinaceCell *cell = [TodayFinaceCell sharedTodayFinaceCell:tableView];
        TodayFinaceDetialModel *model = self.detialArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}
- (FinaceIconView *)dingjinIconV
{
    if (!_dingjinIconV) {
        _dingjinIconV = [[FinaceIconView alloc]init];
        _dingjinIconV.color = RGBACOLOR(231, 74, 47, 1);
        _dingjinIconV.title = @"定金";
    }
    return _dingjinIconV;
}
- (FinaceIconView *)bukuanIconV
{
    if (!_bukuanIconV) {
        _bukuanIconV = [[FinaceIconView alloc]init];
        _bukuanIconV.color = RGBACOLOR(123, 223, 253, 1);
        _bukuanIconV.title = @"补款";
    }
    return _bukuanIconV;
}
- (FinaceIconView *)erxiaoIconV
{
    if (!_erxiaoIconV) {
        _erxiaoIconV = [[FinaceIconView alloc]init];
        _erxiaoIconV.color = RGBACOLOR(253, 151, 39, 1);
        _erxiaoIconV.title = @"二销";
    }
    return _erxiaoIconV;
}
- (FinaceIconView *)otherIconV
{
    if (!_otherIconV) {
        _otherIconV = [[FinaceIconView alloc]init];
        _otherIconV.color = RGBACOLOR(214, 143, 228, 1);
        _otherIconV.title = @"其他";
    }
    return _otherIconV;
}


- (NSArray *)getNumArray
{
    NSMutableArray *numArr = [NSMutableArray array];
    
    if (!([self.finaceModel.income intValue] > 0)) {
        for (int i = 0; i < 5; i++) {
            [numArr addObject:@"0"];
        }
        return numArr;
    }else{
        
        [numArr addObject:self.finaceModel.deposit];
        [numArr addObject:self.finaceModel.extra];
        [numArr addObject:self.finaceModel.tsell];
        [numArr addObject:self.finaceModel.other];
        [numArr addObject:self.finaceModel.trade];
        
        return numArr;
    }
    
}
- (UIView *)bingBottomV
{
    if (!_bingBottomV) {
        _bingBottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 70)];
        _bingBottomV.backgroundColor = [UIColor whiteColor];
        _bingBottomV.userInteractionEnabled = YES;
        
        
    }
    return _bingBottomV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    } else {
        CaiwuDetialViewController *caiwu = [CaiwuDetialViewController new];
        TodayFinaceDetialModel *model = self.detialArray[indexPath.row];
        caiwu.model = model;
        [self.navigationController pushViewController:caiwu animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 108;
        } else {
            return 280;
        }
    } else {
        return 60;
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [UIView new];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    [headV addSubview:xian];
    
    headV.backgroundColor = MainColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, SCREEN_WIDTH - 15, 30)];
    label.text = self.headArray[section];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [headV addSubview:label];
    return headV;
}
#pragma mark - 拿到数据源
- (void)getData:(NSString *)date
{
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.160/index.php/home/todayfinance/query?date=%@&uid=%@",date,[ZCAccountTool account].userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *dict = [responseObject objectForKey:@"finance"];
            NSArray *dictArray = [responseObject objectForKey:@"details"];
            
            self.finaceModel = [TodayFinaceModel mj_objectWithKeyValues:dict];
            self.detialArray = [TodayFinaceDetialModel mj_objectArrayWithKeyValuesArray:dictArray];
            
            [self.tableView reloadData];
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}

- (void)changeDate
{
    PDTSimpleCalendarViewController *calender = [[PDTSimpleCalendarViewController alloc]init];
    calender.title = @"点击切换日期";
    calender.delegate = self;
    calender.overlayTextColor = MainColor;
    calender.weekdayHeaderEnabled = YES;
    calender.firstDate = [NSDate dateWithHoursBeforeNow:6*30*24];
    calender.lastDate = [NSDate date];
    [self.navigationController pushViewController:calender animated:YES];
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *chooseDate = [time substringWithRange:NSMakeRange(0, 10)];
    
    [controller.navigationController popViewControllerAnimated:YES];
    self.title = chooseDate;
    self.headArray = @[chooseDate,@"财务详情"];
    [self getData:chooseDate];
}
#pragma mark - 比较2各日期的先后顺序
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}


@end
