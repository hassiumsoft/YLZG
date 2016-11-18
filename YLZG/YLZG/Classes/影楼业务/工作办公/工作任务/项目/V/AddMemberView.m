//
//  AddMemberView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddMemberView.h"
#import "GroupMemberCollectionCell.h"


static NSInteger const cols = 4;
static CGFloat const margin = 2;

@interface AddMemberView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *collectionView;

@end


@implementation AddMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memberArr.count;
}


#pragma mark 每个UICollectionViewCell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GroupMemberCollectionCell *cell = [GroupMemberCollectionCell sharedGroupMemberCell:collectionView IndexPath:indexPath];
    ContactersModel  *model = self.memberArr[indexPath.item];
    cell.model = model;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_DidSelectBlock) {
        _DidSelectBlock(indexPath);
    }
}
- (void)setMemberArr:(NSArray *)memberArr
{
    _memberArr = memberArr;
    CGFloat cellW = (SCREEN_WIDTH - 3 * margin)/cols;
    self.height = cellW * 2 + 3;
}
- (void)reloadData
{
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    CGFloat cellW = (SCREEN_WIDTH - 3 * margin)/cols;
    CGFloat cellH = cellW;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(cellW,cellH);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //让collectionView滚动
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerClass:[GroupMemberCollectionCell class] forCellWithReuseIdentifier:@"GroupMemberCollectionCell"];
        
        
    }
    
    return _collectionView;
    
}


@end
