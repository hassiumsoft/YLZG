//
//  TaskTabbarController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskTabbarController.h"
#import "HTTPManager.h"
#import "TaskViewController.h"
#import "TaskDongtaiController.h"
#import "TaskProductsController.h"
#import "AddNewTaskController.h"


@interface TaskTabbarController ()<UITabBarControllerDelegate>

@end

@implementation TaskTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NorMalBackGroudColor;
    self.title = @"工作任务";
    
    
    self.delegate = self;
    
    TaskViewController *checkWork = [TaskViewController new];
    [self addChildVC:checkWork Title:@"工作任务" image:@"btn_renwu" selectedImage:@"btn_renwu_lan" Tag:1];
    
    TaskProductsController *zenVC = [[TaskProductsController alloc]init];
    [self addChildVC:zenVC Title:@"影楼项目" image:@"btn_xiangmu" selectedImage:@"btn_xiangmu_lan" Tag:2];
    
    TaskDongtaiController *dongtaiVC = [[TaskDongtaiController alloc]init];
    [self addChildVC:dongtaiVC Title:@"动态" image:@"btn_dongtai_" selectedImage:@"btn_dongtai_lan" Tag:3];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_rightbar"] style:UIBarButtonItemStylePlain target:self action:@selector(AddNewTask)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
- (void)AddNewTask
{
    AddNewTaskController *addtask = [AddNewTaskController new];
    [self.navigationController pushViewController:addtask animated:YES];
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
    selectTextAttres[NSForegroundColorAttributeName] = NormalColor;
    selectTextAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    [childVC.tabBarItem setTitleTextAttributes:textAttres forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttres forState:UIControlStateSelected];
    //    HomeNavigationController *normalNav = [[HomeNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:childVC];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    if (![item.title isEqualToString:@"工作任务"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_rightbar"] style:UIBarButtonItemStylePlain target:self action:@selector(AddNewTask)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    }
    
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UIImage *imageV = [UIImage imageNamed:@"lose_wlan"];
//    UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[imageV] applicationActivities:nil];
//    [self presentViewController:activity animated:YES completion:^{
//        
//    }];
//}
@end
