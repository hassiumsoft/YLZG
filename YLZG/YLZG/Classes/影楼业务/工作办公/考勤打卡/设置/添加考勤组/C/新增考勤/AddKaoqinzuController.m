//
//  AddKaoqinzuController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AddKaoqinzuController.h"
#import "NormalTableCell.h"
#import "HomeNavigationController.h"
#import "ChooseMemVController.h"
#import "ChangeRulesController.h"
#import "ChooseAdminsController.h"
#import "StaffInfoModel.h"
#import <Masonry.h>



@interface AddKaoqinzuController ()<UITableViewDelegate,UITableViewDataSource,ChooseAdminDelegate,ChooseMemDegate>

@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

/** 考勤组名称 */
@property (strong,nonatomic) UITextField *nameField;
/** 考勤组人员 */
@property (strong,nonatomic) UILabel *memberLabel;
/** 考勤组负责人 */
@property (strong,nonatomic) UILabel *kaoqinFuzer;
/** 是否为固定班制 */
@property (strong,nonatomic) UISwitch *switchV;
/** 下一步按钮 */
@property (strong,nonatomic) UIButton *nextBtn;


/** 成员json字符串 */
@property (copy,nonatomic) NSString *memArrJson;
/** 管理员json字符串 */
@property (copy,nonatomic) NSString *adminArrJson;
/** 排班制时用到的员工信息数组 */
@property (strong,nonatomic) NSMutableArray *staffArray;


@end

@implementation AddKaoqinzuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加考勤组";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = @[@[@"考勤组名称"],@[@"考勤组人员",@"考勤组负责人"],@[@"固定班制"]];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.backgroundColor = MainColor;
    [self.nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(@20);
        make.height.equalTo(@40);
    }];
}
#pragma mark - 下一步
- (void)nextClick
{
    if (self.nameField.text.length < 1) {
        [self showErrorTips:@"请填写考勤组名称"];
        return;
    }
    if ([self.memberLabel.text isEqualToString:@"请选择"]) {
        [self showErrorTips:@"请选择组成员"];
        return;
    }
    if ([self.kaoqinFuzer.text isEqualToString:@"请选择"]) {
        [self showErrorTips:@"请选择负责人"];
        return;
    }
    ChangeRulesController *changeRule = [ChangeRulesController new];
    changeRule.memArrJson = self.memArrJson;
    changeRule.name = self.nameField.text;
    if (self.switchV.on) {
        changeRule.type = @"1"; // 固定班制
    }else{
        changeRule.type = @"2"; // 弹性班制
    }
    changeRule.adminArrJson = self.adminArrJson;
    changeRule.staffArray = self.staffArray;
    [self.navigationController pushViewController:changeRule animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 考勤组名称
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 考勤组人员
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell addSubview:self.memberLabel];
            return cell;
        } else {
            // 考勤组负责人
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell addSubview:self.kaoqinFuzer];
            return cell;
        }
    }else {
        // 固定班制
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:self.switchV];
        
        if (self.switchV.on) {
            // 固定班制
            cell.textLabel.text = @"固定班制";
            cell.detailTextLabel.text = @"上下班时间一致";
        }else{
            // 排班制
            cell.textLabel.text = @"排班制";
            cell.detailTextLabel.text = @"上下班相对弹性";
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 选中考勤人员
            ChooseMemVController *mem = [ChooseMemVController new];
            mem.delegate = self;
            [self.navigationController pushViewController:mem animated:YES];
        }else{
            // 选中负责人
            ChooseAdminsController *shenpier = [ChooseAdminsController new];
            shenpier.delegate = self;
            [self.navigationController pushViewController:shenpier animated:YES];
        }
    }
}
#pragma mark - 选中负责人后的代理
- (void)chooseAdminWithArray:(NSArray *)adminArrar
{
    
    NSMutableArray *idArray = [NSMutableArray array];
    for (StaffInfoModel *model in adminArrar) {
        self.kaoqinFuzer.text = [NSString stringWithFormat:@"%@等%lu人",model.nickname,(unsigned long)adminArrar.count];
        [idArray addObject:model.uid];
    }
//    NSString *json = [self toJsonStr:idArray];
    
    self.adminArrJson = [self toJsonStr:idArray];
}
- (void)chooseMemWithArray:(NSArray *)memArray
{
    self.staffArray = (NSMutableArray *)[memArray copy];
    NSMutableArray *idArray = [NSMutableArray array];
    for (StaffInfoModel *model in memArray) {
        self.memberLabel.text = [NSString stringWithFormat:@"%@等%lu人",model.nickname,(unsigned long)memArray.count];
        [idArray addObject:model.uid];
    }
    
//    NSString *json = [self toJsonStr:idArray];
    
    self.memArrJson = [self toJsonStr:idArray];
}

#pragma mark - 其他设置
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 65;
    }else{
        return 55;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}
#pragma mark - 懒加载
- (UISwitch *)switchV
{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 15, 44, 35)];
        _switchV.onTintColor = MainColor;
        [_switchV addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        [_switchV setOn:YES animated:YES];
    }
    return _switchV;
}
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 9, 200, 36)];
        _nameField.placeholder = @"早班/中班/晚班";
        _nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_nameField.placeholder attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]}];
        _nameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _nameField;
}
- (UILabel *)kaoqinFuzer
{
    if (!_kaoqinFuzer) {
        _kaoqinFuzer = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 11, 180, 30)];
        _kaoqinFuzer.text = @"请选择";
        _kaoqinFuzer.textColor = [UIColor grayColor];
        _kaoqinFuzer.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _kaoqinFuzer.textAlignment = NSTextAlignmentRight;
    }
    return _kaoqinFuzer;
}
- (UILabel *)memberLabel
{
    if (!_memberLabel) {
        _memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 11, 180, 30)];
        _memberLabel.text = @"请选择";
        _memberLabel.textColor = [UIColor grayColor];
        _memberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _memberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _memberLabel;
}
- (void)switchClick:(UISwitch *)switchV
{
    [self.tableView reloadData];
}
#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}
- (NSMutableArray *)staffArray
{
    if (!_staffArray) {
        _staffArray = [NSMutableArray array];
    }
    return _staffArray;
}

@end
