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
#import "UserInfoManager.h"
#import "NineSearchResultController.h"
#import "NineListViewController.h"
#import "NineTopViewReusableView.h"
#import "MobanListCollectionCell.h"
#import "NineDetialViewController.h"
#import "ZCAccountTool.h"


#define topViewH 160*CKproportion

@interface NineAllMobanViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>


/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 搜索框 */
@property (strong,nonatomic) UISearchBar *searBar;


@end

@implementation NineAllMobanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素材市场";
    [self getData];
}

- (void)setupSubViews
{
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    
    [self.view addSubview:self.searBar];
}
- (UISearchBar *)searBar
{
    if (!_searBar) {
        _searBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searBar.delegate = self;
        _searBar.returnKeyType = UIReturnKeySearch;
        _searBar.searchBarStyle = UISearchBarStyleMinimal;
        _searBar.placeholder = @"模板关键字";
    }
    return _searBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.view endEditing:YES];
    if (searchBar.text.length < 1) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:NineSearch_Url,[ZCAccountTool account].userID,searchBar.text];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArr = [NineHotCommentModel mj_objectArrayWithKeyValuesArray:result];
                NineSearchResultController *nineSearch = [NineSearchResultController new];
                nineSearch.array = modelArr;
                [self.navigationController pushViewController:nineSearch animated:YES];
            }else{
                [self showErrorTips:@"没有相关模板"];
            }
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)getData
{
    NSString *url = [NSString stringWithFormat:NineList_Url,[ZCAccountTool account].userID];
    [self showHudMessage:@"加载中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self hideHud:0];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.listModel = [MobanListModel mj_objectWithKeyValues:result];
            
            [self setupSubViews];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.listModel.hot.count;
    }else{
        return self.listModel.commend.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 热门模板
        MobanListCollectionCell *cell = [MobanListCollectionCell sharedCell:collectionView Path:indexPath];
        cell.model = self.listModel.hot[indexPath.row];
        return cell;
    }else{
        // 推荐模板
        MobanListCollectionCell *cell = [MobanListCollectionCell sharedCell:collectionView Path:indexPath];
        cell.model = self.listModel.commend[indexPath.row];
        return cell;
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 热门模板
        NineDetialViewController *nine = [NineDetialViewController new];
        NineHotCommentModel *model = self.listModel.hot[indexPath.row];
        nine.isManager = [[[UserInfoManager sharedManager] getUserInfo].type intValue] ? YES : NO;
        nine.date = [self getCurrentTime];
        nine.mobanID = model.id;
        nine.title = model.name;
        [self.navigationController pushViewController:nine animated:YES];
        
        
    }else{
        // 推荐模板
        NineDetialViewController *nine = [NineDetialViewController new];
        NineHotCommentModel *model = self.listModel.commend[indexPath.row];
        nine.isManager = [[[UserInfoManager sharedManager] getUserInfo].type intValue] ? YES : NO;
        nine.date = [self getCurrentTime];
        nine.mobanID = model.id;
        nine.title = model.name;
        [self.navigationController pushViewController:nine animated:YES];
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
    return CGSizeMake((SCREEN_WIDTH-4)/3, (SCREEN_WIDTH-4)/3 + 30);
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
            headerview.titleArray = self.listModel.category;
            headerview.CategoryClick = ^(NineCategoryModel *cateModel){
                NineListViewController *nineList = [NineListViewController new];
                nineList.isSuaixuan = YES;
                nineList.title = @"模板列表";
                nineList.cateModelArray = self.listModel.category;
                nineList.cateModel = cateModel;
                [self.navigationController pushViewController:nineList animated:YES];
            };
            headerview.DidClickBlock = ^(){
                NineListViewController *nineList = [[NineListViewController alloc]init];
                NineCategoryModel *model = [NineCategoryModel new];
                model.id = @"hot";
                model.name = @"热门模板";
                nineList.cateModel = model;
                nineList.title = @"热门模板";
                [self.navigationController pushViewController:nineList animated:YES];
            };
            reusableview = headerview;
        }else{
            NineReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineReusableView" forIndexPath:indexPath];
            headerview.title = titleArr[indexPath.section];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                NineListViewController *nineList = [[NineListViewController alloc]init];
                nineList.isSuaixuan = NO;
                NineCategoryModel *model = [NineCategoryModel new];
                model.id = @"commend";
                model.name = @"推荐模板";
                nineList.title = @"推荐模板";
                nineList.cateModel = model;
                [self.navigationController pushViewController:nineList animated:YES];
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 44) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[MobanListCollectionCell class] forCellWithReuseIdentifier:@"MobanListCollectionCell"];
        
        
        [_collectionView registerClass:[NineTopViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineTopViewReusableView"];
        [_collectionView registerClass:[NineReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineReusableView"];
    }
    return _collectionView;
}



@end
