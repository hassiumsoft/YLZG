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
#import "EditCareCategoryController.h"
#import "CreateMobanViewController.h"


@interface NineTabbarController ()<UITabBarControllerDelegate>

@end

@implementation NineTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格";
    self.delegate = self;
    self.view.backgroundColor = NorMalBackGroudColor;
    NineAllMobanViewController *checkWork = [NineAllMobanViewController new];
    [self addChildVC:checkWork Title:@"九宫格" image:@"ico_scratchablelatex" selectedImage:@"ico_scratchablelatex_blue" Tag:1];
    
    NineMyCareViewController *zenVC = [[NineMyCareViewController alloc]init];
    [self addChildVC:zenVC Title:@"关注模板" image:@"ico_focuson" selectedImage:@"ico_focuson_blue" Tag:2];
    
    NineMeViewController *dongtaiVC = [[NineMeViewController alloc]init];
    [self addChildVC:dongtaiVC Title:@"模板管理" image:@"ico_personal" selectedImage:@"ico_personal_blue" Tag:3];
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
    
    if ([item.title isEqualToString:@"关注模板"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }else if ([item.title isEqualToString:@"模板管理"]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"创建模板" style:UIBarButtonItemStylePlain target:self action:@selector(createMobanAction)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    NineAllMobanViewController *allMoban = self.childViewControllers[0];
    MobanListModel *listModel = allMoban.listModel;
    
    NineMyCareViewController *careMoban = self.childViewControllers[1];
    careMoban.listModel = listModel;
    
}

- (void)createMobanAction
{
    CreateMobanViewController *create = [CreateMobanViewController new];
    [self.navigationController pushViewController:create animated:YES];
}

- (void)editAction
{
    NineAllMobanViewController *allMoban = self.childViewControllers[0];
    MobanListModel *listModel = allMoban.listModel;
    
    NineMyCareViewController *careMoban = self.childViewControllers[1];
    
    
    EditCareCategoryController *editCare = [EditCareCategoryController new];
    editCare.listModel = listModel;
    editCare.SelectBlock = ^(){
        [careMoban getData];
    };
    [self.navigationController pushViewController:editCare animated:YES];
}


@end
