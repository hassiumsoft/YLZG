//
//  WSImageBroswerVC.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WSImageBroswerVC.h"
#import "WSImageBroserCell.h"

@interface WSImageBroswerVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation WSImageBroswerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    [self initializeData];
}

- (void)initializeView {
    
    self.view.backgroundColor = [UIColor blackColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[WSImageBroserCell class] forCellWithReuseIdentifier:NSStringFromClass([WSImageBroserCell class])];
}

- (void)initializeData {
    [self.collectionView reloadData];
    if(_showIndex > 0 && _showIndex < _imageArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(_showIndex*self.collectionView.frame.size.width, 0) animated:NO];
        });
    }
    else {
        [self refreshTitle];
    }
}

- (void)refreshTitle {
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
    _showIndex = index;
    index += 1;
    if(index >= 0 && index <= _imageArray.count) {
        self.title = [NSString stringWithFormat:@"%@/%@",@(index),@(_imageArray.count)];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSImageBroserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WSImageBroserCell class]) forIndexPath:indexPath];
    if(indexPath.row < _imageArray.count) {
        cell.model = _imageArray[indexPath.row];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshTitle];
}


@end
