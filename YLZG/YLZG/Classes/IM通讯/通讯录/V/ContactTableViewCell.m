//
//  ContactTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/6.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "ContactTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>



@implementation ContactTableViewCell

+ (instancetype)sharedContactTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
- (void)setContactModel:(ContactersModel *)contactModel
{
    _contactModel = contactModel;
    NSString *head = contactModel.head;
    NSString *placeImage = @"user_place";
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:placeImage]];
    
    _nickNameLabel.text = contactModel.nickname.length >= 1 ? contactModel.nickname : contactModel.realname;
    
}

- (void)setupSubViews
{
    // 头像
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 2;
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@44);
    }];
    // 昵称
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nickNameLabel.text = @"速度达";
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(12);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.contentView addSubview:self.addFriendLabel];
   
}

- (UILabel *)addFriendLabel
{
    if (!_addFriendLabel) {
        _addFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 20, 20, 20)];
        _addFriendLabel.textColor = [UIColor whiteColor];
        _addFriendLabel.backgroundColor = WechatRedColor;
        _addFriendLabel.textAlignment = NSTextAlignmentCenter;
        _addFriendLabel.font = [UIFont systemFontOfSize:13];
        _addFriendLabel.layer.masksToBounds = YES;
        _addFriendLabel.layer.cornerRadius = 10;
    }
    return _addFriendLabel;
}


@end
