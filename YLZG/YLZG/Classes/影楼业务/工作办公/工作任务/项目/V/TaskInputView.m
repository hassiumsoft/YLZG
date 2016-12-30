//
//  TaskInputView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskInputView.h"
#import <IQKeyboardManager.h>

#define TextPlace @"输入评论"

@interface TaskInputView ()<UITextViewDelegate>

@property (strong,nonatomic) UITextView *textView;

@end

@implementation TaskInputView

- (instancetype)initWithFrame:(CGRect)frame DidClick:(void (^)(NSString *))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setImage:[UIImage imageNamed:@"btn_tianjiatupian"] forState:UIControlStateNormal];
        [iconButton setImage:[UIImage imageNamed:@"btn_tianjiatupian"] forState:UIControlStateSelected];
        [iconButton setFrame:CGRectMake(5, 10, 30, 30)];
        iconButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:iconButton];
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH - 40 - 60, 40)];
        self.textView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        self.textView.text = TextPlace;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:13];
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.cornerRadius = 4;
        [self addSubview:self.textView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = MainColor;
        [button setFrame:CGRectMake(CGRectGetMaxX(self.textView.frame)+5, 8, 50, 34)];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
            if (self.textView.text.length == 0) {
                return ;
            }
            [self endEditing:YES];
            block(self.textView.text);
            
        }];
        button .layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        [self addSubview:button];
        
    }
    return self;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:TextPlace]) {
        textView.text = nil;
        textView.font = [UIFont systemFontOfSize:16];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:TextPlace] || [textView.text isEqualToString:@""]) {
        
        textView.text = TextPlace;
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor lightGrayColor];
    }
}


@end
