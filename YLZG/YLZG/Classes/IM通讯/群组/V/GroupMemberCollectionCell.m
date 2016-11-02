//
//  GroupMemberCollectionCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupMemberCollectionCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation GroupMemberCollectionCell

+ (instancetype)sharedGroupMemberCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"GroupMemberCollectionCell";
    GroupMemberCollectionCell *cell = [collectionV dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[GroupMemberCollectionCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(ContactersModel *)model
{
    _model = model;
    _nameLabel.text = model.realname.length > 0 ? model.realname : model.name;
    if ([model.gender intValue] == 1) {
        [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    }else{
        [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    }
}
- (void)setupSubViews
{
    CGFloat cellWH = (SCREEN_WIDTH - 3 * 2)/4; // cell的宽
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 5;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(cellWH * 0.77));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
@end
