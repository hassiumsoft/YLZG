//
//  IvitMembersTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IvitMembersTableCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface IvitMembersTableCell ()

@property (strong,nonatomic) UIImageView *headV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *deptLabel;


@end

@implementation IvitMembersTableCell

+ (instancetype)sharedIvitMembersTableCell:(UITableView *)tableView
{
    static NSString *ID = @"IvitMembersTableCell";
    IvitMembersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[IvitMembersTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setModel:(ContactersModel *)model
{
    _model = model;
    [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    _deptLabel.text = model.dept;
    _nameLabel.text = model.nickname.length > 0 ? model.nickname:model.realname;
    if (!model.isSelected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
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
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 3;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headV.frame) + 10, 2, 200, 21)];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    
    
    self.deptLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headV.frame) + 10, CGRectGetMaxY(self.nameLabel.frame), 150, 21)];
    self.deptLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.deptLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self addSubview:self.deptLabel];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    [self addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.width.and.height.equalTo(@50);
    }];
    
}
@end
