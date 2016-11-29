//
//  TaskViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "TaskListModel.h"
#import "MyCareTaskController.h"
#import "MyCreateTaskController.h"
#import "MyManagerTaskController.h"



@interface TaskViewController ()<UIScrollViewDelegate>
/** seg */
@property (strong,nonatomic) UISegmentedControl *segView;
/** 标签数组 */
@property (copy,nonatomic) NSArray *titleArr;
/** 子控制器 */

/** 内容视图 */
@property (strong,nonatomic) UIScrollView *contentView;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作任务";
    
    [self setupSubViews];
    [self getData];
    
    [YLNotificationCenter addObserver:self selector:@selector(getData) name:TaskReloadData object:nil];
    
}

- (void)setupSubViews
{
    
//    self.view.backgroundColor = [UIColor whiteColor];
    // 添加顶部视图
    self.titleArr = @[@"我负责的",@"我创建的",@"我关注的"];
    [self.view addSubview:self.segView];
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
    contentScrollView.y = CGRectGetMaxY(self.segView.frame);
    contentScrollView.width = self.view.width;
    
    // 判断是否是点击tabbar中间加号进来的，如果是则不减去tabbar的高度
    CGFloat scrollViewH;
    scrollViewH = self.view.height - 108 - self.segView.height - self.segView.y;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArr.count, 0);
    contentScrollView.pagingEnabled = YES;
    self.contentView = contentScrollView;
    [self.view insertSubview:self.contentView belowSubview:self.segView];
    
}
- (void)addController
{
    MyManagerTaskController *vc1 = [MyManagerTaskController new];
    [self addChildViewController:vc1];
    
    MyCreateTaskController *vc2 = [MyCreateTaskController new];
    [self addChildViewController:vc2];
    
    MyCareTaskController *vc3 = [MyCareTaskController new];
    [self addChildViewController:vc3];
}
- (void)addDefaultController
{
    UIViewController *defaultVC = [self.childViewControllers firstObject];
    defaultVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:defaultVC.view];
}
- (UISegmentedControl *)segView
{
    if (!_segView) {
        _segView = [[UISegmentedControl alloc]initWithItems:self.titleArr];
        __weak __block TaskViewController *weakSelf = self;
        [_segView addBlockForControlEvents:UIControlEventValueChanged block:^(UISegmentedControl *sender) {
            // 标签点击方法
            NSInteger index = sender.selectedSegmentIndex;
            weakSelf.segView.selectedSegmentIndex = sender.selectedSegmentIndex;
            
            CGFloat offsetX = index * weakSelf.contentView.width;
            CGFloat offsetY = weakSelf.contentView.contentOffset.y;
            CGPoint offset = CGPointMake(offsetX, offsetY);
            [weakSelf.contentView setContentOffset:offset animated:YES];
            
        }];
        _segView.selectedSegmentIndex = 0;
        _segView.tintColor = MainColor;
        _segView.frame = CGRectMake(30*CKproportion, 8, SCREEN_WIDTH - 60*CKproportion, 33);
    }
    return _segView;
}

#pragma mark - scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentView.frame.size.width;
    self.segView.selectedSegmentIndex = index;
    if (index == 0) {
        MyManagerTaskController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else if (index == 1){
        MyCreateTaskController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else {
        MyCareTaskController *newVc = self.childViewControllers[index];
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


#pragma mark - 获取数据
- (void)getData
{
    NSString *url = [NSString stringWithFormat:TaskList_Url,[ZCAccountTool account].userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (code == 1) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSArray *care = [result objectForKey:@"care"];
            NSArray *create = [result objectForKey:@"create"];
            NSDictionary *manage = [result objectForKey:@"manage"];
            NSArray *laterArr = [manage objectForKey:@"later"];
            NSArray *todayArr = [manage objectForKey:@"today"];
            
            NSArray *laterModel = [TaskListModel mj_objectArrayWithKeyValuesArray:laterArr];
            NSArray *todayModel = [TaskListModel mj_objectArrayWithKeyValuesArray:todayArr];
            
            NSArray *createModel = [TaskListModel mj_objectArrayWithKeyValuesArray:create];
            NSArray *careModel = [TaskListModel mj_objectArrayWithKeyValuesArray:care];
            
            MyManagerTaskController *vc1 = self.childViewControllers[0];
            vc1.todayArray = todayModel;
            vc1.laterArray = laterModel;
            MyCreateTaskController *vc2 = self.childViewControllers[1];
            vc2.array = createModel;
            MyCareTaskController *vc3 = self.childViewControllers[2];
            vc3.array = careModel;
            
        }else{
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}

@end
