//
//  CheckTabBarController.m
//  YLZG
//
//  Created by apple on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CheckTabBarController.h"
#import "CheckWorkViewController.h"
#import "CheckInfoViewController.h"
#import "CheckSettingVController.h"
#import "HomeNavigationController.h"
#import "SuperSettingController.h"

#import "InGroupViewController.h"
#import "ZCAccountTool.h"








@interface CheckTabBarController ()<UITabBarControllerDelegate>

{
    CheckSettingVController *_settingVC;
    UIBarButtonItem *_settingItem;
}


@end

@implementation CheckTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考勤打卡";
 
    self.delegate = self;
    
    CheckWorkViewController *checkWork = [CheckWorkViewController new];
    [self addChildVC:checkWork Title:@"考勤打卡" image:@"tabbar_daka_normal" selectedImage:@"tabbar_daka_selected" Tag:1];
    

    CheckInfoViewController *zenVC = [[CheckInfoViewController alloc]init];
    [self addChildVC:zenVC Title:@"统计" image:@"tabbar_tongji_normal" selectedImage:@"tabbar_tongji_selected" Tag:2];
    
    //    ZCAccount *account = [ZCAcountTool account];
    //    if ([account.type intValue] == 1) {
    _settingVC = [[CheckSettingVController alloc]init];
    [self addChildVC:_settingVC Title:@"考勤设置" image:@"tabbar_setting_selected" selectedImage:@"tabbar_setting_selected" Tag:3];
    //    }else{
    //        InGroupViewController *inGroup = [InGroupViewController new];
    //        [self addChildVC:inGroup Title:@"考勤组" image:@"tabbar_kaoqin_normal" selectedImage:@"tabbar_kaoqin_selected" Tag:3];
    //    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (tabBarController.selectedIndex == 0) {
        self.title = @"考勤打卡";
        self.navigationItem.rightBarButtonItem = nil;
    } else if(tabBarController.selectedIndex == 1){
        self.title = @"统计";
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        //        ZCAccount *account = [ZCAcountTool account];
        //        if ([account.type intValue] == 1) {
        self.title = @"设置";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"高级设置" style:UIBarButtonItemStylePlain target:self action:@selector(superSetting)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
}

- (void)superSetting
{
    SuperSettingController *set = [SuperSettingController new];
    [self.navigationController pushViewController:set animated:YES];
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



@end
