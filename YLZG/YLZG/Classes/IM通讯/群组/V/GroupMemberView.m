//
//  GroupMemberView.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupMemberView.h"
#import "GroupMemberCollectionCell.h"
#import "IviteGroupersCollectionCell.h"


static NSInteger const cols = 4;
static CGFloat const margin = 2;

@interface GroupMemberView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UIImageView *xian;

@end

@implementation GroupMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        self.xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
        self.xian.frame = CGRectMake(0, self.height - 2, self.width, 2);
        [self addSubview:self.xian];
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
    return self.memberArr.count + 2;
}


#pragma mark 每个UICollectionViewCell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item <= self.memberArr.count - 1) {
        GroupMemberCollectionCell *cell = [GroupMemberCollectionCell sharedGroupMemberCell:collectionView IndexPath:indexPath];
        ContactersModel  *model = self.memberArr[indexPath.item];
        cell.model = model;
        return cell;
    } else if(indexPath.item <= self.memberArr.count){ // add_members、delete_members
        IviteGroupersCollectionCell *cell = [IviteGroupersCollectionCell sharedIvitGroupMemCell:collectionView IndexPath:indexPath];
        [cell.imageV setImage:[UIImage imageNamed:@"add_members"]];
        return cell;
    }else{
        // 踢出
        IviteGroupersCollectionCell *cell = [IviteGroupersCollectionCell sharedIvitGroupMemCell:collectionView IndexPath:indexPath];
        [cell.imageV setImage:[UIImage imageNamed:@"delete_members"]];
        return cell;
    }
    
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
    if (memberArr.count + 2 <= 4) {
        self.height = cellW + 2;
    }else{
        self.height = cellW * 2 + 3;
    }
    self.xian.frame = CGRectMake(0, self.height - 2, self.width, 2);
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height - 2) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //让collectionView滚动
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerClass:[GroupMemberCollectionCell class] forCellWithReuseIdentifier:@"GroupMemberCollectionCell"];
        [_collectionView registerClass:[IviteGroupersCollectionCell class] forCellWithReuseIdentifier:@"IviteGroupersCollectionCell"];
        
    }
    
    return _collectionView;
    
}


@end
