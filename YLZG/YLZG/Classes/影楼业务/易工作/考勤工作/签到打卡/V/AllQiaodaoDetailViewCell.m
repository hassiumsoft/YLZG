//
//  AllQiaodaoDetailViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AllQiaodaoDetailViewCell.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

@interface AllQiaodaoDetailViewCell()<MKMapViewDelegate, CLLocationManagerDelegate>

// 反地理编码
@property (nonatomic,strong) CLGeocoder * geocoder;

@end

@implementation AllQiaodaoDetailViewCell

// 反地理编码懒加载
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

+ (instancetype)sharedAllQiaodaoDetailViewCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"AllQiaodaoDetailViewCell";
    AllQiaodaoDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AllQiaodaoDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)setModel:(AllQiaodaoDetailModel *)model {
    _model = model;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"place_head"]];
    _realnameLabel.text = [NSString stringWithFormat:@"%@   %@", model.realname, [self scx_toDateWithTimeStamp:model.intime]];

    // 反地理编码
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:[model.location_x floatValue] longitude:[model.location_y floatValue]];
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            for (CLPlacemark * placemark in placemarks) {
                [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",placemark.name] forState:UIControlStateNormal];
            }
        }else {
            
        }
    }];
}

- (void)createCell {
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    
    _headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    _headImageV.layer.masksToBounds = YES;
    _headImageV.layer.cornerRadius = 20;
    [whiteView addSubview:_headImageV];
    
    _realnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageV.frame)+15, 20, 200, 20)];
    _realnameLabel.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:_realnameLabel];
    
    _addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_headImageV.frame)+10, SCREEN_WIDTH, 30)];
    [_addressBtn setTitleColor:RGBACOLOR(124, 124, 124, 1) forState:UIControlStateNormal];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_addressBtn setImage:[UIImage imageNamed:@"Qiandao_adress"] forState:UIControlStateNormal];
    _addressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [whiteView addSubview:_addressBtn];
}


#pragma mark -时间戳转换成时间
- (NSString *)scx_toDateWithTimeStamp:(NSString *)timeStamp {
    NSString *arg = timeStamp;
    
    if (![timeStamp isKindOfClass:[NSString class]]) {
        arg = [NSString stringWithFormat:@"%@", timeStamp];
    }
    NSTimeInterval time = [timeStamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}



@end
