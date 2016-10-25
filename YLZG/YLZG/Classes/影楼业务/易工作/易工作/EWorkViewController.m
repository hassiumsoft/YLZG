//
//  EWorkViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "EWorkViewController.h"
#import "NormalIconView.h"
#import "QingjiaViewController.h"
#import "WaichuViewController.h"
#import "WuPingViewController.h"
#import "CommonApplyController.h"
#import "MyApproveVController.h"
#import "CheckTabBarController.h"


#define space 1
@interface EWorkViewController ()

@end

@implementation EWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"易工作";
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"work_top"]];
    topImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150*CKproportion);
    [self.view addSubview:topImageV];
    
    NSArray *iconArr = @[@"work_qiandao", @"work_qingjia",@"work_out",@"work_shiwu",@"work_normal",@"work_shenpi", @"kongbai",@""];
    NSArray *titleArr = @[@"考勤打卡", @"请假",@"外出",@"物品领用",@"通用",@"待审批", @"",@""];
    CGFloat btnWH = (SCREEN_WIDTH - 5*space)/4;
    
    UIView * backView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageV.frame), SCREEN_WIDTH, btnWH*2 + 3)];
    backView.backgroundColor = NorMalBackGroudColor;
    [self.view addSubview:backView];
    
    for (int i = 0; i < iconArr.count; i++) {
        CGRect frame;
        frame.size.width = btnWH;
        frame.size.height = btnWH;
        frame.origin.x = (i%4) * (frame.size.width + space) + space;
        frame.origin.y = (i/4) * (frame.size.height + space) + space;
        
        NormalIconView *button = [NormalIconView sharedHomeIconView];
        button.frame = frame;
        button.tag = 11+i;
        [button addTarget:self action:@selector(changeWork:) forControlEvents:UIControlEventTouchUpInside];
        button.iconView.image = [UIImage imageNamed:iconArr[i]];
        button.backgroundColor = [UIColor whiteColor];
        button.label.text = titleArr[i];
        button.label.textColor = [UIColor blackColor];
        [button setTitleColor:RGBACOLOR(10, 10, 10, 1) forState:UIControlStateNormal];
        [backView addSubview:button];
        
    }
    
}

- (void)changeWork:(NormalIconView *)sender
{
    if (sender.tag == 11) {
        // 考勤打卡
        CheckTabBarController *chackTab = [CheckTabBarController new];
        [self.navigationController pushViewController:chackTab animated:YES];
    } else if(sender.tag == 12){
        // 请假
        QingjiaViewController *qingjia = [QingjiaViewController new];
        [self.navigationController pushViewController:qingjia animated:YES];
    }else if (sender.tag == 13){
        // 外出
        WaichuViewController *waichu = [WaichuViewController new];
        [self.navigationController pushViewController:waichu animated:YES];
    }else if (sender.tag == 14){
        // 物品领用
        WuPingViewController *wupin = [WuPingViewController new];
        [self.navigationController pushViewController:wupin animated:YES];
    }else if (sender.tag == 15){
        // 通用
        CommonApplyController *apply = [CommonApplyController new];
        [self.navigationController pushViewController:apply animated:YES];
    }else if (sender.tag == 16){
        // 待审批
        MyApproveVController *myApprove = [MyApproveVController new];
        [self.navigationController pushViewController:myApprove animated:YES];
    }
}


@end
