//
//  AboutZhichengController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AboutZhichengController.h"
#import <LCActionSheet.h>
#import <Masonry.h>

@interface AboutZhichengController ()<UIScrollViewDelegate,LCActionSheetDelegate>
{
    NSInteger current; //当前显示图片
    BOOL isFirst;     //定时器是否是第一次使用
    UIPageControl *pageControl;
}
//滚动图片
@property (nonatomic,strong) UIScrollView *pictureScrollView;

@property (nonatomic,strong) NSTimer *myTimer;

//存放图片名称的可变数组
@property(nonatomic,strong)NSMutableArray *pictureArray;

@end

@implementation AboutZhichengController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智诚科技";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pictureArray =[[NSMutableArray alloc]initWithArray:@[@"zhichen_1",@"zhichen_2",@"zhichen_3",@"zhichen_4",@"zhichen_5"]];
    //    [self setupSubViews];
    [self createScrollView];
    [self createImageViewInPictureScrollView];
    
    [self updatePictureScrollView];
    [self createPageControl];
}

- (void)weixinClick:(UIButton *)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    
    [pasteBoard setString:@"bjzc4000191951"];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已复制，请前往微信。\r粘贴查找公众号并关注。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *weixin_url = @"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weixin_url]];
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
#pragma mark -- 创建UIScrollView
-(void)createScrollView
{
    if (!self.isLogin) {
        self.pictureScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }else{
        self.pictureScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }
    self.pictureScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.pictureScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    self.pictureScrollView.showsHorizontalScrollIndicator = NO;
    self.pictureScrollView.showsVerticalScrollIndicator = NO;
    self.pictureScrollView.delegate = self;
    self.pictureScrollView.pagingEnabled = YES;
    self.pictureScrollView.bounces = NO;
    //防止UIScrollView位置发生偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.pictureScrollView];
    
}
#pragma mark -- 创建UIImageView
-(void)createImageViewInPictureScrollView
{
    current = 0;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, SCREEN_WIDTH,  self.pictureScrollView.height)];
        imageView.tag = 5+i;
        if (i == 1) {
            imageView.image = [UIImage imageNamed:self.pictureArray[0]];
        }else if (i == 0){
            imageView.image = [UIImage imageNamed:[self.pictureArray lastObject]];
        }else{
            imageView.image = [UIImage imageNamed:self.pictureArray[1]];
        }
        
        [self.pictureScrollView addSubview:imageView];
    }
}
#pragma mark 创建PageControl
-(void)createPageControl
{
    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.pictureArray.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    pageControl.enabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-6);
        make.height.equalTo(@20);
    }];
}
-(void)updatePictureScrollView
{
    
    isFirst = YES;
    self.myTimer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:2 target:self selector:@selector(handleShowTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
    
}
//
-(void)handleShowTimer
{
    if (isFirst == NO) {
        [self.pictureScrollView setContentOffset:CGPointMake(self.pictureScrollView.contentOffset.x + self.view.frame.size.width ,0) animated:YES];
    }
    else
    {
        isFirst = NO;
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.myTimer invalidate];
    self.myTimer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updatePictureScrollView];
}
//定时器要走的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if(self.pictureScrollView.contentOffset.x > self.view.frame.size.width){
        
        if (current == self.pictureArray.count - 1) {
            current = 0;
        }
        else
        {
            current ++;
        }
        
    }
    
    else if (self.pictureScrollView.contentOffset.x < self.view.frame.size.width)
    {
        if(current == 0)
        {
            current = self.pictureArray.count - 1;
        }
        else
        {
            current --;
        }
    }
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self scrollImageView:current];
    pageControl.currentPage = current;
    
    
}
//手动拖拽的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > self.view.frame.size.width){
        
        if (current == self.pictureArray.count - 1) {
            current = 0;
        }
        else
        {
            current ++;
        }
        
    }
    
    else if (scrollView.contentOffset.x < self.view.frame.size.width)
    {
        if(current == 0)
        {
            current = self.pictureArray.count - 1;
        }
        else
        {
            current --;
        }
    }
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self scrollImageView:current];
    pageControl.currentPage = current;
    
}
/**
 *  图片滚动时
 *
 *  @param index 图片索引
 */
-(void)scrollImageView:(NSInteger )index
{
    //提取imageView
    UIImageView *imageView1 = (UIImageView *)[self.pictureScrollView viewWithTag:5];
    UIImageView *imageView2 = (UIImageView *)[self.pictureScrollView viewWithTag:6];
    UIImageView *imageView3 = (UIImageView *)[self.pictureScrollView viewWithTag:7];
    
    
    if (index == self.pictureArray.count - 1) {
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[0]];
        imageView1.image = [UIImage imageNamed:self.pictureArray[current-1]];
    }
    else if (index == 0)
    {
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[1+current]];
        imageView1.image = [UIImage imageNamed:self.pictureArray.lastObject];
        
    }
    else {
        
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[current+1]];
        imageView1.image = [UIImage imageNamed:self.pictureArray [current-1]];
    }
    
    
    
}


/******************************/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    //修改状态栏的颜色
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width,20)];
    overlay.backgroundColor = NavColor;
    [self.navigationController.navigationBar insertSubview:overlay atIndex:0];
    [self.navigationController.navigationBar setBackgroundColor:NavColor];
    
    if (self.isLogin) {
        // push进来的
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_nav"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"📱" style:UIBarButtonItemStylePlain target:self action:@selector(callPhone)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }else{
        // 没有nav
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        topView.userInteractionEnabled = YES;
        topView.backgroundColor = NavColor;
        [self.view addSubview:topView];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton setFrame:CGRectMake(12, 21, 30, 30)];
        [backButton setImage:[UIImage imageNamed:@"back_nav"] forState:UIControlStateNormal];
        [topView addSubview:backButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"📱" forState:UIControlStateNormal];
        [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 30 - 15, 21, 30, 30)];
        [topView addSubview:rightButton];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)callPhone
{
    
    //    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"免费咨询客服" buttonTitles:@[@"18515530245(北京号,捆绑微信号)",@"0371-60929793"] redButtonIndex:-1 delegate:self];
    //    [actionSheet show];
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"免费咨询客服" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"18515530245(北京号,捆绑微信号)",@"0371-60929793", nil];
    [sheet show];
}
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:18612916182"]];
            UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
            [self.view addSubview:phoneWebView];
            break;
        }
        case 2:
        {
            NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:4000-191951"]];
            UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
            [self.view addSubview:phoneWebView];
            break;
        }
        default:
            break;
    }
}
- (void)back
{
    if (!self.isLogin) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
