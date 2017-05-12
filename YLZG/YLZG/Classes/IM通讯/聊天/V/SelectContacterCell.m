//
//  SelectContacterCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectContacterCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface SelectContacterCell ()

@property (strong,nonatomic) UIButton *selectedBtn;

@property (strong,nonatomic) UIImageView *headImageV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *deptLabel;

@end

@implementation SelectContacterCell

+ (instancetype)sharedMutliChoceStaffCell:(UITableView *)tableView
{
    static NSString *ID = @"SelectContacterCell";
    SelectContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectContacterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

- (void)setModel:(ContactersModel *)model
{
    _model = model;
    _nameLabel.text = model.nickname.length > 0 ? model.nickname : model.realname;
    _deptLabel.text = model.dept;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    if (model.isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
}

- (void)setupSubViews
{
    
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 4;
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"吴彦祖";
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self.headImageV.mas_right).offset(10);
        make.height.equalTo(@24);
    }];
    
    self.deptLabel = [[UILabel alloc]init];
    self.deptLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.deptLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self addSubview:self.deptLabel];
    [self.deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@20);
        make.left.equalTo(self.nameLabel.mas_left);
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


@end
