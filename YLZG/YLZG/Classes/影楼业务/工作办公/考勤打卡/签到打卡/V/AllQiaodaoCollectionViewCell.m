//
//  AllQiaodaoCollectionViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AllQiaodaoCollectionViewCell.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"

@implementation AllQiaodaoCollectionViewCell

//+ (instancetype)sharedAllQiaodaoCollectionViewCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath {
//    static NSString * ID = @"AllQiaodaoCollectionViewCell";
//    AllQiaodaoCollectionViewCell * cell = [collectionV dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    if (!cell) {
//       [collectionV registerClass:[AllQiaodaoCollectionViewCell class] forCellWithReuseIdentifier:@"aCell"];
//    }
//    return cell;
//}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createCell];
    }
    return self;
}

- (void)setModel:(AllQiandaoModel *)model {
    _model = model;
    _realnameLabel.text = model.realname;
    
    if ([[model.times description] intValue] == 0) {
        [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _qiandaoV.image = [UIImage imageNamed:@""];
    }else {
        [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _qiandaoV.image = [UIImage imageNamed:@"approve_hint"];
    }
}

- (void)createCell {
    _headImageV = [[UIImageView alloc] init];
    _headImageV.layer.masksToBounds = YES;
    _headImageV.layer.cornerRadius = 30;
    [self.contentView addSubview:_headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).equalTo(@-10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    _realnameLabel = [[UILabel alloc] init];
    _realnameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_realnameLabel];
    [self.realnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.headImageV.mas_bottom).equalTo(@5);
        make.height.equalTo(@20);
    }];
    
    _qiandaoV = [[UIImageView alloc] init];
    _qiandaoV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_qiandaoV];
    [_qiandaoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).equalTo(@-10);
        make.bottom.equalTo(self.contentView.mas_bottom).equalTo(@-35);
        make.width.equalTo(@23);
        make.height.equalTo(@23);
    }];
}

@end
