//
//  GroupMemberCollectionCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"

@interface GroupMemberCollectionCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView *headImageV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) ContactersModel *model;

+ (instancetype)sharedGroupMemberCell:(UICollectionView *)collectionV IndexPath:(NSIndexPath *)indexPath;

@end
