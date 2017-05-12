//
//  GroupTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupTableViewCell.h"
#import <Masonry.h>
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import "ImageBrowser.h"


@interface GroupTableViewCell ()

/** 群组头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 群名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 群人数 */
@property (strong,nonatomic) UILabel *memberNumLabel;

@end

@implementation GroupTableViewCell

+ (instancetype)sharedGroupTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"GroupTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(YLGroup *)model
{
    _model = model;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:@"group_add_icon"]];
    _nameLabel.text = model.gname;
    _memberNumLabel.text = [NSString stringWithFormat:@"(%@人)",model.affiliations];
}

- (void)setupSubViews
{
    // 群头像
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 44, 44)];
    [self.contentView addSubview:self.headImgView];
    
    // 群昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.height.equalTo(@30);
    }];
    // 群人数
    self.memberNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.memberNumLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.memberNumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.memberNumLabel];
    [self.memberNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.equalTo(@30);
    }];
    
}
@end
