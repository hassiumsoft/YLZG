//
//  SuggestController.m
//  佛友圈
//
//  Created by Chan_Sir on 16/1/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuggestController.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import "HTTPManager.h"

#define PlaceText @"输入您的反馈，我们将为您不断改进产品质量。"


@interface SuggestController ()<UITextViewDelegate>
{
    NSMutableArray *buttonArray;
}
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UITextField *textField;
@end

@implementation SuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NorMalBackGroudColor;
    self.title = @"意见反馈";
    [self setupUI];
}

- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 - 64, 150, 21)];
    label.text = @"选择反馈类型：";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    // 三个选择按钮部分
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 96 - 64, SCREEN_WIDTH, 50)];
    changeView.backgroundColor = [UIColor whiteColor];
    changeView.userInteractionEnabled = YES;
    [self.view addSubview:changeView];
    
    NSArray *array = @[@"产品建议",@"程序报错"];
    buttonArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        button.tag = 20+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [changeView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(changeView.mas_centerY);
            make.width.equalTo(@130);
            make.height.equalTo(@30);
            if (i == 0) {
                make.left.equalTo(changeView.mas_left).offset(15*CKproportion);
            }else{
                make.right.equalTo(changeView.mas_right).offset(-20*CKproportion);
            }
        }];
        
        [buttonArray addObject:button];
    }
    
    // 输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 156 - 64, SCREEN_WIDTH, 130)];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = PlaceText;
    [self.view addSubview:self.textView];
    
    UIView *clearV = [[UIView alloc]initWithFrame:CGRectMake(0, 156+130+8 - 64, 15, 40)];
    clearV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clearV];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 156+130+8 - 64, SCREEN_WIDTH - 15, 40)];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"填写您的手机或邮箱(可选)";
    self.textField.attributedText = [[NSAttributedString alloc]initWithString:self.textField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:PlaceText]) {
     self.textView.text = @"";
    }
}
- (void)didSelected:(UIButton *)sender
{
    for (UIButton *button in buttonArray) {
        [button setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    
    if (sender.tag == 20) {
        // 建议
        self.type = SuggestType;
    }else{
        // BUG
        self.type = BugType;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = PlaceText;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 提交
- (void)commitClick
{
    if (!self.type) {
        [self showErrorTips:@"请选择类型"];
        return;
    }
    if (self.textView.text.length < 1) {
        [self showErrorTips:@"不能为空"];
        return;
    }
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:MySuggestURL,account.userID,(int)self.type,self.textView.text,self.textField.text];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"谢谢您的反馈" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
    
}

@end
