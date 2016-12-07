//
//  CommonApplyController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CommonApplyController.h"
#import "WorkTableViewCell.h"
#import "ShenpiersViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <Masonry.h>

@interface CommonApplyController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ShenpiDelegate>

@property (strong,nonatomic) UITableView *tableView;
/** 请假理由 */
@property (nonatomic, strong) UILabel *label;
@property (strong,nonatomic) YYTextView *reasonTextV;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 审批内容类型 */
@property (nonatomic, strong) UITextField *textField;
/** 提交按钮 */
@property (nonatomic, strong) UIButton * commitBtn;

/** 回调参数 */
// 审批人
@property (copy,nonatomic) NSString *nameStr;
// 审批人的uid
@property (copy,nonatomic) NSString *uid;

@end

#define TitlePlace @"该申请适用于任何内容的申请，您只需向审批人描述您的申请需求。"
@implementation CommonApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用审批";
    [self setupSubViews];
}

#pragma mark -懒加载
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 70, 24)];
        _label.text = @"申请详情";
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = RGBACOLOR(10, 10, 10, 1);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (YYTextView *)reasonTextV
{
    if (!_reasonTextV) {
        _reasonTextV = [[YYTextView alloc]initWithFrame:CGRectMake(86, 10, SCREEN_WIDTH - 86 - 12, 130)];
        _reasonTextV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reasonTextV.layer.borderWidth = 0.5f;
        _reasonTextV.layer.cornerRadius = 5;
        _reasonTextV.backgroundColor = [UIColor whiteColor];
        _reasonTextV.placeholderText = TitlePlace;
        _reasonTextV.placeholderTextColor = [UIColor grayColor];
        _reasonTextV.placeholderFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _reasonTextV.textColor = [UIColor blackColor];
        _reasonTextV.font = [UIFont systemFontOfSize:15];
        
    }
    return _reasonTextV;
}

- (UITextField *)textField {
    if (!_textField) {
        self.textField = [[UITextField alloc]init];
        self.textField.delegate = self;
        self.textField.placeholder = @"如:拜访客户";
        self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        self.textField.attributedText = [[NSAttributedString alloc]initWithString:self.textField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBACOLOR(10, 10, 10, 10)}];
        
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}


#pragma mark -搭建UI相关
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.nameStr = @"请选择(必填)";
    
}

#pragma mark -表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.label.text = @"标题";
        [cell.infoLabel removeFromSuperview];
        
        [cell.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.label.mas_right).offset(-20);
            make.right.equalTo(cell.mas_right).offset(-8);
            make.height.equalTo(@40);
        }];
        
        return cell;
    }else if (indexPath.section == 1) {
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        cell.label.text = @"审批人";
        cell.infoLabel.text = self.nameStr;
        return cell;
    }else{
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.label removeFromSuperview];
        [cell.infoLabel removeFromSuperview];
        /********** 开始绘制剩下的控件 **************/
        [cell.contentView addSubview:self.label];
        [cell.contentView addSubview:self.reasonTextV];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0&&indexPath.row == 0) {
        
    } else if(indexPath.section == 1){
        // 选择审批人
        ShenpiersViewController *shenpier = [[ShenpiersViewController alloc]init];
        shenpier.title = @"选择审批人";
        shenpier.delegate = self;
        [self.navigationController pushViewController:shenpier animated:YES];
        
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }else{
        return 180*CKproportion;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 12;
    }else{
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        return foot;
    }else{
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = MainColor;
        [_commitBtn addTarget:self action:@selector(commitction:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 4;
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [foot addSubview:_commitBtn];
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(foot.mas_centerX);
            make.bottom.equalTo(foot.mas_bottom).offset(-1);
            make.width.equalTo(@(SCREEN_WIDTH - 40*CKproportion));
            make.height.equalTo(@40);
        }];
        return foot;
    }
}

#pragma mark -回调相关
- (void)shenpiDelegate:(StaffInfoModel *)model {
    self.nameStr = model.nickname;
    self.uid = model.uid;
    [_tableView reloadData];
}


#pragma mark - 提交
- (void)commitction:(UIButton *)sender
{
    /************ 判断必填项 ************/
    if (self.textField.text.length < 1 || [self.nameStr isEqualToString:@"请选择(必填)"] || self.reasonTextV.text.length < 1) {
        [self sendErrorWarning:@"请完善信息"];
        return;
    }
    
    /************  请求数据 ************/
    [self.view endEditing:YES];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:TongyongShenpi, self.textField.text, self.reasonTextV.text, self.uid, account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString * message = [[responseObject objectForKey:@"message"] description];
        [self.indicatorV stopAnimating];
        [sender setTitle:@"提  交" forState:UIControlStateNormal];
        if (status == 1) {
            [self sendSuccess:message];
        }else {
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.indicatorV stopAnimating];
        [sender setTitle:@"提  交" forState:UIControlStateNormal];
        [self sendErrorWarning:[NSString stringWithFormat:@"%@(审批人暂未开通手机端，导致无法推送。)",error.localizedDescription]];
    }];
    
    
}

- (void)sendSuccess:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

#pragma mark -回退键盘相关
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
    [_reasonTextV resignFirstResponder];
}

#pragma mark -菊花视图相关
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_commitBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_commitBtn.mas_centerY);
            make.width.and.height.equalTo(@26);
            make.centerX.equalTo(self->_commitBtn.mas_centerX);
        }];
    }
    return _indicatorV;
}


@end
