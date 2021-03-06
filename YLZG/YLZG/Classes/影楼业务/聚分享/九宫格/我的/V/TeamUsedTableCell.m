//
//  TeamUsedTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TeamUsedTableCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface TeamUsedTableCell ()

/** 模板塑料图 */
@property (strong,nonatomic) UIImageView *mobanImageV;
/** 模板名称 */
@property (strong,nonatomic) UILabel *mobanNameL;
/** 是否必发提醒 */
@property (strong,nonatomic) UIImageView *bifaImageV;
/** 本人是否已经使用 */
@property (strong,nonatomic) UIImageView *isUsedImageV;
/** 转发次数 */
@property (strong,nonatomic) UILabel *resendLabel;
//* 转发时间 
//@property (strong,nonatomic) UILabel *timeLabel;

@end


@implementation TeamUsedTableCell

+ (instancetype)sharedTeamUsedTableCell:(UITableView *)tableView
{
    static NSString *ID = @"TeamUsedTableCell";
    TeamUsedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TeamUsedTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setTeamUsedModel:(TeamUsedModel *)teamUsedModel
{
    _teamUsedModel = teamUsedModel;
    [_mobanImageV sd_setImageWithURL:[NSURL URLWithString:teamUsedModel.thumb] placeholderImage:[self imageWithBgColor:HWRandomColor]];
    _mobanNameL.text = teamUsedModel.name;
    if (teamUsedModel.mind) {
        _bifaImageV.image = [UIImage imageNamed:@"ico_betfair_red"];
    }else{
        _bifaImageV.image = [UIImage imageNamed:@"ico_betfair"];
    }
    if (teamUsedModel.useis) {
        _isUsedImageV.image = [UIImage imageNamed:@"ico_hasbeenused"];
    }else{
        _isUsedImageV.image = [UIImage imageNamed:@"nine_unused"];
    }
    _resendLabel.text = [NSString stringWithFormat:@"已被转发%@次",teamUsedModel.times];
}

- (void)setMyMobanModel:(MyMobanModel *)myMobanModel
{
    _myMobanModel = myMobanModel;
    [_mobanImageV sd_setImageWithURL:[NSURL URLWithString:myMobanModel.thumb] placeholderImage:[self imageWithBgColor:HWRandomColor]];
    _mobanNameL.text = myMobanModel.name;
    _bifaImageV.hidden = YES;
    if (myMobanModel.useis) {
        _isUsedImageV.image = [UIImage imageNamed:@"ico_hasbeenused"];
    }else{
        _isUsedImageV.image = [UIImage imageNamed:@"nine_unused"];
    }
    _resendLabel.text = [NSString stringWithFormat:@"已被转发%@次",myMobanModel.times];
}

- (void)setMyUsedModel:(MyUsedModel *)myUsedModel
{
    _myUsedModel = myUsedModel;
    [_mobanImageV sd_setImageWithURL:[NSURL URLWithString:myUsedModel.thumb] placeholderImage:[self imageWithBgColor:HWRandomColor]];
    _mobanNameL.text = myUsedModel.name;
    
    _resendLabel.text = [self TimeIntToDateStr:myUsedModel.create_at];
    _bifaImageV.hidden = YES;
    _isUsedImageV.hidden = YES;
    
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
    // 模板图
    self.mobanImageV = [[UIImageView alloc]initWithImage:[self imageWithBgColor:HWRandomColor]];
    self.mobanImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.mobanImageV];
    [self.mobanImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@(63));
    }];
    
    
    // 必发提醒
    self.bifaImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_betfair"]];
    self.bifaImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.bifaImageV];
    [self.bifaImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@45);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    // 模板名称
    self.mobanNameL = [[UILabel alloc]init];
    self.mobanNameL.font = [UIFont systemFontOfSize:14];
    self.mobanNameL.numberOfLines = 2;
    [self.contentView addSubview:self.mobanNameL];
    [self.mobanNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mobanImageV.mas_right).offset(4);
        make.height.equalTo(@42);
    }];
    
    // 我已使用
    self.isUsedImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:self.isUsedImageV];
    [self.isUsedImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    // 转发次数
    self.resendLabel = [[UILabel alloc]init];
    self.resendLabel.font = [UIFont systemFontOfSize:14];
    self.resendLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.resendLabel];
    [self.resendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@21);
    }];
    
    
}

@end
