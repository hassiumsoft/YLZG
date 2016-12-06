//
//  HomeCollectionCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonIconModel.h"


@interface HomeCollectionCell : UICollectionViewCell


/** 首页的icon模型 */
@property (strong,nonatomic) ButtonIconModel *iconModel;
/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
