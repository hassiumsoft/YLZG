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
#import "NavigationView.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "YLZGDataManager.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "EmptyViewController.h"
#import "NewFutherViewController.h"


#import "OpenOrderViewController.h"
#import "SearchOrderViewController.h"
#import "PreOrderVController.h"
#import "ShekongBenController.h"
#import "OrderCheckViewController.h"
#import "YejiViewController.h"
#import "MoreToolsViewController.h"
#import "MyApproveVController.h"
#import "TodayFinanceController.h"
#import "TodayOrderViewController.h"
#import "MonthFinanceVController.h"
#import "MyJobsViewController.h"
#import "NineTabbarController.h"
#import "CheckTabBarController.h"
#import "PublicNoticeController.h"
#import "SaleToolViewController.h"
#import "TaskTabbarController.h"
#import "NineTabbarController.h"
#import "NineXuanchuanController.h"



#define topViewH 190*CKproportion

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

{
    // 悬浮导航条
    NavigationView * _suspendNav;
}


/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *titleArray;
@property (strong,nonatomic) NSMutableArray *iconArray;
@property (strong,nonatomic) NSMutableArray *idArray;
/** 顶部的视图 */
@property (strong,nonatomic) UIImageView *topView;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
@property (strong,nonatomic) UIButton *refreshButton;
/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;
/** 营销工具里是否有数据 */
@property (assign,nonatomic) BOOL isJuFenxiang;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    [self getJufenxiangInfo];
    [self showNewPages];
}

#pragma mark - 获取营销工具信息
- (void)getJufenxiangInfo
{
    self.indicatorV.hidden = NO;
    self.refreshButton.hidden = YES;
    [self.indicatorV startAnimating];
    
    NSString *url = [NSString stringWithFormat:YingxiaoToolList_URL,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        self.indicatorV.hidden = YES;
        self.refreshButton.hidden = NO;
        [self.indicatorV stopAnimating];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            NSArray *dictArr = [responseObject objectForKey:@"result"];
            if (dictArr.count >= 1) {
                
                self.isJuFenxiang = YES;
                NSArray *tempArr = [ButtonIconModel mj_objectArrayWithKeyValuesArray:dictArr];
                [self.titleArray removeLastObject];
                [self.iconArray removeLastObject];
                [self.idArray removeLastObject];
                NSMutableArray *titleArr = [NSMutableArray array];
                NSMutableArray *iconArr = [NSMutableArray array];
                NSMutableArray *idArr = [NSMutableArray array];
                for (ButtonIconModel *model in tempArr) {
                    [titleArr addObject:model.name];
                    [iconArr addObject:model.ico];
                    [idArr addObject:model.id];
                }
                [self.titleArray addObject:titleArr];
                [self.iconArray addObject:iconArr];
                [self.idArray addObject:idArr];
                
                [self.collectionView reloadData];
            }else{
                self.isJuFenxiang = NO;
            }
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        self.indicatorV.hidden = YES;
        [self.indicatorV stopAnimating];
        self.refreshButton.hidden = NO;
        
    }];
}

#pragma mark - 创建视图UI
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.userModel = [UserInfoManager getUserInfo];
    
    self.title = @"我的影楼";
    
    if ([self.userModel.type intValue] == 1) {
        // 老板

        self.titleArray = [NSMutableArray arrayWithArray:@[@[@"开单",@"查询",@"预约",@"摄控本",@"订单收款",@"业绩榜",@"我的工作",@"今日订单"],@[@"今日财务",@"财务统计"],@[@"审批",@"考勤打卡",@"工作任务",@"实用工具"],@[@"营销工具"]]];
        self.iconArray = [NSMutableArray arrayWithArray:@[@[@"btn_ico_kaidan",@"btn_ico_chaxun",@"btn_ico_yuyue",@"btn_ico_shekongben",@"btn_ico_dingdanshoukuan",@"btn_ico_yejibang",@"btn_ico_jinrigongzuo",@"btn_jinridingdan"],@[@"btn_icon_tofinace",@"btn_icon_monthfinace"],@[@"btn_ico_shenpi",@"btn_ico_kaoqin",@"task",@"btn_more"],@[@"btn_ico_kaoqin"]]];
        self.idArray = [NSMutableArray arrayWithArray:@[@[@"-1",@"-1",@"-1",@"-1",@"-1",@"-1",@"-1",@"-1"],@[@"-1",@"-1"],@[@"-1",@"-1",@"-1",@"-1"],@[@"-1"]]];
        
    }else{
        // 员工
        self.titleArray = [NSMutableArray arrayWithArray:@[@[@"开单",@"查询",@"预约",@"摄控本",@"订单收款",@"业绩榜",@"我的工作",@"今日订单"],@[@"审批",@"考勤打卡",@"工作任务",@"实用工具"],@[@"营销工具"]]];
        self.iconArray = [NSMutableArray arrayWithArray:@[@[@"btn_ico_kaidan",@"btn_ico_chaxun",@"btn_ico_yuyue",@"btn_ico_shekongben",@"btn_ico_dingdanshoukuan",@"btn_ico_yejibang",@"btn_ico_jinrigongzuo",@"btn_jinridingdan"],@[@"btn_ico_shenpi",@"btn_ico_kaoqin",@"task",@"btn_more"],@[@"btn_ico_kaoqin"]]];
        self.idArray = [NSMutableArray arrayWithArray:@[@[@"-1",@"-1",@"-1",@"-1",@"-1",@"-1",@"-1",@"-1"],@[@"-1",@"-1",@"-1",@"-1"],@[@"-1"]]];
    }
    
    [self.view addSubview:self.collectionView];
    BOOL isSpring = [[YLZGDataManager sharedManager] isSpringFestival];
    if (isSpring) {
        self.topView.image = [UIImage imageNamed:@"nian_sy_bg"];
    }else{
        self.topView.image = [UIImage imageNamed:@"sy_bg"];
    }
    [self.collectionView insertSubview:self.topView atIndex:0];
    // 悬浮栏
    _suspendNav = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _suspendNav.titleLabel.textColor = RGBACOLOR(255, 255, 255, 0);
    _suspendNav.backgroundColor = RGBACOLOR(31, 139, 229, 0);
    [self.view addSubview:_suspendNav];
    // 通知按钮
    UIButton *tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipsButton setFrame:CGRectMake(12, 25, 36, 36)];
    [tipsButton setImage:[UIImage imageNamed:@"btn_gonggao"] forState:UIControlStateNormal];
    [tipsButton addTarget:self action:@selector(GonggaoClick) forControlEvents:UIControlEventTouchUpInside];
    tipsButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsButton];
    // 刷新按钮
    
    [self.view addSubview:self.refreshButton];
    
    [self.view addSubview:self.indicatorV];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.titleArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section < self.titleArray.count - 1) {
        // 固定数据
        HomeCollectionCell *cell = [HomeCollectionCell sharedCell:collectionView Path:indexPath];
        ButtonIconModel *model = [ButtonIconModel new];
        model.name = self.titleArray[indexPath.section][indexPath.row];
        model.ico = self.iconArray[indexPath.section][indexPath.row];
        model.id = self.idArray[indexPath.section][indexPath.row];
        model.fromType = FromLocal;
        cell.iconModel = model;
        return cell;
    }else{
        // 营销工具部分<数据来源自网络>
        HomeCollectionCell *cell = [HomeCollectionCell sharedCell:collectionView Path:indexPath];
        ButtonIconModel *model = [ButtonIconModel new];
        model.name = self.titleArray[indexPath.section][indexPath.row];
        model.ico = self.iconArray[indexPath.section][indexPath.row];
        model.id = self.idArray[indexPath.section][indexPath.row];
        model.fromType = FromWebSite;
        cell.iconModel = model;
        return cell;
    }
}

// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userModel.type intValue] == 1) {
        // 老板、店长
        if (indexPath.section == 0) {
            // ERP应用
            if (indexPath.row == 0) {
                // 开单
                OpenOrderViewController *open = [OpenOrderViewController new];
                [self.navigationController pushViewController:open animated:YES];
            } else if(indexPath.row == 1){
                // 查询
                SearchOrderViewController *search = [SearchOrderViewController new];
                [self.navigationController pushViewController:search animated:YES];
                
            }else if (indexPath.row == 2){
                // 预约
                PreOrderVController *preOrder = [PreOrderVController new];
                [self.navigationController pushViewController:preOrder animated:YES];
            }else if(indexPath.row == 3){
                // 摄控本
                ShekongBenController *shekongben = [ShekongBenController new];
                [self.navigationController pushViewController:shekongben animated:YES];
            }else if (indexPath.row == 4){
                // 订单收款
                OrderCheckViewController *orderCheck = [OrderCheckViewController new];
                [self.navigationController pushViewController:orderCheck animated:YES];
            }else if(indexPath.row == 5){
                // 业绩榜
                YejiViewController *yeji = [YejiViewController new];
                [self.navigationController pushViewController:yeji animated:YES];
            }else if(indexPath.row == 6){
                // 我的工作
                MyJobsViewController *job = [MyJobsViewController new];
                [self.navigationController pushViewController:job animated:YES];
            }else if(indexPath.row == 7){
                // 今日订单
                TodayOrderViewController *today = [TodayOrderViewController new];
                [self.navigationController pushViewController:today animated:YES];
            }
        } else if(indexPath.section == 1){
            // 财务管理
            if (indexPath.row == 0) {
                // 今日财务
                TodayFinanceController *today = [TodayFinanceController new];
                [self.navigationController pushViewController:today animated:YES];
            } else {
                // 财务统计
                MonthFinanceVController *month = [MonthFinanceVController new];
                [self.navigationController pushViewController:month animated:YES];
            }
        }else if (indexPath.section == 2){
            // 工作办公
            if(indexPath.row == 0) {
                // 审批
                MyApproveVController *appear = [MyApproveVController new];
                [self.navigationController pushViewController:appear animated:YES];

            }else if(indexPath.row == 1){

                // 考勤打卡
                CheckTabBarController *kaoqin = [CheckTabBarController new];
                [self.navigationController pushViewController:kaoqin animated:YES];
            }else if (indexPath.row == 2){
                // 工作任务
                TaskTabbarController *task = [TaskTabbarController new];
                [self.navigationController pushViewController:task animated:YES];
            }else{

                // 实用工具
                MoreToolsViewController *moreTool = [MoreToolsViewController new];
                [self.navigationController pushViewController:moreTool animated:YES];
            }
        }else{
            // 营销工具
            if (self.isJuFenxiang) {
                // 有营销工具数据
                ButtonIconModel *model = [ButtonIconModel new];
                model.name = self.titleArray[indexPath.section][indexPath.row];
                model.ico = self.iconArray[indexPath.section][indexPath.row];
                model.id = self.idArray[indexPath.section][indexPath.row];
                model.fromType = FromWebSite;
                
                
                
                if ([model.name isEqualToString:@"九宫格"]) {
                    // 九宫格
                    NineXuanchuanController *nineTabbar = [NineXuanchuanController new];
                    nineTabbar.saleModel = model;
                    [self.navigationController pushViewController:nineTabbar animated:YES];
                }else{
                    SaleToolViewController *sale = [SaleToolViewController new];
                    sale.saleModel = model;
                    [self.navigationController pushViewController:sale animated:YES];
                }
            }else{
                // 没有营销工具数据
                EmptyViewController *empty = [EmptyViewController new];
                [self.navigationController pushViewController:empty animated:YES];
            }
        }
    } else {
        // 员工
        if (indexPath.section == 0) {
            // ERP应用
            if (indexPath.row == 0) {
                // 开单
                OpenOrderViewController *open = [OpenOrderViewController new];
                [self.navigationController pushViewController:open animated:YES];
            } else if(indexPath.row == 1){
                // 查询
                SearchOrderViewController *search = [SearchOrderViewController new];
                [self.navigationController pushViewController:search animated:YES];
                
            }else if (indexPath.row == 2){
                // 预约
                PreOrderVController *preOrder = [PreOrderVController new];
                [self.navigationController pushViewController:preOrder animated:YES];
            }else if(indexPath.row == 3){
                // 摄控本
                ShekongBenController *shekongben = [ShekongBenController new];
                [self.navigationController pushViewController:shekongben animated:YES];
            }else if (indexPath.row == 4){
                // 订单收款
                OrderCheckViewController *orderCheck = [OrderCheckViewController new];
                [self.navigationController pushViewController:orderCheck animated:YES];
            }else if(indexPath.row == 5){
                // 业绩榜
                YejiViewController *yeji = [YejiViewController new];
                [self.navigationController pushViewController:yeji animated:YES];
            }else if(indexPath.row == 6){
                // 我的工作
                MyJobsViewController *job = [MyJobsViewController new];
                [self.navigationController pushViewController:job animated:YES];
            }else if(indexPath.row == 7){
                // 今日订单
                TodayOrderViewController *today = [TodayOrderViewController new];
                [self.navigationController pushViewController:today animated:YES];
            }
        } else if(indexPath.section == 1){
            // 工作办公
            if (indexPath.row == 0) {
                // 审批
                MyApproveVController *appear = [MyApproveVController new];
                [self.navigationController pushViewController:appear animated:YES];

            }else if(indexPath.row == 1){

                // 考勤打卡
                CheckTabBarController *kaoqin = [CheckTabBarController new];
                [self.navigationController pushViewController:kaoqin animated:YES];
            }else if (indexPath.row == 2){
                // 工作任务
                TaskTabbarController *task = [TaskTabbarController new];
                [self.navigationController pushViewController:task animated:YES];
            }else{

                // 实用工具
                MoreToolsViewController *moreTool = [MoreToolsViewController new];
                [self.navigationController pushViewController:moreTool animated:YES];
            }
        }else{
            // 营销工具
            if (self.isJuFenxiang) {
                // 有营销工具数据
                ButtonIconModel *model = [ButtonIconModel new];
                model.name = self.titleArray[indexPath.section][indexPath.row];
                model.ico = self.iconArray[indexPath.section][indexPath.row];
                model.id = self.idArray[indexPath.section][indexPath.row];
                model.fromType = FromWebSite;
                
                
                
                if ([model.name isEqualToString:@"九宫格"]) {
                    // 九宫格
                    NineXuanchuanController *nineTabbar = [NineXuanchuanController new];
                    nineTabbar.saleModel = model;
                    [self.navigationController pushViewController:nineTabbar animated:YES];
                }else{
                    SaleToolViewController *sale = [SaleToolViewController new];
                    sale.saleModel = model;
                    [self.navigationController pushViewController:sale animated:YES];
                }
            }else{
                // 没有营销工具数据
                EmptyViewController *empty = [EmptyViewController new];
                [self.navigationController pushViewController:empty animated:YES];
            }
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
        
        if ([self.userModel.type intValue] == 1) {
            NSArray *titleArr = @[@"ERP应用",@"财务管理",@"工作办公",@"营销工具"];
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            headerview.title = titleArr[indexPath.section];
            reusableview = headerview;
        }else{
            NSArray *titleArr = @[@"ERP应用",@"工作办公",@"营销工具"];
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            headerview.title = titleArr[indexPath.section];
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

#pragma mark - 其他方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 改变导航栏alpha
    CGPoint point = _collectionView.contentOffset;
    CGFloat alpha = (point.y + topViewH) < topViewH ? ((point.y + topViewH) / topViewH) : 1;
    
    if ([[YLZGDataManager sharedManager] isSpringFestival]) {
        _suspendNav.backgroundColor = RGBACOLOR(194, 16, 31, alpha);
    }else{
        _suspendNav.backgroundColor = RGBACOLOR(31, 139, 229, alpha);
    }
    _suspendNav.titleLabel.textColor = RGBACOLOR(255, 255, 255, alpha);
    CGFloat y = scrollView.contentOffset.y;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < -topViewH) {
        CGRect frame = _topView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _topView.frame = frame;
    }
}
- (void)GonggaoClick
{
    PublicNoticeController *gonggao = [PublicNoticeController new];
    [self.navigationController pushViewController:gonggao animated:YES];
}
#pragma mark - 展示新特性
- (void)showNewPages
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isShowNewPage) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        NewFutherViewController *newFuther = [NewFutherViewController new];
        [self presentViewController:newFuther animated:NO completion:^{
            
        }];
    }
}
#pragma mark - 网络状况发送了变化
- (void)networkChanged:(EMConnectionState)connectionState;
{
    if (connectionState == EMConnectionDisconnected) {
        // 网络失去连接fo_bg_06
        self.topView.image = [UIImage imageNamed:@"lose_wlan"];
    }else{
        // 获得连接
        BOOL isSpring = [[YLZGDataManager sharedManager] isSpringFestival];
        if (isSpring) {
            self.topView.image = [UIImage imageNamed:@"nian_sy_bg"];
        }else{
            self.topView.image = [UIImage imageNamed:@"sy_bg"];
        }
        
        if (!self.isJuFenxiang) {
            
            [self getJufenxiangInfo];
            
        }
    }
    
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -21, SCREEN_WIDTH, SCREEN_HEIGHT - 25) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
        
        _collectionView.contentInset = UIEdgeInsetsMake(topViewH, 0, 0, 0);
        [_collectionView registerClass:[HomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView"];
    }
    return _collectionView;
}
- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -topViewH, SCREEN_WIDTH, topViewH)];
        _topView.userInteractionEnabled = YES;
        _topView.image = [UIImage imageNamed:@"sy_bg"];
        _topView.backgroundColor = MainColor;
        _topView.autoresizingMask = YES;
    }
    return _topView;
}
- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setFrame:CGRectMake(SCREEN_WIDTH - 33 - 12, 25, 40, 40)];
        [_refreshButton setImage:[UIImage imageNamed:@"btn_refresh"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(getJufenxiangInfo) forControlEvents:UIControlEventTouchUpInside];
        _refreshButton.backgroundColor = [UIColor clearColor];
    }
    return _refreshButton;
}
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 33, 25, 40, 40)];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorV;
}

@end
