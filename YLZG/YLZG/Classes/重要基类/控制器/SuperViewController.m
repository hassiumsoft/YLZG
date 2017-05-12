//
//  SuperViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import <Masonry.h>

@interface SuperViewController ()

@property (strong,nonatomic) UILabel *messageLabel;

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NorMalBackGroudColor;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - 数据异常时的处理
- (void)showEmptyViewWithMessage:(NSString *)message
{
    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((70 * CKproportion));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
    }];
    self.messageLabel.hidden = NO;
    self.messageLabel.text = message;
}

- (void)hideMessageAction
{
    self.messageLabel.hidden = YES;
}


@end
