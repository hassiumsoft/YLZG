//
//  DakaMapView.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckWorkViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>


// 更新提示
typedef void(^UpdateButton)(void);

@interface DakaMapView : UIView

@property (nonatomic, strong) CheckWorkViewController * superController;
@property (nonatomic, copy) UpdateButton updateButton;

@property (nonatomic, strong)BMKMapView * mapView;
// 接收地址的数组
@property (nonatomic, strong)NSDictionary * locationDict;
// 迟到和早退
@property (nonatomic, strong) UIImageView * waiqinImageV;
// 正常打卡和外勤打卡
@property (nonatomic, strong) UIImageView * dakaImageV;
// 更新打卡
@property (nonatomic, strong) UIButton * updateBtn;
// 地址
@property (nonatomic, strong) UILabel * address;

// 打卡状态
@property (nonatomic, copy) NSString * stateStr;


- (void)mapWithState:(int)state;


@end
