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
    if ([model.gender intValue] == 1) {
        [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    }else{
        [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"male_place"]];
    }
    _nameLabel.text = model.realname.length > 0 ? model.realname:model.name;
    if (!model.isSelected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"selected_no"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"selected_yes"] forState:UIControlStateNormal];
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
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place" ]];
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headV.frame) + 12, 10, 200, 30)];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"selected_no"] forState:UIControlStateNormal];
    [self addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.width.and.height.equalTo(@50);
    }];
    
}
@end
