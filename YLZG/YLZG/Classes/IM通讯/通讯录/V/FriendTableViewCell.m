//
//  FriendTableViewCell.m
//  YLZG
//
//  Created by 周聪 on 16/9/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation FriendTableViewCell
+ (instancetype)sharedFriendTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"FriendTableViewCell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[FriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setContactModel:(ContactersModel *)contactModel
{
    _contactModel = contactModel;
    NSString *head = contactModel.head;
    NSString *placeImage;
    if ([contactModel.gender intValue] == 1) {
        placeImage = @"user_place";
    }else{
        placeImage = @"user_place";
    }
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:placeImage]];
    if (contactModel.nickname.length < 1) {
        if (contactModel.realname.length < 1) {
            _nickNameLabel.text = contactModel.name;
        }else{
            _nickNameLabel.text = contactModel.realname;
        }
    }else{
        _nickNameLabel.text = contactModel.nickname;
    }
    self.loactionNameLabel.text = [NSString stringWithFormat:@"地址:%@",contactModel.location];
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
    // 地址
    self.loactionNameLabel = [[UILabel alloc]init];
    self.loactionNameLabel.font = [UIFont systemFontOfSize:15];
    self.loactionNameLabel.textColor = [UIColor grayColor];
    [self addSubview:self.loactionNameLabel];
    [self.loactionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:MainColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addFriendBtn) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds =YES;
    UIColor *color = [[YLZGDataManager sharedManager] isSpringFestival] ? NormalColor : SpringColor;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 1.f;
    button.layer.cornerRadius = 6.f;
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
}
- (void)addFriendBtn{
    if (self.addBtn) {
        self.addBtn();
    }
}
@end
