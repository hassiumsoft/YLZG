//
//  HomeViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeViewController.h"
#import "UserInfoManager.h"
#import "HomeCollectionCell.h"
#import "ButtonIconModel.h"
#import "HomeHeadView.h"
#import <MJExtension/MJExtension.h>
#import "OpenOrderViewController.h"
#import "SearchOrderViewController.h"
#import "PreOrderVController.h"
#import "MonthFinanceVController.h"
#import "MonthFinanceVController.h"
#import "TodayFinanceController.h"
#import "TodayOrderViewController.h"
#import "MoreToolsViewController.h"
#import "OrderCheckViewController.h"
#import "MyJobsViewController.h"
#import "EWorkViewController.h"
#import "YejiViewController.h"
#import "ShekongBenController.h"







static CGFloat topViewH = 100;
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 头部 */
@property (strong,nonatomic) HomeHeadView *headView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"掌上影楼";
    [self setupSubViews];
}
#pragma mark - 创建UI
- (void)setupSubViews
{
    
    UserInfoModel *model = [UserInfoManager getUserInfo];
    if ([model.type intValue] == 1) {
        // 今日财务、财务统计、今日订单、我的工作；易工作、摄控本、订单收款、业绩榜；更多工具
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
        // 今日订单、我的工作；易工作、摄控本、订单收款、业绩榜；更多工具
        NSArray *titleArr = @[@"今日订单",@"我的工作",@"易工作",@"摄控本",@"订单收款",@"业绩榜",@"更多工具",@""];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < titleArr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"icon"] = [NSString stringWithFormat:@"home_amin_%d",i + 2];
            dict[@"title"] = titleArr[i];
            [tempArr addObject:dict];
        }
        
        self.array = [ButtonIconModel mj_objectArrayWithKeyValuesArray:tempArr];
        
    }
    
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.headView = [[HomeHeadView alloc]initWithFrame:CGRectMake(0, -topViewH, SCREEN_WIDTH, topViewH)];
    __weak __block HomeViewController *copy_self = self;
    self.headView.ButtonClickBlock = ^(ClickType type){
        switch (type) {
            case OpenOrderClick:
            {
                // 开单
                OpenOrderViewController *openOrder = [OpenOrderViewController new];
                [copy_self.navigationController pushViewController:openOrder animated:YES];
                break;
            }
            case SearchClick:
            {
                // 查询
                SearchOrderViewController *searchOrder = [SearchOrderViewController new];
                [copy_self.navigationController pushViewController:searchOrder animated:YES];
                break;
            }
            case PreOrderClick:
            {
                // 预约
                PreOrderVController *preOrder = [PreOrderVController new];
                [copy_self.navigationController pushViewController:preOrder animated:YES];
                break;
            }
            default:
                break;
        }
    };
    [self.collectionView insertSubview:self.headView atIndex:0];
    
}

#pragma mark - UICollectionView
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 46) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
        
        _collectionView.contentInset = UIEdgeInsetsMake(topViewH, 0, 0, 0);
        
        
    }
    
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
    UserInfoModel *model = [UserInfoManager getUserInfo];
    if ([model.type intValue] == 1) {
        // 店长
        if (indexPath.row == 0) {
            // 今日财务
            TodayFinanceController *ppp = [TodayFinanceController new];
            [self.navigationController pushViewController:ppp animated:YES];
        } else if(indexPath.row == 1){
            // 财务统计
            MonthFinanceVController *ppp = [MonthFinanceVController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 2){
            // 今日订单
            TodayOrderViewController *ppp = [TodayOrderViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 3){
            // 我的工作
            MyJobsViewController *ppp = [MyJobsViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 4){
            // 易工作
            EWorkViewController *ppp = [EWorkViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 5){
            // 摄控本
            ShekongBenController *ppp = [ShekongBenController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 6){
            // 订单收款
            OrderCheckViewController *ppp = [OrderCheckViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 7){
            // 业绩榜
            YejiViewController *ppp = [YejiViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if(indexPath.row == 8){
            // 更多工具
            MoreToolsViewController *ppp = [MoreToolsViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }
    }else{
        // 员工
        if (indexPath.row == 0) {
            // 今日订单
            TodayOrderViewController *ppp = [TodayOrderViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 1){
            // 我的工作
            MyJobsViewController *ppp = [MyJobsViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 2){
            // 易工作
            EWorkViewController *ppp = [EWorkViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 3){
            // 摄控本
            ShekongBenController *ppp = [ShekongBenController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 4){
            // 订单收款
            OrderCheckViewController *ppp = [OrderCheckViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if (indexPath.row == 5){
            // 业绩榜
            YejiViewController *ppp = [YejiViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }else if(indexPath.row == 6){
            // 更多工具
            MoreToolsViewController *ppp = [MoreToolsViewController new];
            [self.navigationController pushViewController:ppp animated:YES];
        }
    }
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
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

@end
