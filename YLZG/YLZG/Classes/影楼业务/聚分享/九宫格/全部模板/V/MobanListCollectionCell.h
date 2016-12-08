//
//  MobanListCollectionCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineHotCommentModel.h"



@interface MobanListCollectionCell : UICollectionViewCell

/** 热门/推荐模型 */
@property (strong,nonatomic) NineHotCommentModel *model;

/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
