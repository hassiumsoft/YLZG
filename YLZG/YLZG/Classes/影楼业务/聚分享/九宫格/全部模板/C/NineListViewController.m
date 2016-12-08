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
#import "NineDetialViewController.h"
#import "NineHotCommentModel.h"
#import "QZConditionFilterView.h"
#import "MobanListCollectionCell.h"
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
#import "MobanCateListModel.h"


#define TopHeight 44

@interface NineListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    int currentPage;
    
    // *存储* 网络请求url中的筛选项 数据来源：View中_dataSource1或者一开始手动的初值
    NSArray *_selectedDataSource1Ary;
    NSArray *_selectedDataSource2Ary;
    
    QZConditionFilterView *_headView;
}

/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;



@end


@implementation NineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"模板列表";
    currentPage = 1;
    [self setupSubViews];
}

/**
 获取分类模板数据

 @param ccccPage 当前分页
 @param num 每页多少数据
 */
- (void)getDataWithPage:(int)ccccPage Nums:(int)num
{
    
    NSString *url = [NSString stringWithFormat:NineCategory_Url,[ZCAccountTool account].userID,self.cateModel.id,ccccPage,num];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int sumPage = [[[responseObject objectForKey:@"page"] description] intValue];
        if (code == 1) {
            
            
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArr = [MobanCateListModel mj_objectArrayWithKeyValuesArray:result];
            [self.array addObjectsFromArray:modelArr];
            [self.collectionView reloadData];
            currentPage++;
            
            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self getDataWithPage:currentPage Nums:10];
            }];
            
            if (ccccPage >= sumPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
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
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithPage:currentPage Nums:10];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    
    /******* 加载筛选条件的视图 ********/
    
    if (self.isSuaixuan) {
        // 设置初次加载显示的默认数据
        _selectedDataSource1Ary = @[self.cateModel];
        _selectedDataSource2Ary = @[@"默认排序"];
        
        _headView = [QZConditionFilterView conditionFilterViewWithFilterBlock:^(BOOL isFilter, NSArray *dataSource1Ary, NSArray *dataSource2Ary) {
            if (isFilter) {
                //网络加载请求 存储请求参数
                _selectedDataSource1Ary = dataSource1Ary;
                _selectedDataSource2Ary = dataSource2Ary;
                currentPage = 1;
                [self.array removeAllObjects];
                self.cateModel = [dataSource1Ary firstObject];
                [self.collectionView.mj_header beginRefreshing];
                
            }else{
                // 不是筛选，全部赋初值（在这个工程其实是没用的，因为tableView是选中后必选的，即一旦选中就没有空的情况，但是如果可以清空筛选条件的时候就有必要 *重新* reset data）
                _selectedDataSource1Ary = @[self.cateModel];
                _selectedDataSource2Ary = @[@"默认排序"];
            }
            [self startRequest];
        }];
        // 传入数据源，对应2个tableView顺序
        _headView.dataAry1 = self.cateModelArray;
        _headView.dataAry2 = @[@"默认排序"];
        
        // 初次设置默认显示数据，内部会调用block 进行第一次数据加载
        [_headView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary];
        
        [self.view addSubview:_headView];
    }
}

- (void)startRequest
{
    NSString *source1 = [NSString stringWithFormat:@"%@",_selectedDataSource1Ary.firstObject];
    NSString *source2 = [NSString stringWithFormat:@"%@",_selectedDataSource2Ary.firstObject];
    NSDictionary *dic = [_headView keyValueDic];
    // 可以用字符串在dic换成对应英文key
    NSLog(@"dic = %@",dic);
    NSLog(@"条件一：%@，条件二：%@",source1,source2);

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
        CGRect frame;
        if (self.isSuaixuan) {
            frame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight - 64);
        }else{
            frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_headView dismiss];
}

@end
