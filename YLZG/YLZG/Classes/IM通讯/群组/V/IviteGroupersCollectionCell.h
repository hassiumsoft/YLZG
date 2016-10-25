//
//  IviteGroupersCollectionCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IviteGroupersCollectionCell : UICollectionViewCell


@property (strong,nonatomic) UIImageView *imageV;

+ (instancetype)sharedIvitGroupMemCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath;

@end
