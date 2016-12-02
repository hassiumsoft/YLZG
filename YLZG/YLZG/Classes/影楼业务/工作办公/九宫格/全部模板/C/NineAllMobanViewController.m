//
//  NineAllMobanViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineAllMobanViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NineReusableView.h"
#import "HTTPManager.h"
#import "NineTopViewReusableView.h"
#import "HomeCollectionCell.h"
#import "ZCAccountTool.h"


#define topViewH 160*CKproportion

@interface NineAllMobanViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;


@end

@implementation NineAllMobanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    
    
}


#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [HomeCollectionCell sharedCell:collectionView Path:indexPath];
    cell.backgroundColor = HWRandomColor;
    return cell;

}
// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-5)/4, (SCREEN_WIDTH-5)/4);
}

// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

// 定义每个UICollectionView 纵向的间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        
        NSArray *titleArr = @[@"热门模板",@"推荐模板"];
        if (indexPath.section == 0) {
            // 顶部视图
            NineTopViewReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineTopViewReusableView" forIndexPath:indexPath];
            headerview.titleArray = @[@"全部",@"儿童类",@"生活类",@"季节类",@"关怀类",@"正能量",@"山水类",@"母婴类"];
            headerview.DidClickBlock = ^(){
                [self showErrorTips:@"热门模板"];
            };
            reusableview = headerview;
        }else{
            NineReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineReusableView" forIndexPath:indexPath];
            headerview.title = titleArr[indexPath.section];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                [self showErrorTips:@"推荐模板"];
            }];
            [headerview addGestureRecognizer:tap];
            reusableview = headerview;
        }
        
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, topViewH);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 44);
    }
}
#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
        
        
        [_collectionView registerClass:[NineTopViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineTopViewReusableView"];
        [_collectionView registerClass:[NineReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineReusableView"];
    }
    return _collectionView;
}



@end
