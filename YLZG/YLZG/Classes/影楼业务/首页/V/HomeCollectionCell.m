//
//  HomeCollectionCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeCollectionCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>



@interface HomeCollectionCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *imageView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation HomeCollectionCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HomeCollectionCell";
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[HomeCollectionCell alloc]init];
    }
    return cell;
}
- (void)setModel:(ButtonIconModel *)model
{
    _model = model;
    if (model.fromType == FromLocal) {
        _imageView.image = [UIImage imageNamed:model.ico];
        _titleLabel.text = model.name;
    }else if(model.fromType == FromWebSite){
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.ico] placeholderImage:[UIImage imageNamed:@"btn_ico_jizan"]];
        _titleLabel.text = model.name;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}



- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]initWithImage:nil];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-7);
        make.width.and.height.equalTo(@(30*CKproportion));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.height.equalTo(@21);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

@end
