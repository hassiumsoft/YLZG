//
//  StaffTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/3/31.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "StaffTableViewCell.h"
#import "NSString+StrCategory.h"
#import "HTTPManager.h"
#import "UIImageView+WebCache.h"
#import "ZCAccountTool.h"
#import <Masonry.h>


@implementation StaffTableViewCell

- (void)setModel:(StaffInfoModel *)model
{
    _model = model;
    _phoneLabel.text = model.dept;
    
    ZCAccount *account = [ZCAccountTool account];
    
    NSString * woStr = [NSString stringWithFormat:@"%@_%@",model.store_simple_name, model.username];
    if ([woStr isEqualToString:account.username]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@(我)",model.nickname];
    }
    NSString *head = [NSString stringWithFormat:@"%@",model.head];
    if ([model.gender intValue] == 1) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    }else{
        [_imageV sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    }
    
    if ([[model.type description]integerValue] == 1) {
        // 店长
        _nameLabel.text = [NSString stringWithFormat:@"%@(店长)",model.nickname];
    }else{
        _nameLabel.text = model.nickname;
    }
}
#pragma mark - 时间戳转化
- (NSString *)timeChanged:(NSTimeInterval)timeChuo
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeChuo];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    if (origanStr.length >= 10) {
        NSString *time = [origanStr substringWithRange:NSMakeRange(0, 10)];
        return time;
    }else{
        return origanStr;
    }
}


+ (instancetype)sharedStaffTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"StaffTableViewCell";
    StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StaffTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryDetailButton];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 4;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@44);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(8);
        make.top.equalTo(self.imageV.mas_top).offset(2);
        make.height.equalTo(@21);
    }];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.text = @"135-3772-9096";
    self.phoneLabel.font = [UIFont systemFontOfSize:12];
    self.phoneLabel.textColor = [UIColor grayColor];
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(8);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    
     
    self.wo = [[UILabel alloc]init];
    self.wo.font = [UIFont systemFontOfSize:11];
    self.wo.textColor = RGBACOLOR(51, 201, 10, 1);
    [self addSubview:self.wo];
    [self.wo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.and.height.equalTo(@17);
    }];
}

-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
