//
//  CheckWorkViewController.m
//  YLZG
//
//  Created by apple on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CheckWorkViewController.h"
#import "DakaManager.h"
#import "YuanCurrentTimeView.h"
#import "DakaMapView.h"
#import "KaoqinInfoView.h"
#import "ZCAccountTool.h"
#import <AFNetworking.h>
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <Masonry.h>
// 签到备注
#import "QIaodaoBeizhuView.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@interface CheckWorkViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    // 更新按钮还是签到按钮
    NSString * type;
    // 是否是外勤
    NSString * outside;
    // 打卡状态
    NSString * stateS;
}

// 地图
@property (nonatomic, strong) BMKMapView * mapView;
// 反地理编码
@property (nonatomic,strong)  BMKGeoCodeSearch * geocoder;
// 定位
@property (nonatomic, strong) BMKLocationService * locService;
// 经度
@property (nonatomic, assign) CLLocationDegrees latitude;
// 纬度
@property (nonatomic, assign) CLLocationDegrees longitude;
// 不显示的地图的定位地址
@property (nonatomic, strong) NSDictionary * hideLoacationDict;



// 最底层的scrollview
@property (nonatomic, strong) UIScrollView * backScrollView;

// 签到备注
@property (nonatomic, strong) QIaodaoBeizhuView * qiandaoBeizhuView;

// 第二行白色背景
@property (nonatomic, strong) UIView * whiteView;
// 上班时间
@property (nonatomic, strong) UIButton * workTime;
// 上班签到时间
@property (nonatomic, strong) UILabel * onQinaoTime;
// 中间的竖蓝线
@property (nonatomic, strong) UILabel * blueLabel;
// 下班时间
@property (nonatomic, strong) UIButton * offWorkTime;
// 下班签到时间
@property (nonatomic, strong) UILabel * offQiandaoTime;


// 底层的灰色
@property (nonatomic, strong) UIView * grayView;
// 圆
@property (nonatomic, strong) YuanCurrentTimeView * yuanView;

// 上班时间地图的显示
@property (nonatomic, strong) DakaMapView * dakaView;
// 下班时间地图的显示
@property (nonatomic, strong) DakaMapView * offDakaView;



@end

@implementation CheckWorkViewController

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 不显示的地图
    _mapView = [[BMKMapView alloc] init];
    self.mapView.gesturesEnabled = YES;
    self.mapView.overlookEnabled = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.mapType = BMKMapTypeStandard;
    
    // 我的位置定位
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self selfInitCheckWorkVControllerVC];
    // 请求数据
    [self loadCheckWorkVControllerData];
}

#pragma mark - 初始化
- (void)selfInitCheckWorkVControllerVC{
    self.title = @"签到打卡";
    self.dataDict = [[NSMutableDictionary alloc] init];
}


- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        
    }
    return _backScrollView;
}

#pragma mark - 请求数据
- (void)loadCheckWorkVControllerData{
    
    
    [MBProgressHUD showMessage:@"请稍后"];
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:QiandaoDakaAll_Url,account.userID];
    
    [HTTPManager GET:url  params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [MBProgressHUD hideHUD];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (status == 1) {
            self.dataDict = responseObject[@"result"];
            // 搭建UI
            
            [self creatCheckWorkVControllerUI];
        }else {
            
            [self CreateEmptyView:message];
        }
        
     }fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
         [self sendErrorWarning:error.localizedDescription];
    }];
    
}
- (void)CreateEmptyView:(NSString *)message
{
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"happyness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(209, 40, 123, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}


#pragma mark - 搭建UI
- (void)creatCheckWorkVControllerUI{
  

    self.backScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backScrollView.userInteractionEnabled = YES;
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.backScrollView];
    
    // 上面的一行
    KaoqinInfoView *kaoqinInfoView = [[KaoqinInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 130)];
    kaoqinInfoView.dict = self.dataDict;
    [self.backScrollView addSubview:kaoqinInfoView];
    
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kaoqinInfoView.frame)+1, SCREEN_WIDTH, 300 * CKproportion)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.whiteView];
    
    // 上班时间 
    self.workTime = [self getButtonFrame:CGRectMake(20, 10, 150, 25) andTitle:[NSString stringWithFormat:@"上班时间%@", _dataDict[@"rule"][@"start"]] andImage:@"workTimeImage"];
    // 上班签到时间
    self.onQinaoTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_workTime.frame)+10, CGRectGetMinY(_workTime.frame)+3, 150, 20)];
    self.onQinaoTime.font = [UIFont systemFontOfSize:14];
    self.onQinaoTime.textColor = RGBACOLOR(34, 34, 34, 1);
    [self.whiteView addSubview:self.onQinaoTime];
    // 蓝色线
    self.blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.workTime.frame)+10, CGRectGetMaxY(self.workTime.frame), 1, 100)];
    self.blueLabel.backgroundColor = RGBACOLOR(43, 135, 227, 1);
    [self.whiteView addSubview:self.blueLabel];
    
    // 下班时间
    self.offWorkTime = [self getButtonFrame:CGRectMake(20, CGRectGetMaxY(self.blueLabel.frame), 150, 25) andTitle:[NSString stringWithFormat:@"下班时间%@", _dataDict[@"rule"][@"end"]] andImage:@"offWorkTime"];
    // 下班时间签到
    self.offQiandaoTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_offWorkTime.frame)+10, CGRectGetMinY(_offWorkTime.frame)+3, 150, 20)];
    self.offQiandaoTime.font = [UIFont systemFontOfSize:14];
    self.offQiandaoTime.textColor = RGBACOLOR(34, 34, 34, 1);
    [self.whiteView addSubview:_offQiandaoTime];
    
    // 底层的灰色
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.whiteView.frame), SCREEN_WIDTH, self.backScrollView.height)];
    self.grayView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self.backScrollView addSubview:self.grayView];
    
    // 上班时间地图
    self.dakaView = [[DakaMapView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blueLabel.frame)+10, CGRectGetMaxY(self.workTime.frame)+10, SCREEN_WIDTH-50, 100)];
    [self.dakaView setHidden:YES];
    [self.whiteView addSubview:self.dakaView];
    self.dakaView.superController = self;
    
    
    // 下班时间地图
    self.offDakaView = [[DakaMapView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blueLabel.frame)+10, CGRectGetMaxY(self.offWorkTime.frame)+10, SCREEN_WIDTH-50, 100)];
    [self.offDakaView setHidden:YES];
    [self.whiteView addSubview:self.offDakaView];
    self.offDakaView.superController = self;
    
    // 圆
    self.yuanView = [[YuanCurrentTimeView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-65, 20, 130, 130)];
    [self.grayView addSubview:self.yuanView];
    
    
    // 地图和圆球隐藏、显示相关
    [self createHideOrShowView];
    
    __weak CheckWorkViewController * weakSelf = self;
    self.dakaView.updateButton = ^(void) {
        [weakSelf updateBtnWithTag:@"1"];
    };
    
    self.offDakaView.updateButton = ^(void) {
        [weakSelf updateBtnWithTag:@"2"];
    };
    
    self.yuanView.yuanClick = ^(void) {
        [weakSelf updateBtnWithTag:@"0"];
    };
    
}

#pragma mark -地图和圆球隐藏、显示相关
- (void)createHideOrShowView {
    // 设置按钮状态:如果下午已经打完卡,将下面的按钮隐藏掉
    if ([self getStateAndupdate:NO] == 2 || [self getStateAndupdate:NO] == 3) {
        self.yuanView.firstLabel.text = @"迟到打卡";
        self.yuanView.imageView.image = [UIImage imageNamed:@"chidaoAndyichang"];
    }
    if ([self getStateAndupdate:NO] == 5) {
        self.yuanView.firstLabel.text = @"早退打卡";
        self.yuanView.imageView.image = [UIImage imageNamed:@"chidaoAndyichang"];
    }
    if ([self getStateAndupdate:NO] == 1) {
        self.yuanView.firstLabel.text = @"正常打卡";
        self.yuanView.imageView.image = [UIImage imageNamed:@"zhengchangdaka"];
    }
    
    
    NSString * centerTimeStr = [self getMiddleTime:[NSString stringWithFormat:@"%@", _dataDict[@"rule"][@"start"]] andEndTime:_dataDict[@"rule"][@"end"]];
    int centerTime = [[centerTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int nowStr = [[[self getHHCurrentTime] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    
    if ([_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@""] ||[_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@"null"]) {
        // 如果上午未打卡
        if (nowStr < centerTime) {
            // 未打卡状态
            //            [self.dakaView setHidden:YES];// 隐藏上班的地图
        } else {
            // 缺卡状态
            [self.dakaView setHidden:NO];
            [self.dakaView mapWithState:6];
        }
    }else {
        // 上午已经打卡
        [self.dakaView setHidden:NO];
        self.onQinaoTime.text = [NSString stringWithFormat:@"打卡时间:%@", [[_dataDict[@"checkin"][@"on"][@"time"] componentsSeparatedByString:@" "] lastObject]];
        self.dakaView.locationDict = _dataDict[@"checkin"][@"on"][@"location"];
        
        if ([_dataDict[@"checkin"][@"on"][@"status"] isEqualToString:@"1"]) {
            [self.dakaView mapWithState:1];
        }
        if ([_dataDict[@"checkin"][@"on"][@"status"] isEqualToString:@"2"] || [_dataDict[@"checkin"][@"on"][@"status"] isEqualToString:@"3"]) {
            [self.dakaView mapWithState:2];
        }
        if ([_dataDict[@"checkin"][@"on"][@"outside"] isEqualToString:@"1"]) {
            // 外勤打卡
            [self.dakaView mapWithState:3];
        }else {
            
        }
    }
    if ([_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@""] || [_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@"null"]) {
        // 如果下午未打卡
        [self.offDakaView setHidden:YES];
        
    }else {
        // 下午打卡了
        [self.dakaView.updateBtn setTitleColor:RGBACOLOR(174, 174, 174, 1) forState:UIControlStateNormal];// 隐藏上午的更新打卡的按钮
        [self.dakaView.updateBtn setTitle:@"不可更新" forState:UIControlStateNormal];
        self.dakaView.updateBtn.enabled = NO;
        [self.dakaView.updateBtn setImage:[UIImage imageNamed:@"NotUpdate_imageV"] forState:UIControlStateNormal];
        [self.offDakaView setHidden:NO];
        self.offQiandaoTime.text = [NSString stringWithFormat:@"打卡时间:%@", [[_dataDict[@"checkin"][@"off"][@"time"] componentsSeparatedByString:@" "] lastObject]];
        self.offDakaView.locationDict = _dataDict[@"checkin"][@"off"][@"location"];
        
        
        if ([_dataDict[@"checkin"][@"off"][@"status"] isEqualToString:@"1"]) {
            // 正常打卡
            [self.offDakaView mapWithState:1];
        }
        if ([_dataDict[@"checkin"][@"off"][@"status"] isEqualToString:@"5"]) {
            // 早退
            [self.offDakaView mapWithState:5];
        }
        
        if ([_dataDict[@"checkin"][@"off"][@"outside"] isEqualToString:@"1"]) {
            // 外勤
            [self.offDakaView mapWithState:3];
        }else {
            
        }
    }
    
}
#pragma mark -state相关(不是更新传NO,是更新传YES)
- (int)getStateAndupdate:(BOOL)isUpdate {
    NSString * centerTimeStr = [self getMiddleTime:[NSString stringWithFormat:@"%@", _dataDict[@"rule"][@"start"]] andEndTime:_dataDict[@"rule"][@"end"]];
    int centerTime = [[centerTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int nowStr = [[[self getHHCurrentTime] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int startTime = [[_dataDict[@"rule"][@"start"] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int endTime = [[_dataDict[@"rule"][@"end"] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    
    // 状态
    int state = -1;
    
    if (nowStr <= centerTime) {
        // 上午时间未达到一半
        if ([_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@""] || [_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@"null"]) {
            // 如果上午未打卡
            if(nowStr > ([_dataDict[@"whole"][@"privilege_time"] intValue]+startTime)) {
                // 迟到
                if (nowStr > ([_dataDict[@"whole"][@"latetime"] intValue]+startTime)) {
                    // 严重迟到
                    state = 3;
                }else {
                    // 迟到
                    state = 2;
                }
            }else {
                
                //未迟到,正常
                state = 1;
            }
            
        }else {
            // 未到上班时间一半打下午的卡,则定义为早退
            state = 5;
            // 上午已经打过卡了
            if (isUpdate == YES) {
                if(nowStr > ([_dataDict[@"whole"][@"privilege_time"] intValue]+startTime)) {
                    // 迟到
                    if (nowStr > ([_dataDict[@"whole"][@"latetime"] intValue]+startTime)) {
                        // 严重迟到
                        state = 3;
                    }else {
                        // 迟到
                        state = 2;
                    }
                }else {
                    
                    //未迟到,正常
                    state = 1;
                }
                
            }
        }
        
    }else {
        // 下午打卡
        if ([_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@""] || [_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@"null"]) {
            
            if (nowStr > endTime) {
                // 正常下班
                state = 1;
            }else {
                // 早退
                state = 5;
            }
        }else {// 下午已经打过卡了
            [self.yuanView setHidden:YES];
            if (isUpdate == YES) {
                if (nowStr > endTime) {
                    // 正常下班
                    state = 1;
                }else {
                    // 早退
                    state = 5;
                }
            }
        }
    }
    // 如果下午已经打完卡了,让他的圆球消失
    if (![_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@""] && ![_dataDict[@"checkin"][@"off"][@"id"] isEqualToString:@"null"]) {
        [self.yuanView setHidden:YES];
        if (isUpdate == YES) {
            if (nowStr > endTime) {
                // 正常下班
                state = 1;
            }else {
                // 早退
                state = 5;
            }
        }
    }
    return state;
}


#pragma mark -更新按钮相关
- (void)updateBtnWithTag:(NSString *)tag {
    // 地图和圆球隐藏、显示相关
    self.qiandaoBeizhuView = [QIaodaoBeizhuView sharedBeizhuView];
    self.qiandaoBeizhuView.frame = SCREEN_BOUNDS;
    __weak CheckWorkViewController *copySelf = self;
    self.qiandaoBeizhuView.DakaClickBlock = ^(NSString *beizhu){
        [copySelf dakaTimeClicked:beizhu];
    };
    self.qiandaoBeizhuView.addressText.text = _hideLoacationDict[@"address"];
    [self.view addSubview:self.qiandaoBeizhuView];
    
    NSString * centerTimeStr = [self getMiddleTime:[NSString stringWithFormat:@"%@", _dataDict[@"rule"][@"start"]] andEndTime:_dataDict[@"rule"][@"end"]];
    int centerTime = [[centerTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int timeStr = [[[self getHHCurrentTime] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    // 是上班打卡还是下班打卡
    // 状态
    if ([tag isEqualToString:@"0"]) {
        if (timeStr < centerTime) {
            if ([_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@""] ||[_dataDict[@"checkin"][@"on"][@"id"] isEqualToString:@"null"]) {
                type = @"1";
            }else {
                type = @"2";
            }
        }else {
            type = @"2";
        }
        stateS = [NSString stringWithFormat:@"%d",[self getStateAndupdate:NO]];
    }else {
        
        if([tag isEqualToString:@"1"]) {
            type = @"1";
            stateS = [NSString stringWithFormat:@"%d",[self getStateAndupdate:YES]];
            self.qiandaoBeizhuView.topLabel.text = @"上午更新打卡";
        }else if([tag isEqualToString:@"2"]) {
            type = @"2";
            stateS = [NSString stringWithFormat:@"%d",[self getStateAndupdate:YES]];
            self.qiandaoBeizhuView.topLabel.text = @"下午更新打卡";
        }
    }
}

#pragma mark - 隐藏mapview相关
- (void)dakaTimeClicked:(NSString *)beizhu {
    // 是否外勤
    [self getWheatherOutside];
    if (_hideLoacationDict == 0) {
        [self sendErrorWarning:@"定位失败,请重新定位"];
    }else {
        // 签到成功接口(address是将字典转成字符串)
        [self getQiandaochenggongDataWithType:type andID:_dataDict[@"checkin"][@"on"][@"id"] andTime:[self getHHCurrentTime] andAddress:[self toJsonStr:_hideLoacationDict] andState:stateS andOutside:outside andRemark:beizhu];
    }
}

#pragma mark -签到成功接口(address是将字典转成字符串)
- (void)getQiandaochenggongDataWithType:(NSString *)typeStr andID:(NSString *)ID andTime:(NSString *)time andAddress:(NSString *)addressDict andState:(NSString *)state andOutside:(NSString *)outsideStr andRemark:(NSString *)remark
{
    
    [MBProgressHUD showMessage:@"打卡中···"];
    
    ZCAccount * account = [ZCAccountTool account];
    
    NSString *wifiName = [[DakaManager sharedManager] getWifiName];
    
    NSString * url = [NSString stringWithFormat:QiandaoDakaChenggong_Url, account.userID, typeStr,ID, time,wifiName,addressDict, state, outsideStr, remark];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [MBProgressHUD hideHUD];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"]  description];
        if (status == 1) {
            // 签到成功
            [self loadCheckWorkVControllerData];
            [self sendErrorWarning:@"打卡成功"];
        }else {
            [MBProgressHUD showSuccess:message];
        }

        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
 
}

#pragma mark -获取当前的wifi名字
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}


#pragma mark -封装button相关
- (UIButton *)getButtonFrame:(CGRect)frame andTitle:(NSString *)title andImage:(NSString *)imageName {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.whiteView addSubview:button];
    return button;
}

#pragma mark -获取周几
/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    switch (week) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
            
        default:
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
        KGLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
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

#pragma mark -获取某段时间的中间点
- (NSString *)getMiddleTime:(NSString *)startTime andEndTime:(NSString *)endTime {
    int startH = [[[startTime componentsSeparatedByString:@":"] firstObject] intValue];
    int endH = [[[endTime componentsSeparatedByString:@":"] firstObject] intValue];
    int startM = [[[startTime componentsSeparatedByString:@":"] lastObject] intValue];
    int endM = [[[endTime componentsSeparatedByString:@":"] lastObject] intValue];
    
    int centerH = ((startH * 60 + startM)+((endH * 60 + endM)-(startH * 60 + startM))/ 2) /60;
    int centerM = ((startH * 60 + startM)+((endH * 60 + endM)-(startH * 60 + startM))/ 2) %60;
    
    NSString * center = nil;
    if (centerH < 10 && centerM < 10) {
        center = [NSString stringWithFormat:@"0%d:0%d",centerH, centerM];
    }else if (centerH < 10 && centerM >= 10) {
        center = [NSString stringWithFormat:@"0%d:%d",centerH, centerM];
    }else if (centerH >= 10 && centerM < 10) {
        center = [NSString stringWithFormat:@"%d:0%d",centerH, centerM];
    }else {
        center = [NSString stringWithFormat:@"%d:%d",centerH, centerM];
    }
    return center;
}

#pragma mark -当前时间
- (NSString *)getHHCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}


#pragma mark - 不显示的地图定位相关
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    KGLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    // 我的位置坐标
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;
    [_mapView showsUserLocation];
    [_mapView updateLocationData:userLocation];
    
    CLLocationCoordinate2D local2D = CLLocationCoordinate2DMake(_latitude, _longitude);
    [_mapView setCenterCoordinate:local2D animated:YES];
    
    // 反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_latitude, _longitude};
    BMKReverseGeoCodeOption * reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    self.geocoder = [BMKGeoCodeSearch new];
    _geocoder.delegate = self;
    BOOL flag = [_geocoder reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag){
        KGLog(@"反geo检索发送成功");
    }else{
        KGLog(@"反geo检索发送失败");
    }
}

#pragma mark - 我的位置
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    _hideLoacationDict = @{@"latitude":[NSString stringWithFormat:@"%f",_latitude], @"longitude":[NSString stringWithFormat:@"%f",_longitude], @"address":result.address};
    
}

#pragma mark -是否是外勤
- (void)getWheatherOutside {
    if (_hideLoacationDict == nil) {
        return;
    }
    NSMutableArray * distaceArr = [[NSMutableArray alloc] init];
    BMKMapPoint pHome = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([_hideLoacationDict[@"latitude"] doubleValue],[_hideLoacationDict[@"longitude"] doubleValue]));
    
    
    id locations = [_dataDict objectForKey:@"locations"];
    if ([locations isKindOfClass:[NSNull class]]) {
        
    }else{
        for (int i = 0; i < [_dataDict[@"locations"] count]; i++) {
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([_dataDict[@"latitude"][i] doubleValue],[_dataDict[@"longitude"][i] doubleValue]));
            double distance = BMKMetersBetweenMapPoints(pHome,point1);
            [distaceArr addObject:[NSString stringWithFormat:@"%f",distance]];
        }
    }
    
    
    // 如果没有wifi的时候判断距离
    if (_dataDict[@"routers"] == nil || _dataDict[@"routers"] == 0) {
        for (NSString * d in distaceArr) {
            if ([d doubleValue] < [_dataDict[@"privilege_meter"] doubleValue]) {
                outside = @"0";
            }else {
                outside = @"1";
            }
        }
        
    }else {
        // 有wifi的时候判断wifi
        for (NSString * item in _dataDict[@"routers"]) {
            // 现在连接的wifi和接口中的wifi如果匹配,就是内勤,否则就是外勤
            if ([item isEqualToString:[self getWifiName]]) {
                outside = @"0";
            }else {
                outside = @"1";
            }
        }
    }
}

/// 计算两点的距离
- (CLLocationDistance)distanceWithStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint {
    BMKMapPoint point1 = BMKMapPointForCoordinate(startPoint);
    BMKMapPoint point2 = BMKMapPointForCoordinate(endPoint);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1, point2);
    return distance;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
    self.geocoder.delegate = nil;
    [self.locService stopUserLocationService];
    
    self.mapView = nil;
    self.locService = nil;
    self.geocoder = nil;
}

- (void)dealloc {
    [YLNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.locService stopUserLocationService];
    
}
@end
