//
//  QiaodaoMapViewController.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QiaodaoMapViewController.h"
#import "MapKit/MapKit.h"
#import "ZCAccountTool.h"

@interface QiaodaoMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationDegrees latitude1;
    CLLocationDegrees longitude1;
}
// 地图
@property (nonatomic, strong) MKMapView * mapView;
// 定位
@property (nonatomic, strong) CLLocationManager * locService;
@property (nonatomic, assign)CLLocationCoordinate2D location2D;
@property (nonatomic, strong) MKPointAnnotation * myAnnotation;
// 反地理编码
@property (nonatomic,strong) CLGeocoder * geocoder;



@end

@implementation QiaodaoMapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到地图";

    // 界面布局
    [self createUI];
}

// 反地理编码懒加载
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark -界面布局
- (void)createUI {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    // 2.设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    // 3.设置代理
    self.mapView.delegate = self;
    
    // 1.跟踪用户位置(显示用户的具体位置)
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.zoomEnabled = YES;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];

    // 我的位置定位
    [self MyLocationAction];

}

#pragma mark - 我的位置
- (void)MyLocationAction
{
    //初始化BMKLocationService
    _locService = [[CLLocationManager alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 2;
    [_locService requestAlwaysAuthorization];
    //启动LocationService
    [_locService startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * location = [locations lastObject];
    latitude1 = location.coordinate.latitude;
    longitude1 = location.coordinate.longitude;
    KGLog(@"定位成功------%f-------%f", latitude1, longitude1);
    self.location2D = CLLocationCoordinate2DMake(latitude1, longitude1);
    [self.mapView setCenterCoordinate:_location2D];
    
    if (!self.myAnnotation) {
        self.myAnnotation = [[MKPointAnnotation alloc] init];
        self.myAnnotation.coordinate = _location2D;
        self.myAnnotation.title = @"当前位置";
        [_mapView addAnnotation:self.myAnnotation];
    }
    
    // 反地理编码
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            for (CLPlacemark * placemark in placemarks) {
                
                self.myAnnotation.title = [NSString stringWithFormat:@"地址:%@",placemark.name];
            }
        }else {

        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end






































