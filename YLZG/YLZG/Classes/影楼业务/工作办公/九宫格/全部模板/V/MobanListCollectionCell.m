//
//  MobanListCollectionCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MobanListCollectionCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface MobanListCollectionCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation MobanListCollectionCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MobanListCollectionCell";
    MobanListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[MobanListCollectionCell alloc]init];
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

- (void)setModel:(NineHotCommentModel *)model
{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"nine_place"]];
}

- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nine_place"]];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setFrame:self.contentView.bounds];
    [self addSubview:self.imageView];

}


@end
