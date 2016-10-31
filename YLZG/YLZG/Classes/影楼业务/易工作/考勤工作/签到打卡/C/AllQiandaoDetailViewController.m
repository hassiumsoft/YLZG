//
//  AllQiandaoDetailViewController.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AllQiandaoDetailViewController.h"
#import "qiaodaocountBtn.h"
#import "ZCAccountTool.h"
#import "AllQiaodaoDetailViewCell.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <AFNetworking.h>

#import "CalendarHomeViewController.h"
#import "UIBarButtonItem+Extension.h"




@interface AllQiandaoDetailViewController ()<UITableViewDataSource, UITableViewDelegate>


// 日期
@property (nonatomic, strong) qiaodaocountBtn * dateButton;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

/** 孔图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;
/** 选定的时间 */
@property(nonatomic,copy)NSString *chooseDate;


@end

@implementation AllQiandaoDetailViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self selfInitAllQiandaoDetailViewControllerVC];
    // 请求数据
    [self loadAllQiandaoDetailViewControllerDataAndDate:self.dateText];
    // 搭建UI
    [self creatAllQiandaoDetailViewControllerUI];
}

#pragma mark - 初始化
- (void)selfInitAllQiandaoDetailViewControllerVC{
    self.title = @"签到详情";
}


#pragma mark - 请求数据
- (void)loadAllQiandaoDetailViewControllerDataAndDate:(NSString *)dateStr
{
 
    AFHTTPSessionManager * requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer.timeoutInterval = 10.f;
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:AllQianDaoDetail_URL, _idStr, dateStr, account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

                int status = [[[responseObject objectForKey:@"code"] description] intValue];
                if (status == 1) {
                    [self.emptyBtn removeFromSuperview];
                    [self.tableView removeFromSuperview];
                    NSArray * resultArr = [responseObject objectForKey:@"result"];
                    self.dataArray = [AllQiaodaoDetailModel mj_objectArrayWithKeyValuesArray:resultArr];
                    if (self.dataArray.count < 1) {
                        [self loadEmptyView:@"暂无数据"];
                    }else {
                        [self createTabelView];
                        [self.tableView reloadData];
                    }
                }else {
                    [self loadEmptyView:@"暂无数据"];
                }
            }
        
         fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorTips:error.localizedDescription];
            [self sendErrorWarning:error.localizedDescription];
         }];
        

}


#pragma mark - 搭建UI
- (void)creatAllQiandaoDetailViewControllerUI{
    // 上面的一行
    _dateButton = [qiaodaocountBtn shareqiaodaocountBtn];
    _dateButton.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    _dateButton.label.text = self.dateText;
    [_dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateButton];

}



- (void)createTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateButton.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-64-10-_dateButton.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllQiaodaoDetailViewCell * cell = [AllQiaodaoDetailViewCell sharedAllQiaodaoDetailViewCell:tableView andIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    AllQiaodaoDetailModel * model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/**  时间相关 */
#pragma mark - 选择时间
- (void)dateButtonClicked:(UIButton *)sender {
    
    CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc] init];
    calendar.calendartitle = @"日历";
    [calendar setAirPlaneToDay:365 ToDateforString:nil];
    __weak AllQiandaoDetailViewController * weakSelf = self;
    calendar.calendarblock = ^(CalendarDayModel *model){
        NSString *chooseDate = [NSString stringWithFormat:@"%@",[model toString]];
        NSString *currentDate = weakSelf.dateText;
        [YLNotificationCenter postNotificationName:YLQiaodaoTime object:chooseDate];
        _dateButton.label.text = chooseDate;
        if ([currentDate isEqualToString:chooseDate]) {
            return ;
        }
        
        [self loadAllQiandaoDetailViewControllerDataAndDate:chooseDate];
        
};

        [self.navigationController pushViewController:calendar animated:YES];

}




#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn = [NormalIconView sharedHomeIconView];
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.emptyBtn];
    
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
