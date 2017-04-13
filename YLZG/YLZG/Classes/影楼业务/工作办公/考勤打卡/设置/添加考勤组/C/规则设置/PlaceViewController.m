//
//  PlaceViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/12.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "PlaceViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "NormalTableCell.h"



// BMKGeoCodeSearchDelegate
@interface PlaceViewController ()<UIGestureRecognizerDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
/** 地图 */
@property (strong,nonatomic) BMKMapView *mapView;
/** POI检索 */
@property (strong,nonatomic) BMKPoiSearch *poiSearch;
/** 定位 */
@property (strong,nonatomic) BMKLocationService *locaServer;
/** 定位管理者 */
@property (strong,nonatomic) BMKGeoCodeSearch *geoSearch;

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSArray *placeArr;

/** 位置信息 */
@property (copy,nonatomic) NSMutableDictionary *placeDict;

@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    
    
}
- (void)setupSubViews
{
    self.title = @"选择考勤位置";
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height * 0.45)];
    self.mapView.delegate = self;
    self.mapView.showMapScaleBar = YES;
    self.mapView.gesturesEnabled = YES;
    self.mapView.overlookEnabled = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    self.mapView.mapType = BMKMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    self.poiSearch = [[BMKPoiSearch alloc]init];
    
    // 添加自定义手势
    [self addCustomGestures];
    // 定位信息
    _locaServer = [[BMKLocationService alloc]init];
    _locaServer.delegate = self;
    [_locaServer startUserLocationService];
    
    // 获取当前位置，再拿到附近位置创建TabbleView。
//    [self getCurrentPlace];
    [self setupTableView];
}

#pragma mark - 定位代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 我的位置的坐标
    
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longtude = userLocation.location.coordinate.longitude;
    [_mapView showsUserLocation];
    [_mapView updateLocationData:userLocation];
    
    CLLocationCoordinate2D local2D = CLLocationCoordinate2DMake(latitude,longtude);
    [_mapView setCenterCoordinate:local2D animated:YES];
    
    // 反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longtude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    self.geoSearch = [BMKGeoCodeSearch new];
    _geoSearch.delegate = self;
    BOOL flag = [_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag){
//      KGLog(@"反geo检索发送成功");
        self.placeDict[@"latitude"] = [NSString stringWithFormat:@"%f",latitude];
        self.placeDict[@"longitude"] = [NSString stringWithFormat:@"%f",longtude];
    }else{
//      KGLog(@"反geo检索发送失败");
    }
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.placeArr = result.poiList;
        [self.tableView reloadData];
        
//        self.locaServer.delegate = nil;
        
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - 表格相关
- (void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), SCREEN_WIDTH, self.view.height * 0.55 - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = self.placeArr[indexPath.row];
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.text = info.address;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo *info = self.placeArr[indexPath.row];
    self.placeDict[@"address"] = info.address;
    if ([self.delegate respondsToSelector:@selector(placeDidselectedWithModel:WithPlaceinfo:)]) {
        [self.delegate placeDidselectedWithModel:info WithPlaceinfo:self.placeDict];
        [self dismiss];
    }
}
/*
 *注意：
 *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
 *否则影响地图内部的手势处理
 */
- (void)addCustomGestures
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
//    NSLog(@"my handleSingleTap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
//    KGLog(@"my handleDoubleTap");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

- (NSMutableDictionary *)placeDict
{
    if (!_placeDict) {
        _placeDict = [[NSMutableDictionary alloc]init];
    }
    return _placeDict;
}
- (void)dismiss
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.mapView.delegate = nil;
        self.poiSearch.delegate = nil;
        self.locaServer.delegate = nil;
        self.geoSearch.delegate = nil;
    }];
}

- (NSArray *)placeArr
{
    if (!_placeArr) {
        _placeArr = [NSArray array];
    }
    return _placeArr;
}

-(void)dealloc
{
    self.mapView.delegate = nil;
    self.poiSearch.delegate = nil;
    self.locaServer.delegate = nil;
    self.geoSearch.delegate = nil;
}

@end
