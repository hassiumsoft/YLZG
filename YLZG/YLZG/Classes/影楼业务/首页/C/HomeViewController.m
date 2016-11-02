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
#import "NewFutherViewController.h"

#import "OpenOrderViewController.h"
#import "SearchOrderViewController.h"
#import "PreOrderVController.h"
#import "ShekongBenController.h"
#import "OrderCheckViewController.h"
#import "YejiViewController.h"
#import "MyApproveVController.h"
#import "TodayFinanceController.h"
#import "TodayOrderViewController.h"
#import "MonthFinanceVController.h"
#import "MyJobsViewController.h"
#import "CheckTabBarController.h"
#import "PublicNoticeController.h"
#import "PintuanViewController.h"



#define topViewH 190*CKproportion

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

{
    // 悬浮导航条
    NavigationView * _suspendNav;
}


/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (copy,nonatomic) NSArray *titleArray;
@property (copy,nonatomic) NSArray *iconArray;
/** 顶部的视图 */
@property (strong,nonatomic) UIImageView *topView;
/** 通知按钮 */
@property (strong,nonatomic) UIButton *tipsButton;
/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    [self showNewPages];
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

#pragma mark - 创建视图UI
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.userModel = [UserInfoManager getUserInfo];
    self.title = @"我的影楼";
    
    if ([self.userModel.type intValue] == 1) {
        self.titleArray = @[@[@"开单",@"查询",@"预约",@"摄控本",@"订单收款",@"业绩榜"],@[@"今日财务",@"财务统计"],@[@"审批",@"我的工作",@"今日订单",@"考勤打卡"],@[@"拼团",@"砍价",@"助力",@"集赞",@"众筹",@"全民公益",@"投票报名"]];
        self.iconArray = @[@[@"btn_ico_kaidan",@"btn_ico_chaxun",@"btn_ico_yuyue",@"btn_ico_shekongben",@"btn_ico_dingdanshoukuan",@"btn_ico_yejibang"],@[@"btn_icon_tofinace",@"btn_icon_monthfinace"],@[@"btn_ico_shenpi",@"btn_ico_jinrigongzuo",@"btn_jinridingdan",@"btn_ico_kaoqin"],@[@"btn_ico_pintuan",@"btn_ico_kanjia",@"btn_ico_zhuli",@"btn_ico_jizan",@"btn_ico_zhongchou",@"btn_ico_gongyi",@"btn_ico_toupiao"]];
    }else{
        self.titleArray = @[@[@"开单",@"查询",@"预约",@"摄控本",@"订单收款",@"业绩榜"],@[@"审批",@"我的工作",@"今日订单",@"考勤打卡"],@[@"拼团",@"砍价",@"助力",@"集赞",@"众筹",@"全民公益",@"投票报名"]];
        self.iconArray = @[@[@"btn_ico_kaidan",@"btn_ico_chaxun",@"btn_ico_yuyue",@"btn_ico_shekongben",@"btn_ico_dingdanshoukuan",@"btn_ico_yejibang"],@[@"btn_ico_shenpi",@"btn_ico_jinrigongzuo",@"btn_jinridingdan",@"btn_ico_kaoqin"],@[@"btn_ico_pintuan",@"btn_ico_kanjia",@"btn_ico_zhuli",@"btn_ico_jizan",@"btn_ico_zhongchou",@"btn_ico_gongyi",@"btn_ico_toupiao"]];
    }
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView insertSubview:self.topView atIndex:0];
    // 悬浮栏
    _suspendNav = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _suspendNav.titleLabel.textColor = RGBACOLOR(255, 255, 255, 0);
    _suspendNav.backgroundColor = RGBACOLOR(31, 139, 229, 0);
    [self.view addSubview:_suspendNav];
    // 通知按钮
    self.tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tipsButton setFrame:CGRectMake(12, 25, 36, 36)];
    [self.tipsButton setImage:[UIImage imageNamed:@"btn_gonggao"] forState:UIControlStateNormal];
    [self.tipsButton addTarget:self action:@selector(GonggaoClick) forControlEvents:UIControlEventTouchUpInside];
    self.tipsButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tipsButton];
    
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
    return [self.titleArray[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [HomeCollectionCell sharedCell:collectionView Path:indexPath];
    ButtonIconModel *model = [ButtonIconModel new];
    model.title = self.titleArray[indexPath.section][indexPath.row];
    model.icon = self.iconArray[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
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
            }else{
                // 业绩榜
                YejiViewController *yeji = [YejiViewController new];
                [self.navigationController pushViewController:yeji animated:YES];
            }
        } else if(indexPath.section == 1){
            // 财务应用
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
            if (indexPath.row == 0) {
                // 审批
                MyApproveVController *appear = [MyApproveVController new];
                [self.navigationController pushViewController:appear animated:YES];
            } else if(indexPath.row == 1){
                // 我的工作
                MyJobsViewController *job = [MyJobsViewController new];
                [self.navigationController pushViewController:job animated:YES];
            }else if(indexPath.row == 2){
                // 今日订单
                TodayOrderViewController *today = [TodayOrderViewController new];
                [self.navigationController pushViewController:today animated:YES];
            }else{
                // 考勤打卡
                CheckTabBarController *kaoqin = [CheckTabBarController new];
                [self.navigationController pushViewController:kaoqin animated:YES];
            }
        }else{
            // 聚分享
            if (indexPath.row == 0) {
                // 拼团
                PintuanViewController *pintuan = [PintuanViewController new];
                [self.navigationController pushViewController:pintuan animated:YES];
            } else if(indexPath.row == 1){
                // 砍价
                
            }else if (indexPath.row == 2){
                // 助力
                
            }else if (indexPath.row == 3){
                // 集赞
                
            }else if (indexPath.row == 4){
                // 众筹
                
            }else if (indexPath.row == 5){
                // 全民公益
                
            }else{
                // 投票报名
                
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
            }else{
                // 业绩榜
                YejiViewController *yeji = [YejiViewController new];
                [self.navigationController pushViewController:yeji animated:YES];
            }
        } else if(indexPath.section == 1){
            // 工作办公
            if (indexPath.row == 0) {
                // 审批
                MyApproveVController *appear = [MyApproveVController new];
                [self.navigationController pushViewController:appear animated:YES];
            } else if(indexPath.row == 1){
                // 我的工作
                MyJobsViewController *job = [MyJobsViewController new];
                [self.navigationController pushViewController:job animated:YES];
            }else if(indexPath.row == 2){
                // 今日订单
                TodayOrderViewController *today = [TodayOrderViewController new];
                [self.navigationController pushViewController:today animated:YES];
            }else{
                // 考勤打卡
                CheckTabBarController *kaoqin = [CheckTabBarController new];
                [self.navigationController pushViewController:kaoqin animated:YES];
            }
        }else{
            // 聚分享
            if (indexPath.row == 0) {
                // 拼团
                PintuanViewController *pintuan = [PintuanViewController new];
                [self.navigationController pushViewController:pintuan animated:YES];
            } else if(indexPath.row == 1){
                // 砍价
                
            }else if (indexPath.row == 2){
                // 助力
                
            }else if (indexPath.row == 3){
                // 集赞
                
            }else if (indexPath.row == 4){
                // 众筹
                
            }else if (indexPath.row == 5){
                // 全民公益
                
            }else{
                // 投票报名
                
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
            NSArray *titleArr = @[@"ERP应用",@"财务应用",@"工作办公",@"聚分享"];
            HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
            headerview.title = titleArr[indexPath.section];
            reusableview = headerview;
        }else{
            NSArray *titleArr = @[@"ERP应用",@"工作办公",@"聚分享"];
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
    _suspendNav.backgroundColor = RGBACOLOR(31, 139, 229, alpha);
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


@end
