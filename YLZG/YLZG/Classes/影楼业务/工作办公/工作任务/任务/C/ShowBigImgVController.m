//
//  ShowBigImgVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ShowBigImgVController.h"
#import <UIImageView+WebCache.h>


@interface ShowBigImgVController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ShowBigImgVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupSubViews];
}

- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;//设置最小放大比例
    _scrollView.maximumZoomScale = 2.5;//设置最大放大比例
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.iconStr] placeholderImage:[UIImage imageNamed:@"task_file_place"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *didTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [_scrollView addGestureRecognizer:didTap];

}
- (void)tap:(UITapGestureRecognizer *)tap {
    if(_scrollView.zoomScale != 1) {
        [_scrollView setZoomScale:1 animated:YES];
    }else {
        [_scrollView setZoomScale:2.5 animated:YES];
    }
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{//两手指触摸放大时调用，返回需要改变的view
    return _imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{//结束放大时调用
    if (scale < 1.0) {//如果放大比例小于1.0则停止放大后返回原大小
        [scrollView setZoomScale:1.0 animated:YES];
    }
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

@end
