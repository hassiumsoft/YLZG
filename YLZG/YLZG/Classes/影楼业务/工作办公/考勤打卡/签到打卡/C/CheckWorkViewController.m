//
//  CheckWorkViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CheckWorkViewController.h"
#import <MJExtension.h>
#import "TodayDakaRuleModel.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "NoDequTableCell.h"
#import "NormalIconView.h"
#import <Masonry.h>
#import "YuanCurrentTimeView.h"
#import "DakaTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "UserInfoManager.h"
#import "TodayDakaLocationsModel.h"
#import "TodayDakaWholeModel.h"
#import "CheckInOnModel.h"
#import "DakaManager.h"
#import "CheckInOffModel.h"
#import "WorkDakaModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


#define ScrollHeight (SCREEN_HEIGHT - 108 - self.headView.height)

@interface CheckWorkViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


/** HeadView */
@property (strong,nonatomic) UIView *headView;
/** 滚动栏 */
@property (strong,nonatomic) UIScrollView *backScrollView;
/** 反地理编码信息 */
@property (strong,nonatomic) BMKReverseGeoCodeResult *geoResult;

/** 上班打卡视图 */
@property (strong,nonatomic) UIView *OnWorkView;
/** 下班打卡视图 */
@property (strong,nonatomic) UIView *OffWorkView;
/** 底部按钮视图 */
@property (strong,nonatomic) UIView *QiandaoView;


// 定位
@property (nonatomic, strong) BMKLocationService * locService;
// 上班时的地图
//@property (nonatomic, strong) BMKMapView *OnWorkMapView;
// 下班时的地图
//@property (strong,nonatomic) BMKMapView *OffWorkMapView;
// 反地理编码
@property (strong,nonatomic) BMKGeoCodeSearch *geocoder;
// 我的经纬度
@property (assign,nonatomic) CLLocationCoordinate2D myCoordination;

/** 今日班次规则 */
@property (strong,nonatomic) TodayDakaRuleModel *ruleModel;
/** TodayDakaWholeModel */
@property (strong,nonatomic) TodayDakaWholeModel *wholeModel;
/** check-in */
@property (strong,nonatomic) CheckInOnModel *checkInModel;
/** check-off */
@property (strong,nonatomic) CheckInOffModel *checkOffModel;
/** WiFi名称模型 */
@property (strong,nonatomic) NSArray *wifiNameArray;
/** 可接受的打卡范围米数 */
@property (copy,nonatomic) NSString *privilege_meter;
/** 打卡的地理位置数组 */
@property (copy,nonatomic) NSArray *locationArray;

@property (strong,nonatomic) WorkDakaModel *model;


@end

@implementation CheckWorkViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 上班时的小地图
//    self.OnWorkMapView = [[BMKMapView alloc] init];
//    self.OnWorkMapView.gesturesEnabled = YES;
//    self.OnWorkMapView.overlookEnabled = YES;
//    self.OnWorkMapView.rotateEnabled = YES;
//    self.OnWorkMapView.showsUserLocation = YES;
//    self.OnWorkMapView.delegate = self;
//    self.OnWorkMapView.mapType = BMKMapTypeStandard;
    
    // 下班时的小地图
//    self.OffWorkMapView = [[BMKMapView alloc] init];
//    self.OffWorkMapView.gesturesEnabled = YES;
//    self.OffWorkMapView.overlookEnabled = YES;
//    self.OffWorkMapView.rotateEnabled = YES;
//    self.OffWorkMapView.showsUserLocation = YES;
//    self.OffWorkMapView.delegate = self;
//    self.OffWorkMapView.mapType = BMKMapTypeStandard;
    
    // 我的位置定位
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    self.geocoder = [[BMKGeoCodeSearch alloc]init];
    self.geocoder.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.OnWorkMapView.delegate = nil;
//    self.OffWorkMapView.delegate = nil;
    self.locService.delegate = nil;
    self.geocoder.delegate = nil;
    [self.locService stopUserLocationService];
    
//    self.OnWorkMapView = nil;
//    self.OffWorkMapView = nil;
    self.locService = nil;
    self.geocoder = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤打卡";
    [self getTodayRule];
    
}

#pragma mark - 获取今日考勤规则
- (void)getTodayRule
{
    NSString *url = [NSString stringWithFormat:QiandaoDakaAll_Url,[ZCAccountTool account].userID];
    [self showHudMessage:@"今日信息···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [self hideHud:0];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSDictionary *rule = [result objectForKey:@"rule"];
            NSDictionary *whole = [result objectForKey:@"whole"];
            NSArray *locations = [result objectForKey:@"locations"];
            self.wifiNameArray = [result objectForKey:@"routers"];
            NSDictionary *checkOn = result[@"checkin"][@"on"];
            NSDictionary *checkOff = result[@"checkin"][@"off"];
            
            self.ruleModel = [TodayDakaRuleModel mj_objectWithKeyValues:rule];
            self.wholeModel = [TodayDakaWholeModel mj_objectWithKeyValues:whole];
            self.privilege_meter = [result objectForKey:@"privilege_meter"];
            self.locationArray = [TodayDakaLocationsModel mj_objectArrayWithKeyValuesArray:locations];
            self.checkInModel = [CheckInOnModel mj_objectWithKeyValues:checkOn];
            self.checkOffModel = [CheckInOffModel mj_objectWithKeyValues:checkOff];
            self.model.time = [self getCurrentTime];
            self.model.areaMiles = self.privilege_meter;
            
            [self setupTopView];
            [self setupTodayRuleView];
            
        }else{
            [self CreateEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self CreateEmptyView:error.localizedDescription];
    }];
    
}

#pragma mark - 头部视图
- (void)setupTopView
{
    [self.view addSubview:self.headView];
    
    for (UIView *subViews in self.headView.subviews) {
        [subViews removeFromSuperview];
    }
    
    // 用户头像
    UIImageView *headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 48, 48)];
    headImgV.contentMode = UIViewContentModeScaleAspectFill;
    headImgV.layer.masksToBounds = YES;
    headImgV.layer.cornerRadius = 24;
    UserInfoModel *user = [UserInfoManager getUserInfo];
    [headImgV sd_setImageWithURL:[NSURL URLWithString:user.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    [_headView addSubview:headImgV];
    // 昵称
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgV.frame) + 4, 6, 100, 30)];
    nickLabel.font = [UIFont systemFontOfSize:15];
    nickLabel.text = user.realname.length > 1 ? user.nickname : user.realname;
    [_headView addSubview:nickLabel];
    // 考勤组
    UILabel *kaoqinzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgV.frame) + 4, CGRectGetMaxY(nickLabel.frame)-4, 200, 30)];
    kaoqinzuLabel.font = [UIFont systemFontOfSize:14];
    kaoqinzuLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    kaoqinzuLabel.text = [NSString stringWithFormat:@"%@(%@—%@)",self.ruleModel.classname,self.ruleModel.start,self.ruleModel.end];
    [_headView addSubview:kaoqinzuLabel];
    // 日期
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 90, 10, 90, 36)];
    dateLabel.layer.masksToBounds = YES;
    dateLabel.layer.cornerRadius = 5;
    dateLabel.layer.borderColor = MainColor.CGColor;
    dateLabel.layer.borderWidth = 0.5;
    dateLabel.text = [self getCurrentWeekDate];
    dateLabel.textColor = MainColor;
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.backgroundColor = RGBACOLOR(233, 241, 254, 1);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:dateLabel];
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 2)];
    [xian setImage:[UIImage imageNamed:@"xian"]];
    [_headView addSubview:xian];
}

#pragma mark - 一开始进来的样子。查看自己的打卡规则
- (void)setupTodayRuleView
{
    
    [self.view addSubview:self.backScrollView];
    
    // 定位
    [self.locService startUserLocationService];
    
//#warning 需要判断什么时候上班打卡，什么时候下班打卡
    int status = [self getStateAndupdate:NO];
    if (status == 1) {
        // 正常打卡
        if (!self.checkInModel.id) {
            // 上班正常打卡
            // 绘制上班打卡视图
            [self setupOnWorkTimeDakaStatus:UnDakaClicked OnOffWork:OnWorkType];
            // 下班--里面无信息，空view
            [self setupOffWorkViewDakaStstus:DakaClicked OnOffWork:OnWorkType];
            //  绘制签到时的视图
            [self setupQiandaoViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
        }else if(!self.checkOffModel.id){
            // 下班正常打卡
            [self setupOnWorkTimeDakaStatus:DakaClicked OnOffWork:OnWorkType];
            [self setupOffWorkViewDakaStstus:DakaClicked OnOffWork:OnWorkType];
            //  绘制签到时的视图
            [self setupQiandaoViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
        }
    }else if (status == 2 || status == 3){
        // 迟到打卡 --- 上班
        
        // 绘制上班打卡视图
        [self setupOnWorkTimeDakaStatus:UnDakaClicked OnOffWork:OnWorkType];
        // 下班--里面无信息，空view
        [self setupOffWorkViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
        //  绘制签到时的视图
        [self setupQiandaoViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
        
    }else if (status == 5){
        // 早退打卡
        
        // 上班--记录上班的信息
        [self setupOnWorkTimeDakaStatus:DakaClicked OnOffWork:OnWorkType];
        // 下班--里面无信息，空view
        [self setupOffWorkViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
        //  绘制签到时的视图
        [self setupQiandaoViewDakaStstus:UnDakaClicked OnOffWork:OnWorkType];
    }else{
        
    }
    
}

#pragma mark - 开始上班打卡时间
/**
 开始上班打卡时间

 @param dakaStutas 是否打卡
 @param workType 上班还是下班
 */
- (void)setupOnWorkTimeDakaStatus:(DakaStatus)dakaStutas OnOffWork:(OnOffWorkType)workType
{
    // 上班情况
    [self.backScrollView addSubview:self.OnWorkView];
    for (UIView *subViews in self.OnWorkView.subviews) {
        [subViews removeFromSuperview];
    }
    
    
    // 获取现在的时分
    NSString *kkk = [self getCurrentAreaDateAndTime];
    NSString *hourMinite = [kkk substringWithRange:NSMakeRange(11, 5)];
    hourMinite = [hourMinite stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    // 跟上班时间比较
    NSString *ruleStart = self.ruleModel.start;
    ruleStart = [ruleStart stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    
    // 左侧小图标
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"workTimeImage"]];
    [iconV setFrame:CGRectMake(10, 10, 25, 25)];
    iconV.contentMode = UIViewContentModeScaleAspectFill;
    [self.OnWorkView addSubview:iconV];
    
    // 最迟打卡时间
    UILabel *beginTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, 10, self.view.width - 60, 42)];
    beginTimeLabel.text = [NSString stringWithFormat:@"上班打卡时间 %@",self.ruleModel.start];
    beginTimeLabel.numberOfLines = 2;
    beginTimeLabel.font = [UIFont systemFontOfSize:13];
    [self.OnWorkView addSubview:beginTimeLabel];
    
    
    // 打卡信息
    if (dakaStutas == UnDakaClicked) {
        // 属于上班，展示打卡信息
        
        // 还没打卡，告诉用户，所在的位置和WiFi范围。
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(beginTimeLabel.frame), SCREEN_WIDTH - 50, 22)];
        label1.text = @"*上班打卡，请确保您符合以下任一条件：";
        label1.font = [UIFont systemFontOfSize:13];
        [self.OnWorkView addSubview:label1];
        // 地址
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(label1.frame), SCREEN_WIDTH - 80, 42)];
        label2.font = [UIFont systemFontOfSize:13];
        TodayDakaLocationsModel *lastLocalModel = [self.locationArray lastObject];
        label2.text = [NSString stringWithFormat:@"1、'%@'方圆%@米范围内",lastLocalModel.address,self.privilege_meter];
        label2.font = [UIFont systemFontOfSize:13];
        label2.numberOfLines = 2;
        [self.OnWorkView addSubview:label2];
        
        // WiFi
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 5, CGRectGetMaxY(label2.frame), SCREEN_WIDTH - 80, 42)];
        label3.font = [UIFont systemFontOfSize:13];
        NSMutableString *formatWifi = [NSMutableString new];
        for (int i = 0; i < self.wifiNameArray.count; i++) {
            
            NSString *wifi = self.wifiNameArray[i];
            if (i != 0) {
                wifi = [NSString stringWithFormat:@"、%@",wifi];
            }
            formatWifi = (NSMutableString *)[formatWifi stringByAppendingString:wifi];
        }
        label3.text = [NSString stringWithFormat:@"2、您手机所连接的WiFi包含其中:%@",formatWifi];
        label3.font = [UIFont systemFontOfSize:13];
        label3.numberOfLines = 2;
        [self.OnWorkView addSubview:label3];
        
        
    }else{
        // 早退、下班，展示上班信息
        // 时间显示
        iconV.image = [UIImage imageNamed:@"workTimeImage_select"];
        if (self.checkInModel.time) {
            // 已经打了上班卡
            beginTimeLabel.text = [NSString stringWithFormat:@"打卡时间%@(上班时间%@,弹性%@分钟)",self.checkInModel.time,self.ruleModel.start,self.wholeModel.privilege_time];
            // 打卡地址
            UILabel *dakaLocal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(beginTimeLabel.frame), SCREEN_WIDTH - 50, 24)];
            dakaLocal.text = [NSString stringWithFormat:@"打卡地址：%@",[[self.checkInModel.location objectForKey:@"address"] description]];
            dakaLocal.font = [UIFont systemFontOfSize:13];
            [self.OnWorkView addSubview:dakaLocal];
            // WiFi信息
            UILabel *wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame)+10, CGRectGetMaxY(dakaLocal.frame), SCREEN_WIDTH - 50, 24)];
            wifiLabel.text = [NSString stringWithFormat:@"WiFi信息：%@",self.checkInModel.router];
            wifiLabel.font = dakaLocal.font;
            [self.OnWorkView addSubview:wifiLabel];
            
            UIImageView *yesImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_yes"]];
            [self.OnWorkView addSubview:yesImgV];
            [yesImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.OnWorkView.mas_centerX);
                make.bottom.equalTo(self.OnWorkView.mas_bottom);
                make.width.and.height.equalTo(@(80*CKproportion));
            }];
            
        }else{
            // 没有打上班卡--准备打卡
            beginTimeLabel.text = [NSString stringWithFormat:@"缺卡(上班时间%@,弹性%@分钟)",self.ruleModel.start,self.wholeModel.privilege_time];
            // 上午缺卡
            UILabel *queKaLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(beginTimeLabel.frame) + 40*CKproportion, SCREEN_WIDTH - 100, 40)];
            queKaLabel.text = @"上班缺卡";
            queKaLabel.font = [UIFont boldSystemFontOfSize:28];
            queKaLabel.textColor = WechatRedColor;
            queKaLabel.textAlignment = NSTextAlignmentCenter;
            [self.OnWorkView addSubview:queKaLabel];
            
        }
        
    }
    
    
    
}

#pragma mark - 绘制下班打卡视图
/**
 绘制下班打卡视图

 @param dakaStutas 是否打卡
 @param workType 上班还是下班
 */
- (void)setupOffWorkViewDakaStstus:(DakaStatus)dakaStutas OnOffWork:(OnOffWorkType)workType
{
    
    // 下班情况
    [self.backScrollView addSubview:self.OffWorkView];
    for (UIView *subViews in self.OffWorkView.subviews) {
        [subViews removeFromSuperview];
    }
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    [self.OffWorkView addSubview:xian];
    
    // 左侧小图标
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"workTimeImage"]];
    [iconV setFrame:CGRectMake(10, 10, 25, 25)];
    iconV.contentMode = UIViewContentModeScaleAspectFill;
    [self.OffWorkView addSubview:iconV];
    
    // 最早打卡时间
    UILabel *beginTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, 10, self.view.width - 60, 42)];
    beginTimeLabel.text = [NSString stringWithFormat:@"下班打卡时间 %@",self.ruleModel.end];
    beginTimeLabel.numberOfLines = 2;
    beginTimeLabel.font = [UIFont systemFontOfSize:15];
    [self.OffWorkView addSubview:beginTimeLabel];
    
    if (dakaStutas == UnDakaClicked) {
        // 还没打卡，告诉用户，所在的位置和WiFi范围。
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(beginTimeLabel.frame), SCREEN_WIDTH - 50, 22)];
        label1.text = @"*下班打卡，请确保您符合以下任一条件：";
        label1.font = [UIFont systemFontOfSize:13];
        [self.OffWorkView addSubview:label1];
        // 地址
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(label1.frame), SCREEN_WIDTH - 80, 42)];
        label2.font = [UIFont systemFontOfSize:13];
        TodayDakaLocationsModel *lastLocalModel = [self.locationArray lastObject];
        label2.text = [NSString stringWithFormat:@"1、'%@'方圆%@米范围内",lastLocalModel.address,self.privilege_meter];
        label2.font = [UIFont systemFontOfSize:13];
        label2.numberOfLines = 2;
        [self.OffWorkView addSubview:label2];
        
        // WiFi
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 5, CGRectGetMaxY(label2.frame), SCREEN_WIDTH - 80, 42)];
        label3.font = [UIFont systemFontOfSize:13];
        NSMutableString *formatWifi = [NSMutableString new];
        for (int i = 0; i < self.wifiNameArray.count; i++) {
            
            NSString *wifi = self.wifiNameArray[i];
            if (i != 0) {
                wifi = [NSString stringWithFormat:@"、%@",wifi];
            }
            formatWifi = (NSMutableString *)[formatWifi stringByAppendingString:wifi];
        }
        label3.text = [NSString stringWithFormat:@"2、您手机所连接的WiFi包含其中:%@",formatWifi];
        label3.font = [UIFont systemFontOfSize:13];
        label3.numberOfLines = 2;
        [self.OffWorkView addSubview:label3];
        
    }else{
        // 已经打了下班卡

        if (self.checkOffModel.id) {
            // 打了下班卡 打下班卡的信息展示一下
            beginTimeLabel.text = [NSString stringWithFormat:@"打卡时间%@(下班时间%@)",self.checkInModel.time,self.ruleModel.end];
            // 打卡地址
            UILabel *dakaLocal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(beginTimeLabel.frame), SCREEN_WIDTH - 50, 24)];
            dakaLocal.text = [NSString stringWithFormat:@"打卡地址：%@",[[self.checkInModel.location objectForKey:@"address"] description]];
            dakaLocal.font = [UIFont systemFontOfSize:13];
            [self.OnWorkView addSubview:dakaLocal];
            // WiFi信息
            UILabel *wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame)+10, CGRectGetMaxY(dakaLocal.frame), SCREEN_WIDTH - 50, 24)];
            wifiLabel.text = [NSString stringWithFormat:@"WiFi信息：%@",self.checkInModel.router];
            wifiLabel.font = dakaLocal.font;
            [self.OnWorkView addSubview:wifiLabel];
            
            UIImageView *yesImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_yes"]];
            [self.OnWorkView addSubview:yesImgV];
            [yesImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.OnWorkView.mas_centerX);
                make.bottom.equalTo(self.OnWorkView.mas_bottom);
                make.width.and.height.equalTo(@(80*CKproportion));
            }];
        }else{
            // 没打下班卡---告诉用户你在哪里了
            
            // 还没打卡，告诉用户，所在的位置和WiFi范围。
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(beginTimeLabel.frame), SCREEN_WIDTH - 50, 22)];
            label1.text = @"*下班打卡，请确保您符合以下任一条件：";
            label1.font = [UIFont systemFontOfSize:13];
            [self.OffWorkView addSubview:label1];
            // 地址
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 10, CGRectGetMaxY(label1.frame), SCREEN_WIDTH - 80, 42)];
            label2.font = [UIFont systemFontOfSize:13];
            TodayDakaLocationsModel *lastLocalModel = [self.locationArray lastObject];
            label2.text = [NSString stringWithFormat:@"1、'%@'方圆%@米范围内",lastLocalModel.address,self.privilege_meter];
            label2.font = [UIFont systemFontOfSize:13];
            label2.numberOfLines = 2;
            [self.OffWorkView addSubview:label2];
            
            // WiFi
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + 5, CGRectGetMaxY(label2.frame), SCREEN_WIDTH - 80, 42)];
            label3.font = [UIFont systemFontOfSize:13];
            NSMutableString *formatWifi = [NSMutableString new];
            for (int i = 0; i < self.wifiNameArray.count; i++) {
                
                NSString *wifi = self.wifiNameArray[i];
                if (i != 0) {
                    wifi = [NSString stringWithFormat:@"、%@",wifi];
                }
                formatWifi = (NSMutableString *)[formatWifi stringByAppendingString:wifi];
            }
            label3.text = [NSString stringWithFormat:@"2、您手机所连接的WiFi包含其中:%@",formatWifi];
            label3.font = [UIFont systemFontOfSize:13];
            label3.numberOfLines = 2;
            [self.OffWorkView addSubview:label3];
        }
        
    }
    
    
}

#pragma mark - 绘制签到视图
/**
 绘制签到视图

 @param dakaStutas 是否打卡
 @param workType 上班还是下班
 */
- (void)setupQiandaoViewDakaStstus:(DakaStatus)dakaStutas OnOffWork:(OnOffWorkType)workType
{
    // 签到视图
    [self.backScrollView addSubview:self.QiandaoView];
    for (UIView *subViews in self.QiandaoView.subviews) {
        [subViews removeFromSuperview];
    }
    
    YuanCurrentTimeView *yuanView = [[YuanCurrentTimeView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-65*CKproportion, 1, 130*CKproportion, 130*CKproportion)];
    yuanView.yuanClick = ^(){
        QIaodaoBeizhuView *beizhuView = [QIaodaoBeizhuView sharedBeizhuView];
        beizhuView.DakaClickBlock = ^(NSString *beizhu){
            [self dakaAction:beizhu];
        };
        beizhuView.frame = SCREEN_BOUNDS;
        beizhuView.addressText.text = self.geoResult.address;
        [self.view addSubview:beizhuView];
        
    };
    if ([self getStateAndupdate:NO] == 2 || [self getStateAndupdate:NO] == 3) {
        yuanView.firstLabel.text = @"迟到打卡";
        yuanView.imageView.image = [UIImage imageNamed:@"chidaoAndyichang"];
    }else if ([self getStateAndupdate:NO] == 5) {
        yuanView.firstLabel.text = @"早退打卡";
        yuanView.imageView.image = [UIImage imageNamed:@"chidaoAndyichang"];
    }else if ([self getStateAndupdate:NO] == 1) {
        yuanView.firstLabel.text = @"正常打卡";
        yuanView.imageView.image = [UIImage imageNamed:@"zhengchangdaka"];
    }else{
        yuanView.firstLabel.text = @"打卡";
        yuanView.imageView.image = [UIImage imageNamed:@"zhengchangdaka"];
    }
    [self.QiandaoView addSubview:yuanView];
    
    // WiFi范围
    UILabel *wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yuanView.frame), self.view.width, 21)];
    NSString *currentWifiName = [[DakaManager sharedManager] getWifiName];
    wifiLabel.textAlignment = NSTextAlignmentCenter;
    wifiLabel.font = [UIFont systemFontOfSize:14];
    [self.QiandaoView addSubview:wifiLabel];
    
    
    if ([self.wifiNameArray containsObject:currentWifiName]) {
        wifiLabel.text = [NSString stringWithFormat:@"✌️您已进入%@覆盖范围",currentWifiName];
        wifiLabel.textColor = MainColor;
    }else{
        wifiLabel.text = [NSString stringWithFormat:@"😭您尚未到达设定WiFi范围内"];
        wifiLabel.textColor = WechatRedColor;
    }
}
#pragma mark - 打卡操作
- (void)dakaAction:(NSString *)beizhu
{
//    @"http://zsylou.wxwkf.com/index.php/home/attence/checkin?uid=%@&type=%@&id=%@&time=%@&location=%@&status=%@&outside=%@&remark=%@"
    
    NSString *typeStr;
    if (!self.checkInModel.id) {
        typeStr = @"1";// 上班打卡
    }else{
        typeStr = @"2";// 下班打卡
    }
    NSString *latitude = [NSString stringWithFormat:@"%f",self.geoResult.location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.geoResult.location.longitude];
    NSDictionary *addressDict = @{@"address":self.geoResult.address,@"latitude":latitude,@"longitude":longitude};
    NSString *state = [NSString stringWithFormat:@"%d",[self getStateAndupdate:NO]];
    NSString *outsideStr = @"0";
    NSString *currentWifiName = [[DakaManager sharedManager] getWifiName];
    NSString * url = [NSString stringWithFormat:QiandaoDakaChenggong_Url, [ZCAccountTool account].userID, typeStr,self.checkInModel.id, [self getHHCurrentTime],currentWifiName,[self toJsonStr:addressDict], state, outsideStr, beizhu];
    [self showHudMessage:@"正在打卡"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"]  description];
        [self hideHud:0];
        if (code == 1) {
            // 签到成功
            [self getTodayRule];
            [self sendErrorWarning:@"打卡成功"];
        }else {
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

#pragma mark - state相关
- (int)getStateAndupdate:(BOOL)isUpdate {
    
    NSString * centerTimeStr = [self getMiddleTime:[NSString stringWithFormat:@"%@", self.ruleModel.start] andEndTime:self.ruleModel.end];
    int centerTime = [[centerTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    
    int nowStr = [[[self getHHCurrentTime] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int startTime = [[self.ruleModel.start stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    int endTime = [[self.ruleModel.end stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    
    // 状态
    int state = -1;
    
    if (nowStr <= centerTime) {
        // 上午时间未达到一半
        if (!self.checkInModel.id) {
            // 如果上午未打卡
            if(nowStr > ([self.wholeModel.privilege_time intValue]+startTime)) {
                // 迟到
                if (nowStr > ([self.wholeModel.latetime intValue]+startTime)) {
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
                if(nowStr > ([self.wholeModel.privilege_time intValue]+startTime)) {
                    // 迟到
                    if (nowStr > ([self.wholeModel.latetime intValue]+startTime)) {
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
        if (!self.checkOffModel.id) {
            
            if (nowStr > endTime) {
                // 正常下班
                state = 1;
            }else {
                // 早退
                state = 5;
            }
        }else {// 下午已经打过卡了
            
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
    return state;
}
#pragma mark -当前时间
- (NSString *)getHHCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
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


//QiandaoDakaChenggong_Url
- (UIScrollView *)backScrollView
{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.headView.height, SCREEN_WIDTH, ScrollHeight)];
        _backScrollView.backgroundColor = self.view.backgroundColor;
        _backScrollView.userInteractionEnabled = YES;
        if (SCREEN_WIDTH >= 375) {
            // 4.7以上的
            _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,ScrollHeight);
        }else{
            _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,ScrollHeight + 80);
        }
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
    }
    return _backScrollView;
}

#pragma mark - 定位代理

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    
    
    CLLocationCoordinate2D local2D = CLLocationCoordinate2DMake(latitude, longitude);
    self.myCoordination = local2D;
    
    // 反地理编码
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = self.myCoordination;
    
    [self.geocoder reverseGeoCode:reverseGeoCodeSearchOption];
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.geoResult = result;
    [self setupTodayRuleView];
    
}

- (void)dealloc {
    [YLNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.locService stopUserLocationService];
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
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _headView.backgroundColor = self.view.backgroundColor;
        _headView.userInteractionEnabled = YES;
        
    }
    return _headView;
}

- (NSString *)getCurrentWeekDate
{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *dateStr = [returnStr substringWithRange:NSMakeRange(5, 5)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    int weekDay = (int)[comps weekday];
    
    NSString *weekStr;
    switch (weekDay) {
        case 1:
            weekStr = @"星期天";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        default:
            break;
    }
    
    weekStr = [NSString stringWithFormat:@"%@ %@",dateStr,weekStr];
    
    return weekStr;
}

- (WorkDakaModel *)model
{
    if (!_model) {
        _model = [[WorkDakaModel alloc]init];
    }
    return _model;
}
- (UIView *)OnWorkView
{
    if (!_OnWorkView) {
        _OnWorkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.backScrollView.height/3)];
        _OnWorkView.backgroundColor = self.view.backgroundColor;
    }
    return _OnWorkView;
}
- (UIView *)OffWorkView
{
    if (!_OffWorkView) {
        _OffWorkView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backScrollView.height/3, self.view.width, self.backScrollView.height/3)];
        _OffWorkView.backgroundColor = self.view.backgroundColor;
    }
    return _OffWorkView;
}

- (UIView *)QiandaoView
{
    if (!_QiandaoView) {
        _QiandaoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backScrollView.height/3 * 2, self.view.width, self.backScrollView.height/3)];
        _QiandaoView.backgroundColor = self.view.backgroundColor;
    }
    return _QiandaoView;
}

@end
