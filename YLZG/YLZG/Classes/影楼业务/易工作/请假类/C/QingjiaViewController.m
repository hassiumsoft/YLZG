//
//  QingjiaViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "QingjiaViewController.h"
#import "WorkTableViewCell.h"
#import <Masonry.h>
#import "ShenpiersViewController.h"
#import "HomeNavigationController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "CalendarHomeViewController.h"
#import <LCActionSheet.h>


#define TitlePlace @"请假理由将以推送内容推送到审批人的手机，请尽量详细。"

@interface QingjiaViewController ()<UITableViewDelegate,UITableViewDataSource,ShenpiDelegate,LCActionSheetDelegate>

{
    UIButton *commitBtn;  /** 提交按钮 */
}

@property (strong,nonatomic) UITableView *tableView;

/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

/** 开始时间日历模型 */
@property (strong,nonatomic) CalendarDayModel *startCalenModel;
/** 结束时间日历模型 */
@property (strong,nonatomic) CalendarDayModel *endCalenModel;

/** 请假理由label */
@property (strong,nonatomic) UILabel *label;
/** 审批人的suid */
@property (copy,nonatomic) NSString *suid;

/** 详细数据源 */
@property (strong,nonatomic) NSMutableArray *infoArray;

/************ 需要的参数 ***********/
@property (strong,nonatomic) YYTextView *reasonTextV; // 请假理由
@property (copy,nonatomic) NSString *typeStr; // 请假类型
@property (copy,nonatomic) NSString *startTime;  // 开始时间
@property (copy,nonatomic) NSString *endTime;  // 结束时间
@property (copy,nonatomic) NSString *nameStr;  // 审批人


@property (copy,nonatomic) NSString *zcTime;

@end

@implementation QingjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请假条";
    [self setupSubViews];
    
    
}



- (void)setupSubViews
{
    // 原始数据
    self.typeStr = @"请选择(必填)";
    self.startTime = @"请选择(必填)";
    self.endTime = @"请选择(必填)";
    self.nameStr = @"请选择(必填)";
    
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
        cell.label.text = @"请假类型";
        cell.infoLabel.text = self.typeStr;
        
        return cell;
    }else if (indexPath.section == 1) {
        NSArray *titleArr = @[@"开始时间",@"结束时间",@"审批人"];
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        cell.label.text = titleArr[indexPath.row];
        NSArray *infoArray = @[self.startTime,self.endTime,self.nameStr];
        cell.infoLabel.text = infoArray[indexPath.row];
        
        
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

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 70, 24)];
        _label.text = @"理由/备注";
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = RGBACOLOR(10, 10, 10, 1);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (YYTextView *)reasonTextV
{
    if (!_reasonTextV) {
        _reasonTextV = [[YYTextView alloc]initWithFrame:CGRectMake(86, 10, SCREEN_WIDTH - 86 - 12, 100)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        // 请假类型
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"临时有事",@"病假",@"年假",@"婚假",@"产假",@"路途假",@"其他", nil];
        sheet.scrolling = YES;
        sheet.visibleButtonCount = 4;
        [sheet show];
        
    } else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                // 开始时间
                self.timeType = startTimeType;
                CalendarHomeViewController *calender = [CalendarHomeViewController new];
                calender.calendartitle = @"选择请假时间";
                calender.calendarblock = ^(CalendarDayModel *model){
                    self.startCalenModel = model;
                    self.startTime = [model toString];
                    [self.tableView reloadData];
                };
                [calender setAirPlaneToDay:365 ToDateforString:nil];
                [self.navigationController pushViewController:calender animated:YES];
                break;
            }
            case 1:
            {
                // 结束时间
                self.timeType = endTimeType;
                CalendarHomeViewController *calender = [CalendarHomeViewController new];
                calender.calendartitle = @"选择请假时间";
                calender.calendarblock = ^(CalendarDayModel *model){
                    self.endCalenModel = model;
                    self.endTime = [model toString];
                    [self.tableView reloadData];
                };
                [calender setAirPlaneToDay:365 ToDateforString:nil];
                [self.navigationController pushViewController:calender animated:YES];
                break;
            }
            case 2:
            {
                // 选择审批人
                ShenpiersViewController *shenpier = [[ShenpiersViewController alloc]init];
                shenpier.delegate = self;
                [self.navigationController pushViewController:shenpier animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        // 请假理由---随便填写
    }
}

#pragma mark - 选择审批人的回调
- (void)shenpiDelegate:(StaffInfoModel *)model
{
    self.nameStr = model.nickname;
    self.suid = model.uid;
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }else{
        return 150*CKproportion;
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
        [commitBtn addTarget:self action:@selector(commitQingjia:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)commitQingjia:(UIButton *)sender
{
    /********* 判断时间先后等 *********/
    if (([self.typeStr isEqualToString:@"请选择(必填)"]) || ([self.startTime isEqualToString:@"请选择(必填)"]) || ([self.endTime isEqualToString:@"请选择(必填)"]) || ([self.nameStr isEqualToString:@"请选择(必填)"]) || (self.reasonTextV.text.length < 1)) {
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
    
    [self.view endEditing:YES];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *days = @"x天";
    NSString *url = [NSString stringWithFormat:Qingjia,self.startTime,self.endTime,days,self.reasonTextV.text,self.typeStr,self.suid,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self.indicatorV stopAnimating];
        if (status == 1) {
            [self sendSuccess:@"请假成功"];
            [sender setTitle:@"提 交" forState:UIControlStateNormal];
        }else{
            NSString *message = [[responseObject objectForKey:@"message"] description];
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

#pragma mark - 选择套系名称
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            self.typeStr = @"临时有事";
            [self.tableView reloadData];
            break;
        }
        case 2:
        {
            self.typeStr = @"病假";
            [self.tableView reloadData];
            break;
        }
        case 3:
        {
            self.typeStr = @"年假";
            [self.tableView reloadData];
            break;
        }
        case 4:
        {
            self.typeStr = @"婚假";
            [self.tableView reloadData];
            break;
        }
        case 5:
        {
            self.typeStr = @"产假";
            [self.tableView reloadData];
            break;
        }
        case 6:
        {
            self.typeStr = @"路途假";
            [self.tableView reloadData];
            break;
        }
        case 7:
        {
            self.typeStr = @"其他";
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}
@end
