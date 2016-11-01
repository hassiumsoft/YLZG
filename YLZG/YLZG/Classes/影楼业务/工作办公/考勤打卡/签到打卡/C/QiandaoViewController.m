//
//  QiandaoViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "QiandaoViewController.h"
#import "AllQiandaoViewController.h"
#import <MapKit/MapKit.h>
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
#import "UserInfoManager.h"
#import "NSDate+Extension.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>
#import "HTTPManager.h"
#import <AFNetworking.h>

//
#import "AllQiandaoModel.h"
#import <MJExtension.h>



@interface QiandaoViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSString * times;
}
// 定位
@property (nonatomic, strong) CLLocationManager * locService;
@property (nonatomic, assign)CLLocationCoordinate2D location2D;
@property (nonatomic, strong) MKPointAnnotation * myAnnotation;

@property (nonatomic, assign) CLLocationDegrees latitude1;
@property (nonatomic, assign) CLLocationDegrees longitude1;

// 反地理编码
@property (nonatomic,strong) CLGeocoder * geocoder;

// 底部的白色view
@property (nonatomic, strong)UIView * whiteView;
// 第一行  头像
@property (nonatomic, strong) UIImageView * headImageV;
// 第一行  姓名
@property (nonatomic, strong) UILabel * nameLabel;
// 第一行  灰色签到
@property (nonatomic, strong) UILabel * grayLabel;
// 第一行  下划线
@property (nonatomic, strong) UILabel * grayLine;
// 第二行  日期
@property (nonatomic, strong) UILabel * dateLabel;
// 第三行  地图
@property (nonatomic, strong) UIView * middleView;
// 第三行  地图
@property (nonatomic, strong) MKMapView * mapView;
// 第三行  地址
@property (nonatomic, strong) UILabel * address;
// 第三行  详细地址
@property (nonatomic, strong) UILabel * detailAddress;
// 下面的签到按钮底部的view
@property (nonatomic, strong) UIView * bottomView;
// 签到
@property (nonatomic, strong) UIButton * qiandaoButton;


@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation QiandaoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AFHTTPSessionManager * requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer.timeoutInterval = 10.f;
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString * uid = account.userID;
    NSString * url = [NSString stringWithFormat:Qiaodao_URl, self.latitude1, self.longitude1, @"", uid];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
           int status = [[[responseObject objectForKey:@"code"] description] intValue];
           if (status == 1) {

             self->times =  responseObject[@"times"];
              
//            self->times = dict[@"times"];
            self.grayLabel.text = [NSString stringWithFormat:@"今天你已经完成 %@ 次签到",self->times];
            // 富文本
            NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:self.grayLabel.text];
            [graytext beginEditing];
            //字体大小
            [graytext addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:30] range:NSMakeRange(8, self->times.length)];
            [graytext addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(8, self->times.length)];
            self.grayLabel.attributedText =  graytext;
            
        }else{
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"易签到";
    [self createUI];
}

// 反地理编码懒加载
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark -创建UI相关
- (void)createUI {
    /**
     *  导航栏
     */
    // 右边的统计按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    // 修改右边字体颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    // 底部的白色view
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 300)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteView];
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    
    /**
     *  第一行
     */
    // 第一行  红色
    self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    self.headImageV.clipsToBounds = YES;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:userInfo.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    self.headImageV.layer.cornerRadius = 30.f;
    [self.whiteView addSubview:self.headImageV];
    
    // 第一行  姓名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageV.frame)+10, CGRectGetMinY(self.headImageV.frame)+7, 200, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.whiteView addSubview:_nameLabel];
    
    UserInfoModel *model = [UserInfoManager getUserInfo];
    if (model.nickname.length > 0) {
        _nameLabel.text = [model.nickname description];
        
    }else{
        _nameLabel.text = model.username;
    }
    
    
    // 第一行  灰色签到
    _grayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame)+10, 300, 20)];
    _grayLabel.font = [UIFont systemFontOfSize:16];
    _grayLabel.textColor = [UIColor colorWithWhite:0.682 alpha:1.000];
    [self.whiteView addSubview:_grayLabel];
    
    // 第一行 下划线
    _grayLine = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_grayLabel.frame)+18, SCREEN_WIDTH-24, 1)];
    _grayLine.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
    [self.whiteView addSubview:_grayLine];
    
    
    
    
    
    /**
     *  第二行
     */
    
    // 第二行 日期
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_grayLine.frame), CGRectGetMaxY(_grayLine.frame)+20, SCREEN_WIDTH, 20)];
    _dateLabel.text =  [NSString stringWithFormat:@"%@  %@", [self featureWeekdayWithDate:[self getCurrentTime]], [self getCurrentTime]];
    _dateLabel.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [self.whiteView addSubview:_dateLabel];
    
    
    
    
    /**
     *  第三行
     */
    
    // 第三行 地图
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dateLabel.frame), CGRectGetMaxY(_dateLabel.frame)+20, SCREEN_WIDTH-24, 100)];
    _middleView.layer.borderWidth = 1;
    _middleView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.whiteView addSubview:_middleView];
    
    
    // 第三行 地图button
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, _middleView.height+20, _middleView.height)];
    // 2.设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    // 3.设置代理
    self.mapView.delegate = self;
    
    // 1.跟踪用户位置(显示用户的具体位置)
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.zoomEnabled = YES;
    _mapView.showsUserLocation = YES;
    [self.middleView addSubview:self.mapView];
    
    // 我的位置定位
    [self MyLocationAction];
    
    // 第三行 地址
    _address = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mapView.frame), 10, _middleView.width-_mapView.width, 14)];
    _address.text = @"签到地址:";
    [self.middleView addSubview:_address];
    // 第三行 详细地址
    _detailAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_address.frame), CGRectGetMaxY(_address.frame), _address.width, _mapView.height-_address.height)];
    _detailAddress.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _detailAddress.numberOfLines = 0;
    [self.middleView addSubview:_detailAddress];
    
    
    
    /**
     *  第四行
     */
    
    // 下面的签到按钮底部的view
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_whiteView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-_whiteView.height-64)];
    _bottomView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_bottomView];
    
    // 签到按钮
    _qiandaoButton = [[UIButton alloc] init];
    UIImage * image = [UIImage imageNamed:@"qiandao"];
    [_qiandaoButton setImage:image forState:UIControlStateNormal];
    [_qiandaoButton addTarget:self action:@selector(qiandaoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_qiandaoButton];
    
    [_qiandaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.height.width.equalTo(@(image.size.width));
    }];
}

#pragma mark - 我的位置
- (void)MyLocationAction
{
    //初始化cllLocationService
    _locService = [[CLLocationManager alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 2;
    [_locService requestAlwaysAuthorization];
    //启动LocationService
    [_locService startUpdatingLocation];
}

#pragma mark -定位和反地理编码
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * location = [locations lastObject];
    _latitude1 = location.coordinate.latitude;
    _longitude1 = location.coordinate.longitude;
    KGLog(@"定位成功------%f-------%f", _latitude1, _longitude1);
    self.location2D = CLLocationCoordinate2DMake(_latitude1, _longitude1);
    [self.mapView setCenterCoordinate:_location2D];
    
    // 反地理编码
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:self.latitude1 longitude:self.longitude1];
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            for (CLPlacemark * placemark in placemarks) {
                self.detailAddress.text = [NSString stringWithFormat:@"%@",placemark.name];
            }
        }else {
            
        }
    }];
}

#pragma mark -签到按钮点击事件
- (void)qiandaoButtonClicked:(UIButton *)sender {
    ZCAccount *account = [ZCAccountTool account];
    NSString *uid = account.userID;
    NSString *url = [NSString stringWithFormat:Qiaodao_URl,self.latitude1, self.longitude1, self.myAnnotation.title, uid];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        if (status == 1) {
            
            self->times =  responseObject[@"times"];
            // 签到成功
//            self->times = dic[@"times"];
            self.grayLabel.text = [NSString stringWithFormat:@"今天你已经完成 %@ 次签到",self->times];
            // 富文本
            NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:self.grayLabel.text];
            [graytext beginEditing];
            //字体大小
            [graytext addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:30] range:NSMakeRange(8, self->times.length)];
            [graytext addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(8, self->times.length)];
            self.grayLabel.attributedText =  graytext;
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"签到成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        }else{
            
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];

}

#pragma mark -当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd   HH:mm"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    
    return returnStr;
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

#pragma mark -导航栏按钮相关
- (void)rightItemClicked:(UIBarButtonItem *)item {
    AllQiandaoViewController * allVC  =[[AllQiandaoViewController alloc] init];
    [self.navigationController pushViewController:allVC animated:YES];
}

@end
