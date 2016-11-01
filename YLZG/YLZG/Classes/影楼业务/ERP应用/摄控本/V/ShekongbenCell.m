//
//  ShekongbenCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ShekongbenCell.h"
#import <Masonry.h>
#import "NSDate+Extension.h"
#import "NSString+StrCategory.h"


@interface ShekongbenCell ()

/** 时间-日期 */
@property (strong,nonatomic) UILabel *dateLabel;
/** 时间-时分秒 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 修饰图 */
@property (strong,nonatomic) UIImageView *imageV;
/** 套系名称 */
@property (strong,nonatomic) UILabel *taoxiLabel;
/** 客户姓名 */
@property (strong,nonatomic) UILabel *guestLabel;

@end

@implementation ShekongbenCell

+ (instancetype)sharedShekongbenCell:(UITableView *)tableView
{
    static NSString *ID = @"ShekongbenCell";
    ShekongbenCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[ShekongbenCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(ShekongbenModel *)model
{
    _model = model;
    // 修饰图
    if ([model.type intValue] == 0) {
        _imageV.image = [UIImage imageNamed:@"mywork_paizhao"];
    }else if ([model.type intValue] == 1) {
        _imageV.image = [UIImage imageNamed:@"mywork_xuanpian"];
    }else if ([model.type intValue] == 2) {
        _imageV.image = [UIImage imageNamed:@"mywork_kansheji"];
    }else if ([model.type intValue] == 3) {
        _imageV.image = [UIImage imageNamed:@"mywork_qujian"];
    }else if ([model.type intValue] == 4) {
        _imageV.image = [UIImage imageNamed:@"mywork_xiupian"];
    }else if ([model.type intValue] == 5) {
        _imageV.image = [UIImage imageNamed:@"mywork_sheji"];
    }else if ([model.type intValue] == 6) {
        _imageV.image = [UIImage imageNamed:@"mywork_qujian"];
    }
    // 名字
    _guestLabel.text = model.guest;
    // 套系名字
    _taoxiLabel.text = [NSString stringWithFormat:@"%@",model.set_name];
    // 时分秒
    NSArray * timeArr = [model.time componentsSeparatedByString:@" "];
    NSString *dateStr = [timeArr firstObject];
    NSDate *firstDate = [self dateChanged:dateStr];
    
    BOOL isToday = [firstDate letuisToday];
    if (isToday) {
        
        _dateLabel.text = @"今天";
    }else {
        NSString *lastTime = timeArr[0];
        if (lastTime.length >= 10) {
            NSString *subTime = [lastTime substringWithRange:NSMakeRange(5, 5)];
            subTime = [subTime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
            _dateLabel.text = [NSString stringWithFormat:@"%@日",subTime];
    
        }else{
            _dateLabel.text = lastTime;
        }
    }
    NSString *time = [timeArr lastObject];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@":"];
    if (time.length < 5) {
        time = [NSString stringWithFormat:@"%@0",time];
    }
    _timeLabel.text = time;
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
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@2);
    }];
    
    // 修饰图
    self.imageV = [[UIImageView alloc]init];
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(8);
        make.width.and.height.equalTo(@50);
    }];
    
    // 客户姓名
    self.guestLabel = [[UILabel alloc]init];
    self.guestLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.guestLabel];
    [self.guestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(8);
        make.height.equalTo(@21);
        make.width.equalTo(@(SCREEN_WIDTH - 66 - 90));
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    // 套系名称
    self.taoxiLabel = [[UILabel alloc]init];
    self.taoxiLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    self.taoxiLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:self.taoxiLabel];
    [self.taoxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestLabel.mas_bottom);
        make.height.equalTo(@21);
        make.left.equalTo(self.guestLabel.mas_left);
    }];
    
    // 时分秒
    self.timeLabel = [[UILabel alloc]init];
    if ([[UIDevice currentDevice].systemVersion intValue] >= 8.2) {
        self.timeLabel.font = [UIFont systemFontOfSize:20 weight:0.01];
    }else{
        self.timeLabel.font = [UIFont systemFontOfSize:20];
    }
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.mas_centerY).offset(-6);
        
    }];
    
    // 日期时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.dateLabel.textColor = self.taoxiLabel.textColor;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeLabel.mas_centerX);
        make.height.equalTo(@20);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    
    
}

#pragma mark -转换成date
- (NSDate *)dateChanged:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    
    return newDate;
}


@end
