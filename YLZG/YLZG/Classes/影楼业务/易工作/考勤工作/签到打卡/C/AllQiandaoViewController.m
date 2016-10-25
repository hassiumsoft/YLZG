//
//  AllQiandaoViewController.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AllQiandaoViewController.h"
#import "qiaodaocountBtn.h"
#import "AllQiaodaoCollectionViewCell.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "NormalIconView.h"
#import <Masonry.h>
#import "AllQiandaoDetailViewController.h"
#import "CalendarHomeViewController.h"
#import "HTTPManager.h"
#import <AFNetworking.h>


@interface AllQiandaoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


//// 日历
//@property (nonatomic, strong) SCXDateTimePicker * datePicker;

// collectionView
@property (nonatomic, strong) UICollectionView * collectionView;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataArray;
/** 孔图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;


@property (copy,nonatomic) NSString *dateStr;

@end

@implementation AllQiandaoViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self selfInitAllQiandaoViewControllerVC];
    // 请求数据
    [self loadAllQiandaoViewControllerDataAndDate:self.dateStr];
    // 搭建UI
    [self creatAllQiandaoViewControllerUI];
}

#pragma mark - 初始化
- (void)selfInitAllQiandaoViewControllerVC{
    self.title = @"签到统计";
}

#pragma mark - 请求数据
- (void)loadAllQiandaoViewControllerDataAndDate:(NSString *)dateStr{
    
    AFHTTPSessionManager * requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer.timeoutInterval = 10.f;
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:AllQianDao_URL,  dateStr, account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            int status = [[[responseObject objectForKey:@"code"] description] intValue];
            if (status == 1) {
                [self.emptyBtn removeFromSuperview];
                [self.collectionView removeFromSuperview];
                NSArray * resultArr  = [responseObject objectForKey:@"result"];
                self.dataArray = [AllQiandaoModel mj_objectArrayWithKeyValuesArray:resultArr];
                if (self.dataArray.count < 1) {
                    [self loadEmptyView:@"暂无数据"];
                }else {
                    // 搭建UI
                    [self createCollectionView];
                    [self.collectionView reloadData];
                }
            }else {
                [self loadEmptyView:@"暂无数据"];
            }
        }
        fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
   
    }];

}

#pragma mark - 搭建UI
- (void)creatAllQiandaoViewControllerUI{
   // 通知
    [YLNotificationCenter addObserver:self selector:@selector(yuyueTime:) name:YLQiaodaoTime object:nil];
    // 上面的一行
    _dateButton = [qiaodaocountBtn shareqiaodaocountBtn];
    _dateButton.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    _dateButton.label.text = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
    [_dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateButton];
}

- (void)createCollectionView {
    // collectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateButton.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-64-10-_dateButton.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    // 注册cell
    [_collectionView registerClass:[AllQiaodaoCollectionViewCell class] forCellWithReuseIdentifier:@"aCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AllQiaodaoCollectionViewCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"aCell" forIndexPath:indexPath];
    
    AllQiandaoModel * model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    AllQiandaoModel * model = _dataArray[indexPath.row];
    
    AllQiandaoDetailViewController * detailVC = [[AllQiandaoDetailViewController alloc] init];
    detailVC.idStr = model.uid;
    detailVC.dateText = _dateButton.label.text;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 20)/5, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


/**  时间相关 */
#pragma mark - 选择时间
- (void)dateButtonClicked:(UIButton *)sender {
    
    CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc] init];
    calendar.calendartitle = @"日历";
    [calendar setAirPlaneToDay:365 ToDateforString:nil];
    __weak AllQiandaoViewController * weakSelf = self;
    calendar.calendarblock = ^(CalendarDayModel *model){
        NSString *chooseDate = [NSString stringWithFormat:@"%@",[model toString]];
        NSString *currentDate = weakSelf.dateStr;
        _dateButton.label.text = chooseDate;
        if ([currentDate isEqualToString:chooseDate]) {
            return ;
        }
        
        [self loadAllQiandaoViewControllerDataAndDate:chooseDate];
    };

    [self.navigationController pushViewController:calendar animated:YES];
    

}



#pragma mark -通知 预约时间
- (void)yuyueTime:(NSNotification *)noti {
    
    _dateButton.label.text = [NSString stringWithFormat:@"%@", noti.object];
    [self loadAllQiandaoViewControllerDataAndDate:noti.object];
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

@end
