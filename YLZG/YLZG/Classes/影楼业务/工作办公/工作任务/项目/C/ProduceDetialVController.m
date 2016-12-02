//
//  ProduceDetialVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialVController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "TopTitleView.h"
#import <MJExtension.h>
#import "ProduceDetialModel.h"
#import "ProduceMemVController.h"
#import "ProduceFileVController.h"
#import "ProduceTaskVController.h"
#import "ProduceDiscussVController.h"

#define TopHeight 46
@interface ProduceDetialVController ()<UIScrollViewDelegate>

/** 顶部滚动栏 */
@property (strong,nonatomic) UIScrollView *topScrollView;
/** 标签数组 */
@property (copy,nonatomic) NSArray *titleArr;
/** 内容视图 */
@property (strong,nonatomic) UIScrollView *contentView;

/** 顶部标签数组 */
@property (strong,nonatomic) NSMutableArray *topTitleArray;


@end

@implementation ProduceDetialVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.listModel.name;
    [self setupSubViews];
    [self getDetialData];
}
- (void)setupSubViews
{
    // 添加顶部视图
    self.titleArr = @[@"任务",@"讨论",@"成员",@"文件"];
    
    [self.view addSubview:self.topScrollView];
    // 初始化内容滚动栏
    [self setupContentScrollView];
    // 添加子控制器
    [self addController];
    // 设置默认控制器
    [self addDefaultController];
}
- (void)setupContentScrollView
{
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.y = CGRectGetMaxY(self.topScrollView.frame);
    contentScrollView.width = self.view.width;
    
    // 判断是否是点击tabbar中间加号进来的，如果是则不减去tabbar的高度
    CGFloat scrollViewH;
    scrollViewH = SCREEN_HEIGHT - 64 - self.topScrollView.height - self.topScrollView.y;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArr.count, 0);
    contentScrollView.pagingEnabled = YES;
    self.contentView = contentScrollView;
    [self.view insertSubview:self.contentView belowSubview:self.topScrollView];
}
- (void)addController
{
    ProduceTaskVController *vc1 = [ProduceTaskVController new];
    [self addChildViewController:vc1];
    
    ProduceDiscussVController *vc2 = [ProduceDiscussVController new];
    [self addChildViewController:vc2];
    
    ProduceMemVController *vc3 = [ProduceMemVController new];
    [self addChildViewController:vc3];
    
    ProduceFileVController *vc4 = [ProduceFileVController new];
    [self addChildViewController:vc4];
}
- (void)addDefaultController
{
    UIViewController *defaultVC = [self.childViewControllers firstObject];
    defaultVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:defaultVC.view];
}
#pragma mark - scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentView.frame.size.width;
    for (TopTitleView *button in self.topTitleArray) {
        button.isCurrentIndex = NO;
    }
    TopTitleView *topButton = self.topTitleArray[index];
    topButton.isCurrentIndex = YES;
    
    if (index == 0) {
        ProduceTaskVController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else if (index == 1){
        ProduceDiscussVController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else if (index == 2){
        ProduceMemVController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else {
        ProduceFileVController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }
    
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - 懒加载
- (UIScrollView *)topScrollView
{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, TopHeight)];
        _topScrollView.contentSize = CGSizeMake(self.view.width, 0);
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        // 添加几个按钮
        for (int i = 0; i < self.titleArr.count; i++) {
            CGFloat W = self.view.width/self.titleArr.count;
            CGRect frame = CGRectMake(i * W, 0, W, _topScrollView.height);
            TopTitleView *topButton = [[TopTitleView alloc]initWithFrame:frame];
            topButton.tag = i;
            topButton.title = self.titleArr[i];
            if (i == 0) {
                topButton.isCurrentIndex = YES;
            }else{
                topButton.isCurrentIndex = NO;
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                // 标签点击方法
                NSInteger index = i;
                CGFloat offsetX = index * self.contentView.width;
                CGFloat offsetY = self.contentView.contentOffset.y;
                CGPoint offset = CGPointMake(offsetX, offsetY);
                [self.contentView setContentOffset:offset animated:YES];
                
            }];
            [topButton addGestureRecognizer:tap];
            [_topScrollView addSubview:topButton];
            // 装进数组
            [self.topTitleArray addObject:topButton];
        }
    }
    return _topScrollView;
}

#pragma mark - 获取数据
- (void)getDetialData
{
    
    NSString *url = [NSString stringWithFormat:ProduceDetial_URL,[ZCAccountTool account].userID,_listModel.id];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            ProduceDetialModel *model = [ProduceDetialModel mj_objectWithKeyValues:result];
            
            ProduceTaskVController *taskVC = self.childViewControllers[0];
            taskVC.taskArray = model.task;
            
            ProduceDiscussVController *discussVC = self.childViewControllers[1];
            discussVC.discussArray = model.discuss;
            
            ProduceMemVController *memVC = self.childViewControllers[2];
            memVC.memArray = model.member;
            
            ProduceFileVController *fileVC = self.childViewControllers[3];
            fileVC.fileArray = model.file;
        }else{
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}
- (NSMutableArray *)topTitleArray
{
    if (!_topTitleArray) {
        _topTitleArray = [[NSMutableArray alloc]init];
    }
    return _topTitleArray;
}

@end
