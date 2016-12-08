//
//  WSImageBroswerVC.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "WSImageModel.h"


@interface WSImageBroswerVC : SuperViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<WSImageModel *>* imageArray;
@property (nonatomic, assign) NSInteger showIndex;

- (void)initializeView;
- (void)initializeData;
- (void)refreshTitle;


@end
