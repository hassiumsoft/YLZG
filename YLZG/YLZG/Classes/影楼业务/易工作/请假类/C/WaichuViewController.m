//
//  WaichuViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WaichuViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "ShenpiersViewController.h"
#import "CalendarHomeViewController.h"
#import "WorkTableViewCell.h"
#import <LCActionSheet.h>
#import <Masonry.h>


#define TitlePlace @"外出理由将以推送内容推送到审批人的手机，请尽量详细。"

@interface WaichuViewController ()<UITableViewDataSource,UITableViewDelegate,ShenpiDelegate>
{
    UIButton *commitBtn;  /** 提交按钮 */
}

/** UITabelView */
@property (strong,nonatomic) UITableView *tableView;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 审批人名字 */
@property (copy,nonatomic) NSString *shenpiName;
/** 外出理由 */
@property (strong,nonatomic) UILabel *label;

/** 开始时间日历模型 */
@property (strong,nonatomic) CalendarDayModel *startCalenModel;
/** 结束时间日历模型 */
@property (strong,nonatomic) CalendarDayModel *endCalenModel;

/*************** 参数 ****************/


/** 外出理由 */
@property (strong,nonatomic) YYTextView *reasonTextV;
/** 开始时间 */
@property (copy,nonatomic) NSString *startTime;
/** 结束时间 */
@property (copy,nonatomic) NSString *endTime;
/** 小时数 */
@property (copy,nonatomic) NSString *timeNum;
/** 审批人的uid */
@property (copy,nonatomic) NSString *uid;


@end

@implementation WaichuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"外出申请";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.timeNum = @"请选择(必填)";
    self.startTime = @"请选择(必填)";
    self.endTime = @"请选择(必填)";
    self.shenpiName = @"请选择(必填)";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { // 真实姓名、身份证号、联系方式、组织还是个人
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        cell.label.text = @"外出时间";
        cell.infoLabel.text = self.timeNum;
        
        return cell;
    }else if (indexPath.section == 1) {
        NSArray *titleArr = @[@"开始时间",@"结束时间",@"审批人"];
        NSArray *infoArr = @[self.startTime,self.endTime,self.shenpiName];
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        cell.label.text = titleArr[indexPath.row];
        cell.infoLabel.text = infoArr[indexPath.row];
        return cell;
    }else{
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.label removeFromSuperview];
        [cell.infoLabel removeFromSuperview];
        /********** 开始绘制剩下的控件 **************/
        [cell.contentView addSubview:self.label];
        [cell.contentView addSubview:self.reasonTextV];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        // 外出时间
        // 请假类型
        NSArray *timeArr = @[@"半天",@"一天",@"两天",@"三天及以上"];
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择外出时间" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex >= 1) {
                self.timeNum = timeArr[buttonIndex - 1];
                [self.tableView reloadData];
            }
        } otherButtonTitles:@"半天",@"一天",@"两天",@"三天及以上", nil];
        [sheet show];
    } else if(indexPath.section == 1){
        // 选择时间
        if (indexPath.row == 0) {
            // 开始时间
            self.timeType = outStartTimeType;
            CalendarHomeViewController *calender = [CalendarHomeViewController new];
            calender.calendartitle = @"外出开始时间";
            calender.calendarblock = ^(CalendarDayModel *model){
                self.startCalenModel = model;
                self.startTime = [model toString];
                [self.tableView reloadData];
            };
            [calender setAirPlaneToDay:365 ToDateforString:nil];
            [self.navigationController pushViewController:calender animated:YES];
        } else if(indexPath.row == 1){
            // 结束时间
            self.timeType = outEndTimeType;
            CalendarHomeViewController *calender = [CalendarHomeViewController new];
            calender.calendartitle = @"外出结束时间";
            calender.calendarblock = ^(CalendarDayModel *model){
                self.endCalenModel = model;
                self.endTime = [model toString];
                [self.tableView reloadData];
            };
            [calender setAirPlaneToDay:365 ToDateforString:nil];
            [self.navigationController pushViewController:calender animated:YES];
        }else{
            // 审批人
            ShenpiersViewController *shenpier = [[ShenpiersViewController alloc]init];
            shenpier.delegate = self;
            [self.navigationController pushViewController:shenpier animated:YES];
        }
    }else{
        
    }
}
- (void)shenpiDelegate:(StaffInfoModel *)model
{
    self.shenpiName = model.nickname;
    [self.tableView reloadData];
    
    NSString *kk = model.uid;
    self.uid = kk;
}
- (YYTextView *)reasonTextV
{
    if (!_reasonTextV) {
        _reasonTextV = [[YYTextView alloc]initWithFrame:CGRectMake(86, 13, SCREEN_WIDTH - 86 - 12, 100)];
        _reasonTextV.placeholderText = TitlePlace;
        _reasonTextV.placeholderTextColor = [UIColor grayColor];
        _reasonTextV.placeholderFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _reasonTextV.textColor = [UIColor blackColor];
        _reasonTextV.font = [UIFont systemFontOfSize:15];
        _reasonTextV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reasonTextV.layer.borderWidth = 0.5f;
        _reasonTextV.layer.cornerRadius = 5;
        _reasonTextV.backgroundColor = [UIColor whiteColor];
        
    }
    return _reasonTextV;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 70, 24)];
        _label.text = @"外出理由";
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = RGBACOLOR(10, 10, 10, 1);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }else{
        return 160*CKproportion;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 12;
    }else{
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        return foot;
    }else{
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.backgroundColor = RGBACOLOR(43, 170, 63, 1);
        [commitBtn addTarget:self action:@selector(commitction:) forControlEvents:UIControlEventTouchUpInside];
        commitBtn.layer.cornerRadius = 6;
        [commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [foot addSubview:commitBtn];
        [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(foot.mas_centerX);
            make.bottom.equalTo(foot.mas_bottom).offset(-1);
            make.width.equalTo(@(SCREEN_WIDTH - 40*CKproportion));
            make.height.equalTo(@40);
        }];
        return foot;
    }
}

#pragma mark - 提交
- (void)commitction:(UIButton *)sender
{
    
    /********* 判断时间先后等 *********/
    if (([self.startTime isEqualToString:@"请选择(必填)"]) || ([self.endTime isEqualToString:@"请选择(必填)"]) || ([self.timeNum isEqualToString:@"请选择(必填)"]) || ([self.shenpiName isEqualToString:@"请选择(必填)"]) || (self.reasonTextV.text.length < 1) || (self.timeNum.length < 1)) {
        [self sendErrorWarning:@"请完善信息"];
        return;
    }
    
    NSDate *startDate = [self.startCalenModel date];
    NSDate *endDate = [self.endCalenModel date];
    NSComparisonResult result = [startDate compare:endDate];
    if (result == NSOrderedDescending){
        // 结束时间先于开始时间
        [self showErrorTips:@"结束时间不能先于开始时间"];
        return;
    }
    
    
    /************ 开始传参数 ************/
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    NSString *type = @"工作事务";
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:Waichu_URL,self.startTime,self.endTime,self.timeNum,self.reasonTextV.text,type,self.uid,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.indicatorV stopAnimating];
        [sender setTitle:@"提  交" forState:UIControlStateNormal];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"code"] description];
        if (code == 1) {
            [self sendSuccess:@"申请成功"];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.indicatorV stopAnimating];
        [sender setTitle:@"提  交" forState:UIControlStateNormal];
        [self sendErrorWarning:[NSString stringWithFormat:@"%@(审批人暂未开通手机端，导致无法推送。)",error.localizedDescription]];
    }];
    
}
- (void)sendSuccess:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [commitBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->commitBtn.mas_centerY);
            make.width.and.height.equalTo(@26);
            make.centerX.equalTo(self->commitBtn.mas_centerX);
        }];
    }
    return _indicatorV;
}


@end
