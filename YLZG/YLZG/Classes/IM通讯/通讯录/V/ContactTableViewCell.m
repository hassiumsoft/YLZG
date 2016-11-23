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
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        make.width.and.height.equalTo(@35);
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
    
    // 线
    self.xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:self.xian];
    [self.xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
}
@end
