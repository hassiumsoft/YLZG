//
//  ApplyTableViewCell.m
//  YLZG
//
//  Created by 周聪 on 16/9/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ApplyTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@implementation ApplyTableViewCell

+ (instancetype)sharedAddFriendTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"ApplyTableViewCell";
    ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[ApplyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setAModel:(ApplyModel *)aModel
{
    _aModel = aModel;
    NSString *head = aModel.fead;
//    NSString *placeImage;
//    if ([contactModel.gender intValue] == 1) {
//        placeImage = @"user_place";
//    }else{
//        placeImage = @"male_place";
//    }
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    if (aModel.anick.length < 1) {
        if (aModel.aname.length < 1) {
            _nickNameLabel.text = aModel.anick;
        }else{
            _nickNameLabel.text = aModel.aname;
        }
    }else{
        _nickNameLabel.text = aModel.anick;
    }
    if (aModel.amessage == NULL) {
        _messageNameLabel.text = [NSString stringWithFormat:@"信息:我是%@",aModel.anick];
    }else{
        _messageNameLabel.text = [NSString stringWithFormat:@"信息:%@",aModel.amessage];
    }
}
- (void)setupSubViews
{
    // 头像
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    // 信息
    self.messageNameLabel = [[UILabel alloc]init];
    self.messageNameLabel.font = [UIFont systemFontOfSize:15];
    self.messageNameLabel.textColor = [UIColor grayColor];
    [self addSubview:self.messageNameLabel];
    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(12);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    // 昵称
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.font = [UIFont systemFontOfSize:18];
    self.nickNameLabel.text = @"速度达";
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(12);
        make.height.equalTo(@25);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    
    // 线
    self.xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:self.xian];
    [self.xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.backgroundColor = MainColor;
    agreeBtn.tag = AGREE_BUTTON;
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.layer.masksToBounds =YES;
    agreeBtn.layer.cornerRadius = 6.f;
    agreeBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    refuseBtn.backgroundColor = WechatRedColor;
    refuseBtn.tag = UNAGREE_BUTTON;
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refuseBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    refuseBtn.layer.masksToBounds =YES;
    refuseBtn.layer.cornerRadius = 6.f;
    refuseBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:refuseBtn];
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-70);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
}
- (void)agreeBtnClick:(UIButton *)button {
    // 如果有block值，则从block获取值
    if (self.agreeBtn) {
        self.agreeBtn(button.tag);
    }
}
@end
