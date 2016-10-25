//
//  KaoqinTableCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "KaoqinTableCell.h"
 //
#import "GudingPaibanModel.h"
#import "BanciModel.h"
#import "LocationsModel.h"
#import <Masonry.h>

@implementation KaoqinTableCell

+ (instancetype)sharedKaoqinTableCell:(UITableView *)tableView
{
    static NSString *ID = @"KaoqinTableCell";
    KaoqinTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KaoqinTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setModel:(KaoqinModel *)model
{
    _model = model;
    _zuNameLabel.text = model.name;
    LocationsModel *localModel = [model.locations lastObject];
    _placeLabel.text = localModel.address;
    NSMutableString *formatWifi = [NSMutableString new];
    for (int i = 0; i < model.routers.count; i++) {
        
        NSString *wifi = model.routers[i];
        if (i != 0) {
            wifi = [NSString stringWithFormat:@"、%@",wifi];
        }
        formatWifi = (NSMutableString *)[formatWifi stringByAppendingString:wifi];
    }
    
    _wifiLabel.text = formatWifi;
    _numLabel.text = [NSString stringWithFormat:@"共%ld人",(unsigned long)[model.group_users count]];
    
    if ([model.type intValue] == 1) {
        // 固定班制
        NSMutableString *formatStr = [NSMutableString new];
        for (int i = 0; i < model.rule1.count; i++) {
            GudingPaibanModel *paibanModel = model.rule1[i];
            NSString *timeStr;
            if (i == 0) {
                
                timeStr = [NSString stringWithFormat:@"%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
                if (paibanModel.start.length < 1 && paibanModel.end.length < 1) {
                    timeStr = [NSString stringWithFormat:@"%@休息",paibanModel.week];
                }
            }else{
                timeStr = [NSString stringWithFormat:@"、%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
                if (paibanModel.start.length < 1 && paibanModel.end.length < 1) {
                    timeStr = [NSString stringWithFormat:@"、%@休息",paibanModel.week];
                }
            }
            
            formatStr = (NSMutableString *)[formatStr stringByAppendingString:timeStr];
            
        }
        _timeLabel.text = formatStr;
    }else{
        // 排班制 2
        _timeLabel.text = @"排班制，每周不定时上下班。";
        NSMutableString *formatStr = [NSMutableString new];
        for (int i = 0; i < model.rule2.count; i++) {
            GudingPaibanModel *paibanModel = model.rule2[i];
            NSString *timeStr;
            if (i == 0) {
                timeStr = [NSString stringWithFormat:@"%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
                if (paibanModel.start.length < 1 && paibanModel.end.length < 1) {
                    timeStr = [NSString stringWithFormat:@"%@休息",paibanModel.week];
                }
            }else{
                timeStr = [NSString stringWithFormat:@";%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
                if (paibanModel.start.length < 1 && paibanModel.end.length < 1) {
                    timeStr = [NSString stringWithFormat:@";%@休息",paibanModel.week];
                }
            }
            
            formatStr = (NSMutableString *)[formatStr stringByAppendingString:timeStr];
            KGLog(@"kk = %@",formatStr);
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 组名
    self.zuNameLabel = [[UILabel alloc]init];
    self.zuNameLabel.text = @"考勤组名称";
    self.zuNameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.zuNameLabel];
    [self.zuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.equalTo(@23);
    }];
    // 参与人数
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.text = @"34人";
    self.numLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zuNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.zuNameLabel.mas_centerY);
        make.height.equalTo(@23);
    }];
    // 排班时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"每周一、二、三、四、五 9：00-18：00\r周末双休";
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.numberOfLines = 0;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zuNameLabel.mas_left);
        make.top.equalTo(self.zuNameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right);
    }];
    // wifi
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaoqin_location"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.width.and.height.equalTo(@24);
    }];
    
    // 地址范围
    self.placeLabel = [[UILabel alloc]init];
    self.placeLabel.text = @"北京市海淀区海淀五路居爱儿美影楼体验庄园";
    self.placeLabel.textColor = [UIColor grayColor];
    self.placeLabel.font = [UIFont systemFontOfSize:15];
    self.placeLabel.numberOfLines = 2;
    [self addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(13);
    }];
    
    UIImageView *wifiImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaoqin_wifi"]];
    [self addSubview:wifiImg];
    [wifiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(imageV.mas_bottom).offset(3);
        make.width.and.height.equalTo(@24);
    }];
    
    // wifi名称
    self.wifiLabel = [[UILabel alloc]init];
    self.wifiLabel.text = @"aermei && 102.168.0.231";
    self.wifiLabel.textColor = [UIColor grayColor];
    self.wifiLabel.font = [UIFont systemFontOfSize:15];
    self.wifiLabel.numberOfLines = 2;
    [self addSubview:self.wifiLabel];
    [self.wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiImg.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(wifiImg.mas_centerY);
    }];
    
    /**
    // 底部按钮view
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = VCBackgroundColor;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@45);
    }];
    
    // 修改规则
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.backgroundColor = [UIColor whiteColor];
    changeButton.tag = 14;
    [changeButton setTitle:@"修改规则" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(postNotiAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setTitleColor:RGBACOLOR(85, 169, 225, 1) forState:UIControlStateNormal];
//    changeButton.backgroundColor = HWRandomColor;
    changeButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [backView addSubview:changeButton];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.bottom.equalTo(backView.mas_bottom);
        make.width.equalTo(@((SCREEN_WIDTH-1)/2));
        make.height.equalTo(@44);
    }];
    
    // 查看成员
    UIButton *watchStaff = [UIButton buttonWithType:UIButtonTypeCustom];
    watchStaff.backgroundColor = [UIColor whiteColor];
    watchStaff.tag = 15;
    [watchStaff setTitle:@"修改成员" forState:UIControlStateNormal];
    [watchStaff addTarget:self action:@selector(postNotiAction:) forControlEvents:UIControlEventTouchUpInside];
    [watchStaff setTitleColor:RGBACOLOR(85, 169, 225, 1) forState:UIControlStateNormal];
//    watchStaff.backgroundColor = HWRandomColor;
    watchStaff.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [backView addSubview:watchStaff];
    [watchStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeButton.mas_right).offset(1);
        make.bottom.equalTo(backView.mas_bottom);
        make.width.equalTo(@((SCREEN_WIDTH-1)/2));
        make.height.equalTo(@44);
    }];
 */
}

#pragma mark - 点击事件
- (void)postNotiAction:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 14:
            // 修改规则
            self.clickType = EditGuizeType;
            break;
        case 15:
            // 修改成员
            self.clickType = ChangeMemType;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(kaoqinDidClickType:Model:)]) {
        [self.delegate kaoqinDidClickType:self.clickType Model:self.model];
    }
}

@end
