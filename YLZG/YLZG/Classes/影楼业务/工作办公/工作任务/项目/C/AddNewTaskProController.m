//
//  AddNewTaskProController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddNewTaskProController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import "HeadIconView.h"
#import "NormalTableCell.h"
#import "YLZGDataManager.h"
#import "IvitGroupMembersController.h"


@interface AddNewTaskProController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *memberArr;

@property (strong,nonatomic) UITextField *titleField;

@property (strong,nonatomic) UIButton *button;

@property (strong,nonatomic) UILabel *addLabel;

@property (strong,nonatomic) UILabel *swithLabel;

@property (strong,nonatomic) UISwitch *switchV;

@end

@implementation AddNewTaskProController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加新项目";
    [self setupSubViews];
}

- (void)setupSubViews
{
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 标题
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.backgroundColor = self.view.backgroundColor;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.titleField];
        return cell;
    }else if (indexPath.row == 1){
        // 项目成员
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.memberArr.count >= 1) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [self.addLabel removeFromSuperview];
            // 添加头像
            CGFloat spaceH = 5; // 横向间距
            CGFloat spaceZ = 5; // 纵向间距
            CGFloat W = (SCREEN_WIDTH - spaceH*7)/5;  // 宽
            for (int i = 0; i < self.memberArr.count; i++) {
                CGRect frame;
                frame.size.width = W;
                frame.size.height = W;
                frame.origin.x = (i%5) * (frame.size.width + spaceH) + spaceH;
                frame.origin.y = floor(i/5) * (frame.size.height + spaceZ) + 5;
                HeadIconView *iconV = [[HeadIconView alloc]initWithFrame:frame];
                iconV.model = self.memberArr[i];
                [cell.contentView addSubview:iconV];
            }
            
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.contentView addSubview:self.addLabel];
        }
        
        return cell;
    }else {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.backgroundColor = self.view.backgroundColor;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        
        [cell addSubview:self.swithLabel];
        [cell addSubview:self.switchV];
        [cell addSubview:self.button];
        
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1){
        if (self.memberArr.count > 5) {
            int yuNum = self.memberArr.count%5;
            if (yuNum == 0) {
                //整除
                return 55 * yuNum;
            }else{
                return 55 * (yuNum + 1);
            }
        }else if(self.memberArr.count > 0){
            return 80;
        }else{
            return 55;
        }
    }else {
        return 200*CKproportion;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 项目名称
        
    }else if (indexPath.row == 1){
        // 项目成员组
        IvitGroupMembersController *ivitVC = [IvitGroupMembersController new];
        
        ivitVC.SeletcMemberBlock = ^(NSArray *selectMem){
            [self.memberArr addObjectsFromArray:selectMem];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:ivitVC animated:YES];
        
    }else {
        // 按钮
    }
}
- (void)AddProduce
{
    if (self.titleField.text.length == 0 ) {
        [self showErrorTips:@"请填写项目标题"];
        return;
    }
    if (self.memberArr.count == 0) {
        [self showErrorTips:@"请选择项目成员"];
        return;
    }
    NSMutableArray *mem = [NSMutableArray array];
    for (ContactersModel *model in self.memberArr) {
        [mem addObject:model.uid];
    }
    if (self.switchV.on) {
        [mem addObject:[ZCAccountTool account].userID];
    }
    NSString *jsonStr = [self toJsonStr:mem];
    NSString *url = [NSString stringWithFormat:CreateProduce_URL,[ZCAccountTool account].userID,self.titleField.text,jsonStr];
    [self showHudMessage:@""];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self hideHud:0];
        if (code == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self showErrorTips:error.localizedDescription];
    }];
}
- (UILabel *)addLabel
{
    if (!_addLabel) {
        _addLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, self.view.width - 30, 30)];
        _addLabel.backgroundColor = [UIColor clearColor];
        _addLabel.text = @"选择项目成员";
        _addLabel.font = [UIFont systemFontOfSize:14];
        _addLabel.textColor = [UIColor grayColor];
    }
    return _addLabel;
}
- (UILabel *)swithLabel
{
    if (!_swithLabel) {
        _swithLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, self.view.width - 30, 30)];
        _swithLabel.backgroundColor = [UIColor clearColor];
        _swithLabel.text = @"加入该项目";
        _swithLabel.font = [UIFont systemFontOfSize:14];
        _swithLabel.textColor = [UIColor grayColor];
    }
    return _swithLabel;
}
- (UISwitch *)switchV
{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 40 - 15, 7, 40, 40)];
        _switchV.onTintColor = MainColor;
        _switchV.tintColor = MainColor;
        [_switchV addTarget:self action:@selector(ValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_switchV setOn:YES animated:YES];
    }
    return _switchV;
}
- (void)ValueChanged:(UISwitch *)switchV
{
    NSLog(@"------%d-----",self.switchV.on);
}
- (UITextField *)titleField
{
    if (!_titleField) {
        _titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        _titleField.backgroundColor = [UIColor whiteColor];
        _titleField.textAlignment = NSTextAlignmentCenter;
        _titleField.placeholder = @"项目标题";
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _titleField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_titleField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    }
    return _titleField;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH - 40, 40)];
        _button.backgroundColor = MainColor;
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 4;
        [_button addTarget:self action:@selector(AddProduce) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"确  定" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _button;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}
- (NSMutableArray *)memberArr
{
    if (!_memberArr) {
        _memberArr = [NSMutableArray array];
    }
    return _memberArr;
}

@end
