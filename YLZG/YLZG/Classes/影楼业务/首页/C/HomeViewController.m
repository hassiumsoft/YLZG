//
//  HomeViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeReusableView.h"
#import "HomeCollectionCell.h"
#import "UserInfoManager.h"
#import "HomeHeadView.h"
#import <MJExtension.h>



#define topViewH 180
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 顶部的视图 */
@property (strong,nonatomic) HomeHeadView *topView;
/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"掌上影楼";
    self.view.backgroundColor = KeepColor;
    [self setupSubViews];
}

#pragma mark - 创建视图UI
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.userModel = [UserInfoManager getUserInfo];
    
    if ([self.userModel.type intValue] == 1) {
        NSArray *titleArr = @[@"今日财务",@"财务统计",@"今日订单",@"我的工作",@"易工作",@"摄控本",@"订单收款",@"业绩榜",@"更多工具",@"",@"",@""];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < titleArr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"icon"] = [NSString stringWithFormat:@"home_amin_%d",i];
            dict[@"title"] = titleArr[i];
            [tempArr addObject:dict];
        }
        self.array = [ButtonIconModel mj_objectArrayWithKeyValuesArray:tempArr];
    }else{
        
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView insertSubview:self.topView atIndex:0];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.userModel.type intValue] == 1) {
        return 4;
    }else{
        return 3;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [HomeCollectionCell sharedCell:collectionView Path:indexPath];
    ButtonIconModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    KGLog(@"--%g--",SCREEN_WIDTH); // 6P：414   6：375  5S：320 4S：320
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
        
        if (indexPath.section == 0) {
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            reusableview = headerview;
        } else if(indexPath.section == 1){
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            reusableview = headerview;
        }else if (indexPath.section == 2){
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            reusableview = headerview;
        }else{
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            reusableview = headerview;
        }
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 30);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -21, SCREEN_WIDTH, SCREEN_HEIGHT - 25) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
        
        _collectionView.contentInset = UIEdgeInsetsMake(topViewH, 0, 0, 0);
        [_collectionView registerClass:[HomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView"];
    }
    return _collectionView;
}
- (HomeHeadView *)topView
{
    if (!_topView) {
        _topView = [[HomeHeadView alloc]initWithFrame:CGRectMake(0, -topViewH, SCREEN_WIDTH, topViewH)];
    }
    return _topView;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
