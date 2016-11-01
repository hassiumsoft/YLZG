//
//  TanxingBanciSettingController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TanxingBanciSettingController.h"
#import "HomeNavigationController+RightGesture.h"
#import "StaffInfoModel.h"
#import "TanxingPaibanCell.h"
#import "BanciModel.h"
#import "SubTitleView.h"
#import <MJExtension.h>



#define marginNum 1

@interface TanxingBanciSettingController ()<UITableViewDelegate,UITableViewDataSource,TanxingDelegate>
/** cell的scrollview */
@property (strong,nonatomic) UIScrollView *cellScrollV;
/** 头部的scrollview */
//@property (strong,nonatomic) UIScrollView *headScrollV;
/** 底部按钮数组 */
@property (strong,nonatomic) NSMutableArray *btnArray;
/** 选中的班次模型 */
@property (strong,nonatomic) BanciModel *banciModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

/** 装着日期的数组 */
@property (strong,nonatomic) NSMutableArray *weekArray;

/** 装着完整日期的数组 */
@property (strong,nonatomic) NSMutableArray *dateArray;
/** 装着rules的数组 */
@property (strong,nonatomic) NSMutableArray *rulesArray;


@end

@implementation TanxingBanciSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"弹性班次设置";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 导航键相关
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    navView.backgroundColor = MainColor;
    [self.view addSubview:navView];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_nav"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(20, 0, 30, 20)];
    [navView addSubview:backBtn];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 20)];
    [navView addSubview:saveBtn];
    
    /********* 底部的视图 ********/
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 75, 90, 40)];
    chooseLabel.text = @"选中班次：";
    chooseLabel.backgroundColor = [UIColor whiteColor];
    chooseLabel.font = [UIFont systemFontOfSize:15];
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:chooseLabel];
    
    
    UIScrollView *bottomV = [[UIScrollView alloc]initWithFrame:CGRectMake(90, SCREEN_HEIGHT - 75, SCREEN_WIDTH - 90, 40)];
    bottomV.userInteractionEnabled = YES;
    bottomV.bounces = NO;
    bottomV.showsVerticalScrollIndicator = NO;
    bottomV.showsHorizontalScrollIndicator = NO;
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    
//    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 74, SCREEN_WIDTH, 1)];
//    xian.backgroundColor = RGBACOLOR(31, 139, 229, 0.7f);
//    [self.view addSubview:xian];
    
    CGFloat spaceH = 4; // 横向间距
    
    // 加一个休息按钮
    BanciModel *restModel = [BanciModel new];
    restModel.classid =@"";
    restModel.classname = @"休息";
    restModel.start = @"";
    restModel.end = @"";
    [self.banciModelArray addObject:restModel];
    
    CGFloat lastX = 0; // 上个按钮的X
    CGFloat lastW = 0; // 上个按钮的宽
    CGFloat Y = 5;
    
    for (int i = 0; i < self.banciModelArray.count; i++) {
        
        BanciModel *model = self.banciModelArray[i];
        
        UIButton *banciBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        banciBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        
        [banciBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            banciBtn.backgroundColor = MainColor;
            [banciBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        banciBtn.tag = i;
        banciBtn.layer.cornerRadius = 4;
        banciBtn.layer.borderColor = MainColor.CGColor;
        banciBtn.layer.borderWidth = 1.f;
        [banciBtn addTarget:self action:@selector(chooseBanciBtn:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = model.classname;
        [banciBtn setTitle:title forState:UIControlStateNormal];
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 2, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
        
        
        CGFloat W = rect.size.width;
        CGFloat X = lastX + lastW + 10;
        banciBtn.frame = CGRectMake(X, Y, W, 30);
        
        lastW = rect.size.width;
        lastX = X;
        
        bottomV.contentSize = CGSizeMake(spaceH * (self.banciModelArray.count + 1) + W * self.banciModelArray.count, 40);
        [bottomV addSubview:banciBtn];
        [self.btnArray addObject:banciBtn];
    }
    
    self.banciModel = [self.banciModelArray firstObject];
    
    // 表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 50.f;
    [self.view addSubview:self.tableView];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectZero];
    headV.backgroundColor = self.view.backgroundColor;
    
    CGRect topFrame;
    CGFloat topBtnW = (SCREEN_WIDTH - 7*marginNum)/8;
    for (int i = 0; i < self.weekArray.count; i++) {
        
        topFrame.origin.x = (i%8) * (topBtnW + marginNum) + marginNum;
        topFrame.origin.y = 2;
        topFrame.size.width = topBtnW;
        topFrame.size.height = 47;
        
        
        if (i == 0) {
            UILabel *firstLabel = [[UILabel alloc]initWithFrame:topFrame];
            firstLabel.text = self.weekArray[i];
            firstLabel.backgroundColor = [UIColor whiteColor];
            firstLabel.textAlignment = NSTextAlignmentCenter;
            [headV addSubview:firstLabel];
        }else{
            NSDictionary *dict = self.weekArray[i];
            NSString *week = [[dict objectForKey:@"week"] description];
            NSString *date = [[dict objectForKey:@"date"] description];
            SubTitleView *label = [SubTitleView sharedWithFrame:topFrame Week:week Date:date];
            [headV addSubview:label];
        }
        
    }
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

#pragma mark - 表格相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.membersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfoModel *memModel = self.membersArray[indexPath.row];
    TanxingPaibanCell *cell = [TanxingPaibanCell shatedTanxingPaibanCell:tableView MemModel:memModel BanciModel:self.banciModel DateArray:self.dateArray];
    cell.delegate = self;
    cell.memModel = memModel;
    cell.banciModel = self.banciModel;
    cell.dateArray = [NSArray arrayWithArray:self.dateArray];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 弹性班制的回调
- (void)tanxingPaibanWithRulesDict:(NSDictionary *)rulesDict
{
    [self.rulesArray addObject:rulesDict];
    if (self.rulesArray.count == self.membersArray.count) {
        KGLog(@"%@",_rulesArray);
        KGLog(@"%@",_rulesArray);
    }
}
#pragma mark - 选中班次
- (void)chooseBanciBtn:(UIButton *)sender
{
    for (UIButton *button in self.btnArray) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = MainColor.CGColor;
        button.layer.borderWidth = 1.f;
    }
    sender.backgroundColor = MainColor;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.banciModel = self.banciModelArray[sender.tag];
//    NSString *name = [NSString stringWithFormat:@"%@-%@",self.banciModel.start,self.banciModel.end];
//    [sender setTitle:name forState:UIControlStateNormal];
    
    [YLNotificationCenter postNotificationName:KQPaibanciChanged object:self.banciModel];
    
}
#pragma mark - 保存方案
- (void)save
{
    if (self.rulesArray.count != self.membersArray.count) {
        [self sendErrorWarning:@"请填满班次"];
    }else{
        // 转成json串,传递给上个界面
        NSString *rulesJson = [self toJsonStr:self.rulesArray];
        if ([self.delegate respondsToSelector:@selector(tanxingBanxiWithRulesJson:)]) {
            [self.delegate tanxingBanxiWithRulesJson:rulesJson];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
        
    }
    return _btnArray;
}
- (NSMutableArray *)banciModelArray
{
    if (!_banciModelArray) {
        _banciModelArray = [[NSMutableArray alloc]init];
    }
    return _banciModelArray;
}
- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}
- (NSMutableArray *)weekArray
{
    if (!_weekArray) {
        _weekArray = [[NSMutableArray alloc]init];
    }
    return _weekArray;
}
#pragma mark - 获取星期数
- (void)getFurtherWeek
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate * today = [NSDate date];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    for (int i = 0; i < 7; i ++) {
        NSString *dateString = [myDateFormatter stringFromDate:[today dateByAddingTimeInterval:i * secondsPerDay]];
        NSString *dateNoYear = [dateString substringWithRange:NSMakeRange(5, 5)];
        NSString *allDate = [dateString substringWithRange:NSMakeRange(0, 10)];
        NSString *week = [self featureWeekdayWithDate:dateString];
        
        //        KGLog(@"dateNoYear = %@,week = %@",dateNoYear,week);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"week"] = week;
        dict[@"date"] = dateNoYear;
        [self.dateArray addObject:allDate];
        [self.weekArray addObject:dict];
    }
    
    [self.weekArray insertObject:@"姓名" atIndex:0];
    
}

- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy/MM/dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    if (week >= 8) {
        week = week - 7;
    }
    KGLog(@"wwwwwwwwwwweek = %ld",week);
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            return @"周日";
            break;
    }
    return nil;
}

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        KGLog(@"0天0小时0分钟");
        return 0;
    }
    else {
//        KGLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}


#pragma mark - 其他设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFurtherWeek];
//    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.hidesBarsWhenVerticallyCompact = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}
- (NSMutableArray *)rulesArray
{
    if (!_rulesArray) {
        _rulesArray = [[NSMutableArray alloc]init];
    }
    return _rulesArray;
}

/******* 屏幕旋转设置 ********/
//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIDeviceOrientationLandscapeRight;
//}

- (void)dismiss
{
    if (self.rulesArray.count >= 1) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"放弃当前编辑？" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
@end
