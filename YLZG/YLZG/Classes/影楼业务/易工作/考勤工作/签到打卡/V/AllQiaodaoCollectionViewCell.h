//
//  AllQiaodaoCollectionViewCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllQiandaoModel.h"

@interface AllQiaodaoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AllQiandaoModel * model;
// 头像
@property (nonatomic, strong) UIImageView * headImageV;
// 真实姓名
@property (nonatomic, strong) UILabel * realnameLabel;
// 签到的图片
@property (nonatomic, strong) UIImageView * qiandaoV;

//+ (instancetype)sharedAllQiaodaoCollectionViewCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath;

@end
