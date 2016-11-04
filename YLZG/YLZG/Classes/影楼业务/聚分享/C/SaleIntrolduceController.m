//
//  SaleIntrolduceController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/3.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SaleIntrolduceController.h"
#import <Masonry.h>
#import "SaleToolModel.h"
#import "ZCAccountTool.h"
#import <UIImageView+WebCache.h>
#import "HTTPManager.h"
#import <MJExtension.h>


@interface SaleIntrolduceController ()

@property (strong,nonatomic) UITextView *contentLabel;

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) SaleToolModel *model;

@end

@implementation SaleIntrolduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";
    self.view.backgroundColor = RGBACOLOR(35, 49, 45, 1);
    self.view.layer.borderColor = WechatRedColor.CGColor;
    self.view.layer.borderWidth= 1.f;
    self.view.layer.cornerRadius = 12;
    
    [self getData];
}

- (void)getData
{
    NSString *url = [NSString stringWithFormat:YingxiaoToolDetial_URL,[ZCAccountTool account].userID,self.saleModel.id];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.model = [SaleToolModel mj_objectWithKeyValues:result];
            [self setupSubViews:self.model];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}


- (void)setupSubViews:(SaleToolModel *)model
{
    
    // 标题
    self.imageView = [[UIImageView alloc]init];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.ico] placeholderImage:[UIImage imageNamed:@"btn_ico_jizan"]];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.width.and.height.equalTo(@50);
    }];
    
    
    
    
    // 返回按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"×" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-3);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@24);
    }];
    
    
    // 中间那部分
    self.contentLabel = [[UITextView alloc]init];
    _contentLabel.text = self.model.remarks;
    _contentLabel.editable = NO;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.bottom.equalTo(cancleBtn.mas_top).offset(-5);
    }];
    
    
}

- (void)reloadData
{
    self.contentLabel.text = self.model.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.ico] placeholderImage:[UIImage imageNamed:@"btn_ico_jizan"]];
}


- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
