//
//  NineListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineListViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HTTPManager.h"
#import "MobanHeadView.h"
#import "HomeCollectionCell.h"
#import "ZCAccountTool.h"


#define TopHeight 50

@interface NineListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 头部 */

@end


@implementation NineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板列表";
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
    
    
    MobanHeadView *headView = [[MobanHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopHeight)];
    [self.view addSubview:headView];
}


#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
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
    return CGSizeMake((SCREEN_WIDTH-4)/3, (SCREEN_WIDTH-4)/3);
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
#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight - 64) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
    }
    return _collectionView;
}


@end
