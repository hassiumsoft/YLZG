//
//  TeamKaoqinView.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeamKaoqinView.h"
#import "qiaodaocountBtn.h"
#import "SCXDateTimePicker.h"
#import "UIView+Extension.h"
#import "CustomProgress.h"
#import "TeamKaoqinTableViewCell.h"
#import "TeamPaihangbangViewController.h"
#import "TeamZhengchangDakaController.h"
#import <SVProgressHUD.h>
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import <AFNetworking.h>




@interface TeamKaoqinView ()<CustomProgressDelegate, UITableViewDataSource, UITableViewDelegate>
/** 第一行 */
@property (nonatomic, strong) UIView * backView;
// 查看排行榜
@property (nonatomic, strong) UIButton * chakanPaihangBtn;

/** 第二行 */
// 白色底
@property (nonatomic, strong) UIView * whiteView;
// button的白色底部(为了方便移除)
@property (nonatomic, strong) UIView * buttonWhiteBottom;
// 日期
@property (nonatomic, strong) qiaodaocountBtn * dateButton;
// 日历
@property (nonatomic, strong) SCXDateTimePicker * datePicker;
// 横线
@property (nonatomic, strong) UIView * grayLine;

@property (nonatomic, strong) CustomProgress *customProgress;

// 总的数据
@property (nonatomic, strong) NSMutableArray * allArray;
// button的数据
@property (nonatomic, strong) NSMutableArray * collectArray;

/** 第三行 */
@property (nonatomic, strong) UITableView * tableView;
// 最外层的部门数据
@property (nonatomic, strong) NSMutableArray * dataSounce;


@end

@implementation TeamKaoqinView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化数据相关
        [self initData];
        // 获取数据相关
        [self geDataWithTime:[self getCurrentTime]];
//        // 创建view相关
        [self createView];
    }
    return self;
}

#pragma mark -初始化数据相关
- (void)initData {
    _allArray = [[NSMutableArray alloc] init];
    _collectArray = [[NSMutableArray alloc] init];
    _dataSounce = [[NSMutableArray alloc] init];
}

#pragma mark -获取数据相关
- (void)geDataWithTime:(NSString *)time {
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:Count_TeamKaoqin_Url, account.userID, time];
   
    
    AFHTTPSessionManager * requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer.timeoutInterval = 10.f;
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
           [SVProgressHUD dismiss];
            int status = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (status == 1) {
                [self.collectArray removeAllObjects];
                [_buttonWhiteBottom removeFromSuperview];
                
//                self.collectArray = dict[@"count"][0][@"count"];
                self.allArray = [responseObject objectForKey:@"count"];
                self.collectArray = responseObject[@"count"][0][@"count"];
                self.dataSounce = [DeptTeamKaoqinModel mj_objectArrayWithKeyValuesArray:responseObject[@"count"]];
                // 创建view相关
                [self createButton];
                [self.tableView reloadData];
                
            }else {
                
                [self.checkCOntroller sendErrorWarning:message];
            }

        [SVProgressHUD dismiss];

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.checkCOntroller sendErrorWarning:error.localizedDescription];

    }];
   
}

#pragma mark -搭建UI相关
- (void)createView {
    self.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    /** 第一行 */
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 354)];
    _backView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self addSubview:_backView];
    // 查看排行榜
    self.chakanPaihangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chakanPaihangBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 44);
    self.chakanPaihangBtn.backgroundColor = [UIColor whiteColor];
    [self.chakanPaihangBtn setTitle:@"查看排行榜" forState:UIControlStateNormal];
    [self.chakanPaihangBtn setTitleColor: RGBACOLOR(74, 74, 74, 1) forState:UIControlStateNormal];
    self.chakanPaihangBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.chakanPaihangBtn.layer.cornerRadius = 10;
    [_backView addSubview:self.chakanPaihangBtn];
    [self.chakanPaihangBtn addTarget:self action:@selector(chakanClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 第二行 */
    // 白色底
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.chakanPaihangBtn.frame), CGRectGetMaxY(self.chakanPaihangBtn.frame)+10, self.chakanPaihangBtn.width, 290)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.cornerRadius = 10;
    [_backView addSubview:self.whiteView];
    // 通知
    [YLNotificationCenter addObserver:self selector:@selector(yuyueTime:) name:YLQiaodaoTime object:nil];
    // 日期
    _dateButton = [qiaodaocountBtn shareqiaodaocountBtn];
    _dateButton.frame = CGRectMake(0, 0, self.whiteView.width, 44);
    _dateButton.layer.cornerRadius = 10;
    _dateButton.label.text = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
    [_dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:_dateButton];
    // 横线
    self.grayLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dateButton.frame), CGRectGetMaxY(_dateButton.frame), _dateButton.width, 0.5)];
    self.grayLine.backgroundColor = RGBACOLOR(196, 196, 196, 1);
    [self.whiteView addSubview:self.grayLine];
    
    
    /** 第三行 */
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-180) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    _tableView.tableHeaderView = _backView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

- (void)createButton {
    
    _buttonWhiteBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_grayLine.frame), _whiteView.width, _whiteView.height-_dateButton.height-5)];
    [self.whiteView addSubview:_buttonWhiteBottom];
    
    NSArray * titleArr = @[@"未打卡", @"正常打卡", @"迟到", @"严重迟到", @"旷工", @"早退", @"缺卡", @"请假", @"外出", @"休息", @"未排班", @"外勤打卡"];
    // 循环创建button
    for (int i = 0; i < _collectArray.count; i++) {
        _customProgress  = [[CustomProgress alloc]initWithFrame:CGRectMake(30 + (i%6)*((_dateButton.width-20)/6), (i/6)*100 +15 , 15, 60)];
        _customProgress.delegate = self;
        NSArray *  numArr = _collectArray[i];
        NSString * peopleNum = [NSString stringWithFormat:@"%lu", (unsigned long)numArr.count];
        _customProgress.numLabel.text = peopleNum;
        _customProgress.proportion = [peopleNum floatValue]/[_allArray[0][@"totalstaff"] intValue];
        
        _customProgress.stateLabel.text = titleArr[i];
        // 设置进条值
        [_customProgress setProgress:[_allArray[0][@"totalstaff"] intValue]];
        
        [self.buttonWhiteBottom addSubview:_customProgress];
        
        if (i == 0) {
            _customProgress.progressView.backgroundColor = RGBACOLOR(43, 135, 227, 1);
        }else if (i == 2) {
            _customProgress.progressView.backgroundColor = [UIColor purpleColor];
        }else {
            _customProgress.progressView.backgroundColor = [UIColor orangeColor];
        }
        
        _customProgress.tag = 100+i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [_customProgress addGestureRecognizer:tap];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSounce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamKaoqinTableViewCell * cell = [TeamKaoqinTableViewCell sharedTeamKaoqinTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    DeptTeamKaoqinModel * model = _dataSounce[indexPath.row];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc]initWithFrame:CGRectZero];
    head.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    
    UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    topView.image = [UIImage imageNamed:@"tuanduikaoqinyuanjiao_image"];
    [head addSubview:topView];
    
    NSArray * nameArr = @[@"部门名称", @"应到", @"实到"];
    for (int i = 0; i < 3; i++) {
        UILabel * nameLbel = [[UILabel alloc] init];
        UILabel * grayLabel = [[UILabel alloc] init];
        if (i == 0) {
            nameLbel.frame = CGRectMake(0, 0, topView.width/4*2, topView.height);

        }else {
            nameLbel.frame = CGRectMake(topView.width/4*2 + (i-1)*topView.width/4, 0, topView.width/4, topView.height);
           
        }
        nameLbel.font = [UIFont systemFontOfSize:14];
        nameLbel.textColor = RGBACOLOR(35, 35, 35, 1);
        nameLbel.text = nameArr[i];
        nameLbel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:nameLbel];
        
        grayLabel.frame = CGRectMake(CGRectGetMaxX(nameLbel.frame), 0, 0.5, 44);
        grayLabel.backgroundColor = RGBACOLOR(228, 228, 228, 1);
        [topView addSubview:grayLabel];
    }
    
    return head;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark -进度条代理相关
- (void)changeTextProgress:(NSString *)string {

}

-(void)endTime
{
    //进度完成时，做某些处理
}


/**  时间相关 */
#pragma mark - 选择时间
- (void)dateButtonClicked:(UIButton *)sender {
    
    self.datePicker = [SCXDateTimePicker shareSCXDateTimePicker];
    self.datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.window addSubview:self.datePicker];
}

#pragma mark -当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd "];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}

#pragma mark -通知 预约时间
- (void)yuyueTime:(NSNotification *)noti {
    _dateButton.label.text = [NSString stringWithFormat:@"%@", noti.object];
    // 获取数据相关
    [self geDataWithTime:noti.object];
}

- (void)tapClicked:(UITapGestureRecognizer *)tap {
    NSArray * titleArr = @[@"未打卡", @"正常打卡", @"迟到", @"严重迟到", @"旷工", @"早退", @"缺卡", @"请假", @"外出", @"休息", @"未排班", @"外勤打卡"];
    NSArray *  hh = _collectArray[tap.view.tag - 100];
    if (hh.count == 0) {
        NSString *mesage = [NSString stringWithFormat:@"没有人%@",titleArr[tap.view.tag - 100]];
        [SVProgressHUD showSuccessWithStatus:mesage];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }else {
        TeamZhengchangDakaController * vc = [[TeamZhengchangDakaController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@人员",titleArr[tap.view.tag - 100]];
        vc.dataArray = _collectArray[tap.view.tag - 100];
        [self.checkCOntroller.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -查看排行榜按钮点击
- (void)chakanClicked:(UIButton *)sender {
    TeamPaihangbangViewController * vc = [[TeamPaihangbangViewController alloc] init];
    [self.checkCOntroller.navigationController pushViewController:vc animated:YES];
}

@end
