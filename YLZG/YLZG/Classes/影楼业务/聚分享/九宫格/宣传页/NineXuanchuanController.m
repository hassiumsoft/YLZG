//
//  NineXuanchuanController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/1/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NineXuanchuanController.h"
#import "NineWebViewController.h"
#import "NineDataViewController.h"
#import "HTTPManager.h"
#import "NineTabbarController.h"
#import "ZCAccountTool.h"
#import "SaleToolModel.h"
#import <Masonry.h>
#import <LCActionSheet.h>
#import <MJExtension.h>
#import "SaleIntrolduceController.h"
#import "YLZGTitleLabel.h"
#import "DismissingAnimator.h"
#import "PresentingAnimator.h"


#define ScrollHeight 45

@interface NineXuanchuanController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>

/** 顶部标签滚动栏 */
@property (strong, nonatomic) UIScrollView * titleScrollView;
/** 内容滚动栏 */
@property (strong, nonatomic) UIScrollView * contentScrollView;
/** 标签数组 */
@property (strong, nonatomic) NSArray * titleArray;
/** 工具详情 */
@property (strong,nonatomic) SaleToolModel *saleDetialModel;

/** 子控制器 */
@property (strong,nonatomic) NineWebViewController *actionVC;
/** 子控制器 */
@property (strong,nonatomic) NineDataViewController *datasourceVC;

@end

@implementation NineXuanchuanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.saleModel.name;
    
    [self getData];
}

- (void)getData
{
    NSString *url = [NSString stringWithFormat:YingxiaoToolDetial_URL,[ZCAccountTool account].userID,self.saleModel.id];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.saleDetialModel = [SaleToolModel mj_objectWithKeyValues:result];
            [self setupSubViews];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}


#pragma mark - UI
- (void)setupSubViews
{
    self.titleArray = @[@"功能介绍",@"数据统计"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_about"] style:UIBarButtonItemStylePlain target:self action:@selector(ButtonClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    /** 初始化顶部标签滚动栏 */
    [self setupTitleScrollView];
    
    /** 初始化内容滚动栏 */
    [self setupContentScrollView];
    
    /** 添加子控制器 */
    [self addController];
    
    /** 添加标签 */
    [self addLabel];
    
    /** 添加默认控制器 */
    [self addDefaultController];
    
    /** 添加底部视图 */
    [self addBottomView];
}

/** 添加默认控制器 */
- (void)addDefaultController
{
    NineWebViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    YLZGTitleLabel *lable = [self.titleScrollView.subviews firstObject];
    lable.scale = 1.0;
}


/** 添加子控制器 */
- (void)addController
{
    NineWebViewController * vc1 = [[NineWebViewController alloc] init];
    vc1.saleModel = self.saleModel;
    [self addChildViewController:vc1];
    
    NineDataViewController * vc2 = [[NineDataViewController alloc] init];
    vc2.saleModel = self.saleModel;
    [self addChildViewController:vc2];
}

/** 添加标签 */
- (void)addLabel
{
    CGFloat labelW = SCREEN_WIDTH / self.titleArray.count;
    CGFloat labelH = ScrollHeight;
    CGFloat labelY = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat labelX = i * labelW;
        YLZGTitleLabel * label = [[YLZGTitleLabel alloc] init];
        label.text = self.titleArray[i];
        if (iOS_Version >= 8.2) {
            label.font = [UIFont systemFontOfSize:15 weight:0.01];
        }else{
            label.font = [UIFont systemFontOfSize:15];
        }
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.tag = i;
        [self.titleScrollView addSubview:label];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTitleClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(labelW * self.titleArray.count, 0);
}

/** 标签点击方法 */
- (void)orderTitleClick:(UITapGestureRecognizer *)recognizer
{
    YLZGTitleLabel *titlelable = (YLZGTitleLabel *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.contentScrollView.frame.size.width;
    
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    
}


/** 初始化顶部标签滚动栏 */
- (void)setupTitleScrollView
{
    UIScrollView * titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = ToolBarColor;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.x = 0;
    titleScrollView.y = 0;
    titleScrollView.width = self.view.width;
    titleScrollView.height = ScrollHeight;
    self.titleScrollView = titleScrollView;
    [self.view addSubview:self.titleScrollView];
}

/** 初始化内容滚动栏 */
- (void)setupContentScrollView
{
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.y = 45;
    contentScrollView.width = self.view.width;
    
    CGFloat scrollViewH;
    scrollViewH = SCREEN_HEIGHT - 64 - self.titleScrollView.height - 45;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArray.count, 0);
    contentScrollView.backgroundColor = self.view.backgroundColor;
    contentScrollView.pagingEnabled = YES;
    self.contentScrollView = contentScrollView;
    [self.view insertSubview:self.contentScrollView belowSubview:self.titleScrollView];
}
/** 底部视图 */
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = MainColor;
    bottomView.layer.masksToBounds = YES;
    bottomView.userInteractionEnabled = YES;
    bottomView.layer.shadowColor = [UIColor purpleColor].CGColor;
    bottomView.layer.shadowRadius = 3;
    bottomView.layer.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(ScrollHeight));
    }];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    if (self.saleDetialModel.isBuy) {
        leftLabel.text = @"您已成功订购此套营销工具";
    }else{
        leftLabel.text = @"您还没有订购此项营销工具";
    }
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.height.equalTo(@(ScrollHeight));
        make.width.equalTo(@(self.view.width * 0.6));
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.saleDetialModel.isBuy) {
        [useButton setTitle:@"立即使用" forState:UIControlStateNormal];
    }else{
        [useButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.layer.masksToBounds = YES;
    useButton.layer.cornerRadius = 4;
    useButton.titleLabel.font = [UIFont systemFontOfSize:15];
    useButton.layer.borderColor = [UIColor whiteColor].CGColor;
    useButton.layer.borderWidth = 1.f;
    [useButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.saleDetialModel.isBuy) {
            NineTabbarController *nineTab = [NineTabbarController new];
            [self.navigationController pushViewController:nineTab animated:YES];
        }else{
            [self sendErrorWarning:@"1、您可以在我-区域经理中联系您的区域经理订购；2、通过微信联系智诚相关人士。3、备注区域总监郭孟强微信：gmq18612916180"];
        }
    }];
    [bottomView addSubview:useButton];
    CGFloat W = self.view.width * 0.4 * 0.51;
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(W));
        make.height.equalTo(@30);
        make.right.equalTo(bottomView.mas_right).offset(-15);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
}


#pragma mark - scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    // 滚动标题栏
    YLZGTitleLabel *titleLable = (YLZGTitleLabel *)self.titleScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.titleScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
    [self.titleScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    if (index == 0) {
        NineWebViewController *newsVc = self.childViewControllers[index];
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != index) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        
        if (newsVc.view.superview) return;
        
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    } else {
        NineDataViewController *newsVc = self.childViewControllers[index];
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != index) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        
        if (newsVc.view.superview) return;
        
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    YLZGTitleLabel *labelLeft = self.titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titleScrollView.subviews.count) {
        YLZGTitleLabel *labelRight = self.titleScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

- (void)ButtonClick
{
    SaleIntrolduceController *area = [SaleIntrolduceController new];
    area.transitioningDelegate = self;
    area.saleModel = self.saleModel;
    area.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:area animated:YES completion:^{
        
    }];
}
#pragma mark - POP动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}


@end
