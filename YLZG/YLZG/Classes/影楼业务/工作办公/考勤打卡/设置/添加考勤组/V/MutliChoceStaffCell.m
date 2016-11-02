//
//  MutliChoceStaffCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "MutliChoceStaffCell.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"

@implementation MutliChoceStaffCell

+ (instancetype)sharedMutliChoceStaffCell:(UITableView *)tableView
{
    static NSString *ID = @"MutliChoceStaffCell";
    MutliChoceStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MutliChoceStaffCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(StaffInfoModel *)model
{
    _model = model;
    _nameLabel.text = model.nickname;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    if (model.isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
}

- (void)setupSubViews
{
    
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 5;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"吴彦祖";
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.headImageV.mas_right).offset(10);
        make.height.equalTo(@24);
    }];
    
    
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    [self addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.and.height.equalTo(@30);
    }];
    
}
- (UIImage *)imageWithBgColor:(UIColor *)color
{
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
