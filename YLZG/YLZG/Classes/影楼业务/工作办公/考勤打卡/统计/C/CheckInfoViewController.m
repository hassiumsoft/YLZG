//
//  CheckInfoViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/8.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "CheckInfoViewController.h"
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
// 团队考勤
#import "TeamKaoqinView.h"
// 我的考勤
#import "MineKaoqinView.h"

@interface CheckInfoViewController ()

// 最底层的滚动视图
@property (nonatomic, strong) UIScrollView * scrollView;
// seg
@property (nonatomic, strong) UISegmentedControl * seg;
// 团队考勤
@property (nonatomic, strong) TeamKaoqinView * teamView;
// 我的考勤
@property (nonatomic, strong) MineKaoqinView * mineKaoqin;

@end

@implementation CheckInfoViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self selfInitCheckInfoViewControllerVC];
    // 搭建UI
    [self creatCheckInfoViewControllerUI];
}

#pragma mark - 初始化
- (void)selfInitCheckInfoViewControllerVC{
    self.title = @"统计";
    self.view.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
}




#pragma mark - 搭建UI
- (void)creatCheckInfoViewControllerUI{
    UserInfoModel * account = [[UserInfoManager sharedManager] getUserInfo];
    // 1是店主.0是店员
//    NSString * str = account.type;
    // 最底层的滚动视图
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
//    [self.view addSubview:self.scrollView];
    if ([account.type isEqualToString:@"1"]) {
        // 多段选择器
        NSArray * titleArr = @[@"团队考勤", @"我的考勤"];
        self.seg = [[UISegmentedControl alloc] initWithItems:titleArr];
        self.seg.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 44);
        self.seg.selectedSegmentIndex = 0;
        [self.view addSubview:self.seg];
        self.seg.tintColor = RGBACOLOR(43, 135, 227, 1);
        // 设置字体颜色
        
        [self.seg addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.teamView = [[TeamKaoqinView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.seg.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.teamView.checkCOntroller = self;
        [self.view addSubview:self.teamView];
    }else {
        self.mineKaoqin = [[MineKaoqinView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.seg.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.mineKaoqin.superCheckController = self;
        [self.view addSubview:self.mineKaoqin];
    }
    
}

#pragma mark -seg的点击事件相关
- (void)valueChanged:(UISegmentedControl *)seg {
    if (seg.selectedSegmentIndex == 0) {
        // 团队考勤
        [self.view bringSubviewToFront:self.teamView];
        
    }else if(seg.selectedSegmentIndex == 1) {
        self.mineKaoqin = [[MineKaoqinView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.seg.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.mineKaoqin.superCheckController = self;
        [self.view addSubview:self.mineKaoqin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
