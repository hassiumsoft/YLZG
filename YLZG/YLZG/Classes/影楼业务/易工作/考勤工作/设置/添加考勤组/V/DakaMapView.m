//
//  DakaMapView.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DakaMapView.h"
#import "UIView+Extension.h"

@interface DakaMapView ()
{
    CLLocationCoordinate2D local2D;
}
// 地图底部的view
@property (nonatomic, strong) UIView * middleView;

@end

@implementation DakaMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self createView];
    }
    return self;
}

- (void)setLocationDict:(NSDictionary *)locationDict {
    // 第三行 地图button
    // 第三行 地图
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    _middleView.layer.borderWidth = 1;
    _middleView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:_middleView];
    local2D = CLLocationCoordinate2DMake([locationDict[@"latitude"] doubleValue], [locationDict[@"longitude"] doubleValue]);
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.middleView addSubview:self.mapView];
    _mapView.zoomEnabled = YES;
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    BMKPointAnnotation * item = [[BMKPointAnnotation alloc] init];
    item.coordinate = local2D;
    item.title = locationDict[@"address"];
    [self.mapView addAnnotation:item];
    [self.mapView setCenterCoordinate:local2D];
    

    // 地址
    _address = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mapView.frame)+5, 0, _middleView.width-_mapView.width-5, 40)];
    _address.text = [NSString stringWithFormat:@"签到地址:%@", locationDict[@"address"]];
    _address.textAlignment = NSTextAlignmentLeft;
    _address.font = [UIFont systemFontOfSize:14];
    _address.numberOfLines = 0;
    [self.middleView addSubview:_address];
    
    // 更新打卡
    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateBtn.frame = CGRectMake(CGRectGetMaxY(_mapView.frame)+5, CGRectGetMaxY(_mapView.frame)-23, 70, 20);
    [self.updateBtn setTitle:@"更新打卡" forState:UIControlStateNormal];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.updateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.updateBtn setTitleColor:RGBACOLOR(43, 135, 227, 1) forState:UIControlStateNormal];
    [self.updateBtn setImage:[UIImage imageNamed:@"qiandaoUpdate"] forState:UIControlStateNormal];
    self.updateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.updateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.middleView addSubview:self.updateBtn];
    [self.updateBtn addTarget:self action:@selector(gengxinClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 正常打卡、迟到、缺卡、早退(上午打卡分5种情况:1.正常,外勤;2.迟到,外勤;3.正常;4.迟到;5.缺卡;;;;下午分4种:1.正常,外勤;2.早退,外勤;3.正常;4.早退)
    self.dakaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.updateBtn.frame)+5, CGRectGetMinY(self.updateBtn.frame)+5, 50, 15)];
    [self.middleView addSubview:self.dakaImageV];
    // 外勤打卡
    self.waiqinImageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dakaImageV.frame)+5, CGRectGetMinY(self.updateBtn.frame)+5, 50, 15)];
    [self.middleView addSubview:self.waiqinImageV];
}

- (void)gengxinClicked:(UIButton *)sender {
    if (self.updateButton) {
        self.updateButton();
    }
}

#pragma mark -更新打卡的点击事件
- (void)mapWithState:(int)state {
    switch (state) {
        case 0:{
            // 已经打卡
            
        }
            break;
        case 1:{
            // 未迟到,正常打卡
            self.dakaImageV.image = [UIImage imageNamed:@"zhengchangdaka_imageV"];
        }
            break;
        case 2:{
            // 迟到
            self.dakaImageV.image = [UIImage imageNamed:@"chidao_imageV"];
        }
            break;
        case 3:{
            // 外勤
            self.waiqinImageV.image = [UIImage imageNamed:@"waiqindaka_imageV"];
        }
            break;
        case 4:{
            // 旷工
            self.dakaImageV.image = [UIImage imageNamed:@"zaotui_imageV"];
        }
        case 5:{
            // 早退
            self.dakaImageV.image = [UIImage imageNamed:@"zaotui_imageV"];
        }
            break;
        case 6:{
            // 缺卡
            self.dakaImageV.image = [UIImage imageNamed:@"queka_imageV"];
        }
            break;
            
        default:
            break;
    }
}



@end
