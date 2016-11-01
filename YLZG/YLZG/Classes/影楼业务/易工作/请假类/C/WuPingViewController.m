//
//  WuPingViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WuPingViewController.h"
#import "ShenpiersViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import "WorkTableViewCell.h"

#define TitlePlace @"领用申请将以推送内容推送到审批人的手机，请尽量详细。"

@interface WuPingViewController ()<UITableViewDataSource,UITableViewDelegate, ShenpiDelegate>
{
    UIButton *commitBtn;  /** 提交按钮 */
}

@property (strong,nonatomic) UITableView *tableView;
/** 领用详情 */
@property (strong,nonatomic) YYTextView *reasonTextV;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

/** 物品用途 */
@property (strong,nonatomic) UITextField *textField;
/** 物品名称 */
@property (nonatomic, strong) UITextField * nameField;
/** 物品数量 */
@property (nonatomic, strong) UITextField * countField;
/** 领用详情 */
@property (nonatomic, strong) UILabel *label;


/** 回调参数 */
// 审批人
@property (copy,nonatomic) NSString *nameStr;
// 审批人的uid
@property (copy,nonatomic) NSString *uid;

@end

@implementation WuPingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物品领用";
    [self setupSubViews];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.label.text = @"物品用途";
        [cell.infoLabel removeFromSuperview];
        
        [cell.contentView addSubview:self.textField];
        
        
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.label.text = @"物品名称";
            [cell.infoLabel removeFromSuperview];
            [cell.contentView addSubview:self.nameField];
            return cell;
        }else {
            WorkTableViewCell *cell = [WorkTableViewCell sharedWorkCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.label.text = @"物品数量";
            [cell.infoLabel removeFromSuperview];
            [cell.contentView addSubview:self.countField];
            return cell;
        }
    }else if (indexPath.section == 2) {
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
    if (indexPath.section == 0) {
        
    } else if(indexPath.section == 1){
        
    }else if (indexPath.section == 2) {
        // 选择审批人
        ShenpiersViewController *shenpier = [[ShenpiersViewController alloc]init];
        shenpier.delegate = self;
        [self.navigationController pushViewController:shenpier animated:YES];
    }else{
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return 44;
    }else{
        return 180*CKproportion;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 2 || section == 1) {
        return 12;
    }else{
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        return foot;
    }else{
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = self.view.backgroundColor;
        commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.backgroundColor = MainColor;
        [commitBtn addTarget:self action:@selector(commitction:) forControlEvents:UIControlEventTouchUpInside];
        commitBtn.layer.cornerRadius = 6;
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [foot addSubview:commitBtn];
        [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(foot.mas_centerX);
            make.bottom.equalTo(foot.mas_bottom).offset(-1);
            make.width.equalTo(@(SCREEN_WIDTH - 40*CKproportion));
            make.height.equalTo(@36);
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
    if (self.textField.text.length < 1 || self.nameField.text.length < 1 || self.countField.text.length < 1 || [self.nameStr isEqualToString:@"请选择(必填)"] || self.reasonTextV.text.length < 1) {
        [self sendErrorWarning:@"请完善信息"];
        return;
    }
    
    /************  请求数据 ************/
    [self.view endEditing:YES];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    ZCAccount * account = [ZCAccountTool account];
    
    NSString *url = [NSString stringWithFormat:Wupinlingyong_Url, self.textField.text, self.nameField.text, self.countField.text, self.reasonTextV.text, self.uid, account.userID];
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
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [commitBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->commitBtn.mas_centerY);
            make.width.and.height.equalTo(@26);
            make.centerX.equalTo(self->commitBtn.mas_centerX);
        }];
    }
    return _indicatorV;
}


/** 物品用途 */
- (UITextField *)textField {
    if (!_textField) {
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(86, 15, SCREEN_WIDTH-100, 20)];
        self.textField.placeholder = @"如:日常办公";
        self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        self.textField.attributedText = [[NSAttributedString alloc]initWithString:self.textField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBACOLOR(10, 10, 10, 10)}];
        
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

/** 物品名称 */
- (UITextField *)nameField {
    if (!_nameField) {
        self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(86, 15, SCREEN_WIDTH-100, 20)];
        self.nameField.placeholder = @"请输入名称";
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        self.nameField.attributedText = [[NSAttributedString alloc]initWithString:self.nameField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBACOLOR(10, 10, 10, 10)}];
        
        self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nameField;
}

/** 物品数量 */
- (UITextField *)countField {
    if (!_countField) {
        _countField = [[UITextField alloc]initWithFrame:CGRectMake(86, 15, SCREEN_WIDTH-100, 20)];
        _countField.placeholder = @"请输入数量";
        _countField.keyboardType = UIKeyboardTypeNumberPad;
        _countField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.countField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _countField.attributedText = [[NSAttributedString alloc]initWithString:self.countField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBACOLOR(10, 10, 10, 10)}];
        
        _countField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _countField;
}

/** 领用详情 */
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 70, 24)];
        _label.text = @"领用详情";
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
        _reasonTextV.placeholderText = TitlePlace;
        _reasonTextV.placeholderTextColor = [UIColor grayColor];
        _reasonTextV.placeholderFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _reasonTextV.textColor = [UIColor blackColor];
        _reasonTextV.font = [UIFont systemFontOfSize:15];
        _reasonTextV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reasonTextV.layer.borderWidth = 0.5f;
        _reasonTextV.layer.cornerRadius = 5;
        _reasonTextV.backgroundColor = [UIColor whiteColor];
        
    }
    return _reasonTextV;
}



@end
