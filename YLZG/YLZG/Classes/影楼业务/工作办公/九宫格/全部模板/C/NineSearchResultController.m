//
//  NineSearchResultController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineSearchResultController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
#import "NineDetialViewController.h"
#import "MobanListCollectionCell.h"
#import "NineHotCommentModel.h"



#define TopHeight 44

@interface NineSearchResultController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UISearchBar *searchBar;


@end

@implementation NineSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板搜索";
    [self setupSubViews];
    
}
- (void)getData
{
    
    NSString *url = [NSString stringWithFormat:NineSearch_Url,[ZCAccountTool account].userID,self.searchBar.text];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            
            NSArray *result = [responseObject objectForKey:@"result"];
            self.array = [NineHotCommentModel mj_objectArrayWithKeyValuesArray:result];
            [self.collectionView reloadData];
            
            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
            }];
            
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)setupSubViews
{
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.searchBar];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"模板关键字";
    }
    return _searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    if (searchBar.text.length < 1) {
        return;
    }
    
    [self getData];
}

#pragma mark - 表格相关
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
    MobanListCollectionCell *cell = [MobanListCollectionCell sharedCell:collectionView Path:indexPath];
    cell.model = self.array[indexPath.row];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NineHotCommentModel *model = self.array[indexPath.row];
    NineDetialViewController *nine = [NineDetialViewController new];
    nine.isManager = [[UserInfoManager getUserInfo].type intValue] ? YES : NO;
    nine.mobanID = model.id;
    nine.title = model.name;
    [self.navigationController pushViewController:nine animated:YES];
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
#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        CGRect frame;
        frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[MobanListCollectionCell class] forCellWithReuseIdentifier:@"MobanListCollectionCell"];
    }
    return _collectionView;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

@end
