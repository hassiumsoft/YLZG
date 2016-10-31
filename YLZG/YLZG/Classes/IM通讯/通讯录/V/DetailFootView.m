//
//  DetailFootView.m
//  YLZG
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DetailFootView.h"
#import <Masonry.h>

@implementation DetailFootView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _messageBtn = [[UIButton alloc] init];
        _messageBtn.layer.cornerRadius = 5;
        _messageBtn.layer.masksToBounds = YES;
        _messageBtn.backgroundColor = MainColor;
        [_messageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(20);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@40);
        }];
        
        _phoneBtn = [[UIButton alloc ] init];
        _phoneBtn.layer.cornerRadius = 5;
        _phoneBtn.layer.masksToBounds = YES;
        [_phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _phoneBtn.layer.masksToBounds = YES;
        _phoneBtn.layer.borderColor = MainColor.CGColor;
        _phoneBtn.layer.borderWidth = 1.f;
        [_phoneBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _phoneBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_phoneBtn];
        [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.messageBtn.mas_left);
            make.top.equalTo(self.messageBtn.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];
    }
    return self;
    
}





+(instancetype)footerView{
    
    return [[DetailFootView alloc] init];
   
}





@end
