//
//  HengpinNavController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HengpinNavController.h"

@interface HengpinNavController ()

@property(nonatomic)NSUInteger orietation;

@end

@implementation HengpinNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO; // 清除默认的半透明颜色
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:RGBACOLOR(245, 245, 245, 1)}];
    self.navigationBar.barTintColor = MainColor;

    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 支持旋转
-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
    
}


//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
