//
//  IviteGroupersCollectionCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IviteGroupersCollectionCell.h"
#import <Masonry.h>

@implementation IviteGroupersCollectionCell

+ (instancetype)sharedIvitGroupMemCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"IviteGroupersCollectionCell";
    IviteGroupersCollectionCell *cell = [collectionV dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[IviteGroupersCollectionCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.and.height.equalTo(@(self.width * 0.6));
        }];
    }
    return self;
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}

@end
