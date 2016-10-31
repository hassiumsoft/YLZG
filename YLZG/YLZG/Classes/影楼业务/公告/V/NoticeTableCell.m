//
//  NoticeTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NoticeTableCell.h"
#import <Masonry.h>

@interface NoticeTableCell ()

/** 公告栏标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 公告栏的内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 公告发布时间 */
@property (strong,nonatomic) UILabel *timeLabel;

/** bottomV */
@property (strong,nonatomic) UIView  *bottomV;

@end

@implementation NoticeTableCell

+ (instancetype)sharedNoticeTableCell:(UITableView *)tableView
{
    static NSString *ID = @"NoticeTableCell";
    NoticeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[NoticeTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(NoticeModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    NSString *kk = [self TimeIntToDateStr:model.create_time];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",kk];
    
    if (model.top) {
        _imageV.image = [UIImage imageNamed:@"gonggao_zhiding"];
    }else{
        _imageV.image = [UIImage imageNamed:@"gonggao_gongao"];
    }
    
}
#pragma mark - 由时间戳转化为东八区时间字符串
- (NSString *)TimeIntToDateStr:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; // "cccc"星期几
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}

- (void)setupSubViews
{
    self.bottomV = [[UIView alloc]init];
    self.bottomV.userInteractionEnabled = YES;
    self.bottomV.layer.cornerRadius = 7;
    self.bottomV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomV];
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"关于五一9天长假公告";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = RGBACOLOR(28, 28, 28, 1);
    [self.bottomV addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomV.mas_top).offset(15);
        make.left.equalTo(self.bottomV.mas_left).offset(40);
        make.centerX.equalTo(self.bottomV.mas_centerX);
    }];
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = @"测试试测试测试测试测";
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.contentLabel.textColor = RGBACOLOR(107, 108, 107, 1);
    self.contentLabel.numberOfLines = 0;
    //    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomV addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomV.mas_left).offset(20);
        make.right.equalTo(self.bottomV.mas_right).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@63);
    }];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"2016年03月26日 12:30";
    //    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomV addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel.mas_right);
        make.height.equalTo(@20);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
    }];
    
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gonggao_zhiding"]];
    [self.bottomV addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomV.mas_left);
        make.top.equalTo(self.bottomV.mas_top);
        make.width.equalTo(@80);
        make.height.equalTo(@60);
    }];
    
}

@end
