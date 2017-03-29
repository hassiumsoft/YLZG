//
//  TeamClassViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/3/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TeamClassViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "TeamClassModel.h"
#import <MJExtension.h>
#import "MobanListCollectionCell.h"
#import "NineDetialViewController.h"
#import "MobanCateListModel.h"
#import <MJRefresh.h>
#import "UserInfoManager.h"

@interface TeamClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 分类数组 */
@property (strong,nonatomic) NSArray *classArray;
/** 分类下的数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;


@end

@implementation TeamClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.title = @"团队制作分类";
    self.title = self.classModel.name;
    [self setupSubViews];
    
}


- (void)setupSubViews
{
    
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataTeamClassModel:self.classModel];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
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
    nine.isManager = [[[UserInfoManager sharedManager] getUserInfo].type intValue] ? YES : NO;
    nine.date = [self getCurrentTime];
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
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
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
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

/**
 获取分类模板数据
 
 
 */
- (void)getDataTeamClassModel:(TeamClassModel *)classModel
{
    
    NSString *url = [NSString stringWithFormat:NineTeamClassMobanList_Url,[ZCAccountTool account].userID,classModel.cid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArr = [MobanCateListModel mj_objectArrayWithKeyValuesArray:result];
                [self.array addObjectsFromArray:modelArr];
                [self.collectionView reloadData];
                self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [MBProgressHUD showError:@"该分类下暂无模板"];
            }
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}



@end
