//
//  AddNewBanciController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AddNewBanciController.h"
#import <Masonry.h>
#import "NoDequTableCell.h"
#import "TimePickerView.h"
#import "ZCAccountTool.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>
#import "HTTPManager.h"


@interface AddNewBanciController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UITextField *textField;

@property (copy,nonatomic) NSString *startTime;

@property (strong,nonatomic) NSString *endTime;

@end

@implementation AddNewBanciController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self setupSubViews];
    
    [YLNotificationCenter addObserver:self selector:@selector(kaishiTime:) name:StartWorkTime object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(endTime:) name:EndWorkTime object:nil];
}
#pragma mark - 监听上下班时间
- (void)kaishiTime:(NSNotification *)noti
{
    NSString *time = noti.object;
    self.startTime = time;
    [self.tableView reloadData];
}
- (void)endTime:(NSNotification *)noti
{
    NSString *time = noti.object;
    self.endTime = time;
    [self.tableView reloadData];
}
#pragma mark - 表格相关
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 48;
    [self.view addSubview:self.tableView];
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headV.backgroundColor = NorMalBackGroudColor;
    self.tableView.tableHeaderView = headV;
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.textField.placeholder = @"班次名称：如固定班次、早班";
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.textField becomeFirstResponder];
    self.textField.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headV.mas_centerX);
        make.centerY.equalTo(headV.mas_centerY);
        make.left.equalTo(headV.mas_left);
        make.height.equalTo(@40);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}
- (void)clickButton
{
    // 新增班次
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:AddNewBanci_Url,account.userID,self.startTime,self.endTime];

    [self showHudMessage:@"设置中···"];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        KGLog(@"json = %@",responseObject);
        NSString *message = [[responseObject objectForKey:@"message"]description];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        if (code == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 告诉上个界面刷新界面
                [YLNotificationCenter postNotificationName:YLRequestData object:nil];
                [self dismiss];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        } else {
            [self sendErrorWarning:message];
        }
     }fail:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self sendErrorWarning:error.localizedDescription];

    }];
}
#pragma mark - 表格相关
- (NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSArray *array = @[@"上班",@"下班"];
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.textLabel.text = array[indexPath.row];
        cell.contentLabel.text = self.startTime;
        
        return cell;
    }else{
        NSArray *array = @[@"上班",@"下班"];
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.textLabel.text = array[indexPath.row];
        cell.contentLabel.text = self.endTime;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        TimePickerView *pickerV = [TimePickerView sharedTimePickerView];
        pickerV.timeType = StartTime;
        [pickerV setFrame:CGRectMake(0, SCREEN_HEIGHT - 220, SCREEN_WIDTH, 220)];
        [self.view addSubview:pickerV];
    } else {
        TimePickerView *pickerV = [TimePickerView sharedTimePickerView];
        pickerV.timeType = EndTime;
        [pickerV setFrame:CGRectMake(0, SCREEN_HEIGHT - 220, SCREEN_WIDTH, 220)];
        [self.view addSubview:pickerV];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
