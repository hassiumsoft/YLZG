//
//  FabuViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FabuViewController.h"
#import "HTTPManager.h"
#import <Masonry.h>
#import "ZCAccountTool.h"


@interface FabuViewController ()<UITextViewDelegate>
/** 标题 */
@property (strong,nonatomic) UITextField *titleField;
/** 发布内容 */
@property (strong,nonatomic) UITextView *textView;
/** 发布按钮 */
@property (strong,nonatomic) UIButton *button;

/** 是否置顶 */
@property (strong,nonatomic) UISwitch *swtich;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

@end

@implementation FabuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布公告";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    self.titleField.backgroundColor = [UIColor whiteColor];
    [self.titleField becomeFirstResponder];
    [self.titleField clearsOnBeginEditing];
    self.titleField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 0)];
    self.titleField.leftViewMode = UITextFieldViewModeAlways;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.placeholder = @"公告标题(精简在15字以内)";
    self.titleField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.titleField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [self.view addSubview:self.titleField];
    
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10+40+10, SCREEN_WIDTH, 150)];
    self.textView.delegate = self;
    self.textView.text = @"如：关于国庆黄金周放假通知，影楼决定···";
    self.textView.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.textView];
    
    UIView *isTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 60 + 150 + 10, SCREEN_WIDTH, 50)];
    isTopView.userInteractionEnabled = YES;
    isTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:isTopView];
    
    UILabel *waringLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 30)];
    waringLabel.text = @"公告是否置顶";
    waringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [isTopView addSubview:waringLabel];
    
    self.swtich = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 8, 60, 34)];
    
    [_swtich setOn:NO animated:YES];
    [isTopView addSubview:_swtich];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"确认发布" forState:UIControlStateNormal];
    self.button.backgroundColor = WeChatColor;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 4;
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@40);
    }];
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"如：关于国庆黄金周放假通知，影楼决定···"]) {
        textView.text = @"";
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"如：关于国庆黄金周放假通知，影楼决定···";
        textView.font = [UIFont systemFontOfSize:12];
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - 发布公告
- (void)send:(UIButton *)sender
{
    if (self.titleField.text.length > 15) {
        [self sendError:@"标题请精简在15字以内"];
        return;
    }
    
    if ((self.titleField.text.length > 2) && (self.textView.text.length > 5)) {
        
        NSString *url = [NSString stringWithFormat:FabuGonggao,self.titleField.text,self.textView.text,self.swtich.on,[ZCAccountTool account].userID];
        [sender setTitle:@"" forState:UIControlStateNormal];
        [self.indicatorV startAnimating];
        
        [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.indicatorV stopAnimating];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            int status = [[[responseObject objectForKey:@"code"] description] intValue];
            if (status == 1) {
                if (_FabuSuccessBlock) {
                    _FabuSuccessBlock();
                }
                [self sendSuccess:sender];
            }else{
                [self sendError:message];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self.indicatorV stopAnimating];
            [sender setTitle:@"确认发布" forState:UIControlStateNormal];
            [self sendError:error.localizedDescription];
        }];
    }else{
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确认发布" forState:UIControlStateNormal];
        [self sendError:@"字数太少，请完善"];
    }
    
    
}
- (void)sendError:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
- (void)sendSuccess:(UIButton *)sender
{
    [self.indicatorV stopAnimating];
    [sender setTitle:@"确认发布" forState:UIControlStateNormal];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [YLNotificationCenter postNotificationName:YLRequestData object:nil];
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_button addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_button.mas_centerX);
            make.centerY.equalTo(self->_button.mas_centerY);
            make.width.and.height.equalTo(@40);
        }];
    }
    return _indicatorV;
}


@end
