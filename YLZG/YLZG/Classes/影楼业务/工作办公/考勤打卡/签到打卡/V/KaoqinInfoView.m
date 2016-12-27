//
//  KaoqinInfoView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/27.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "KaoqinInfoView.h"
#import "UserInfoManager.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface KaoqinInfoView ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headV;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 星期几 */
@property (strong,nonatomic) UILabel *weekLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *locationLabel;
/** WiFi */
@property (strong,nonatomic) UILabel *wifiLabel;

@end


@implementation KaoqinInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UserInfoModel *userModel = [UserInfoManager getUserInfo];
    self.headV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 40, 40)];
    [self.headV sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 20;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headV];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headV.frame) + 5, 15, 200, 21)];
    self.nameLabel.text = userModel.realname.length > 1 ? userModel.realname : userModel.nickname;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    
    self.weekLabel = [[UILabel alloc]init];
    self.weekLabel.text = [self weekChanged];
    self.weekLabel.font = [UIFont systemFontOfSize:15];
    self.weekLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.headV.mas_centerY);
    }];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headV.frame), SCREEN_WIDTH - 20, 21)];
    descLabel.text = @"⚠️ 打卡规则(符合以下其中一条即可):";
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.textColor = RGBACOLOR(76, 76, 76, 1);
    [self addSubview:descLabel];
    
    self.wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(descLabel.frame), SCREEN_WIDTH - 20, 21)];
    self.wifiLabel.text = @"WIFI:bangongshi";
    self.wifiLabel.font = [UIFont systemFontOfSize:15];
    self.wifiLabel.textColor = RGBACOLOR(76, 76, 76, 1);
    [self addSubview:self.wifiLabel];
    
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = self.wifiLabel.font;
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.textColor = self.wifiLabel.textColor;
    self.locationLabel.text = @"北京市东城区xx街28号xxxx影楼";
    [self addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.wifiLabel.mas_bottom);
    }];
    
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = [dict copy];
    NSString *wifiStr;
    NSString *locationStr;
    
    NSString *privilege_meter = [[dict objectForKey:@"privilege_meter"] description]; // 距离范围
    id locations = [dict objectForKey:@"locations"];
    if (![locations isKindOfClass:[NSNull class]]) {
        
        NSArray *locationArr = [dict objectForKey:@"locations"];
        NSDictionary *locationDict = [locationArr lastObject];
        NSString *address = [locationDict objectForKey:@"address"];
        locationStr = [NSString stringWithFormat:@"地理范围：%@%@范围内",address,privilege_meter];
    }else{
        locationStr = [NSString stringWithFormat:@"地理范围：未设置位置，请确保您的手机已连上规范WiFi。"];
    }
    id routers = [dict objectForKey:@"routers"];
    if (![routers isKindOfClass:[NSNull class]]) {
        NSArray *routersArr = [dict objectForKey:@"routers"];
        if (routersArr.count == 1) {
            wifiStr = [NSString stringWithFormat:@"Wifi规范：%@",[routersArr lastObject]];
        }else{
            wifiStr = @"Wifi规范：";
            for (int i = 0; i < routersArr.count; i++) {
                NSString *wifi = routersArr[i];
                wifi = [NSString stringWithFormat:@"%@ ",wifi];
                locationStr = [locationStr stringByAppendingString:wifi];
            }
        }
        
    }else{
        wifiStr = @"Wifi规范：管理员定制规则时没有设置WiFi";
    }
    _wifiLabel.text = wifiStr;
    _locationLabel.text = locationStr;
    
}

- (NSString *)weekChanged
{
    NSDate *date = [NSDate date];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"cccc"]; // 星期一
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}


@end
