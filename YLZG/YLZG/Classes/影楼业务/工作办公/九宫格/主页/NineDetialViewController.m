//
//  NineDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineDetialViewController.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "NineDetialModel.h"
#import "HTTPManager.h"
#import <UIImageView+WebCache.h>


@interface NineDetialViewController ()


@end

@implementation NineDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板详细";
    [self getData];
    
}
#pragma mark - 获取数据
- (void)getData
{
    NineDetialModel *model = [NineDetialModel new];
    [self setupSubViews:model];
}
#pragma mark - 绘制UI界面
- (void)setupSubViews:(NineDetialModel *)model
{
    // 描述文字
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.width - 20, 110*CKproportion)];
    descLabel.numberOfLines = 0;
    descLabel.backgroundColor = HWRandomColor;
    descLabel.text = @"神秘石刻看得开的目的没看我考完科目五开没开三开门的看到门口都没得看没贷款都没看到没贷款目瞪口呆没看到没贷款没贷款。www.baidu.com";
    descLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    descLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:descLabel];
    
    // 九宫格
    NSArray *titleArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    CGFloat spaceH = 3; // 横向间距
    CGFloat spaceZ = 3; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*4 - 30)/3;  // 宽
    CGFloat H = W;
    for (int i = 0; i < titleArray.count; i++) {
        CGRect frame;
        frame.size.width = W;
        frame.size.height = H;
        frame.origin.x = (i%3) * (frame.size.width + spaceH) + spaceH + 15;
        frame.origin.y = floor(i/3) * (frame.size.height + spaceZ) + spaceZ + 120*CKproportion;
        
        UIImageView *button = [[UIImageView alloc]initWithImage:[self imageWithBgColor:HWRandomColor]];
        [button setFrame:frame];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        [self.view addSubview:button];
        
    }
    
    
    // 转发按钮
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sendButton.backgroundColor = MainColor;
//    [sendButton setTitle:@"一键转发" forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        [self showSuccessTips:@"转发"];
//    }];
//    [sendButton setFrame:CGRectMake(20, self.view.height - 20, self.view.width - 40, 40)];
//    sendButton.layer.masksToBounds = YES;
//    sendButton.layer.cornerRadius = 4;
//    [self.view addSubview:sendButton];
}


@end
