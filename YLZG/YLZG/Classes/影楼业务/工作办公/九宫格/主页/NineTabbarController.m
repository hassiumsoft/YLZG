//
//  NineTabbarController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineTabbarController.h"
#import "NineMeViewController.h"
#import "NineMyCareViewController.h"
#import "NineAllMobanViewController.h"


@interface NineTabbarController ()

@end

@implementation NineTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格";
    self.delegate = self;
    self.view.backgroundColor = NorMalBackGroudColor;
    NineAllMobanViewController *checkWork = [NineAllMobanViewController new];
    [self addChildVC:checkWork Title:@"九宫格" image:@"btn_dongtai_" selectedImage:@"btn_dongtai_lan" Tag:1];
    
    NineMyCareViewController *zenVC = [[NineMyCareViewController alloc]init];
    [self addChildVC:zenVC Title:@"关注" image:@"btn_dongtai_" selectedImage:@"btn_dongtai_lan" Tag:2];
    
    NineMeViewController *dongtaiVC = [[NineMeViewController alloc]init];
    [self addChildVC:dongtaiVC Title:@"我的" image:@"btn_dongtai_" selectedImage:@"btn_dongtai_lan" Tag:3];
}




#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage Tag:(NSInteger)tag
{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    
    
    //    childVC.tabBarItem.imag
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttres = [NSMutableDictionary dictionary];
    textAttres[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    textAttres[NSForegroundColorAttributeName] = RGBACOLOR(191, 191, 191, 1);
    
    NSMutableDictionary *selectTextAttres = [NSMutableDictionary dictionary];
    selectTextAttres[NSForegroundColorAttributeName] = MainColor;
    selectTextAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    [childVC.tabBarItem setTitleTextAttributes:textAttres forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttres forState:UIControlStateSelected];
    //    HomeNavigationController *normalNav = [[HomeNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:childVC];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    
}


@end
