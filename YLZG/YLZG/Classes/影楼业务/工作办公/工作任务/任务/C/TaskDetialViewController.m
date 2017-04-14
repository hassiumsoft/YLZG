//
//  TaskDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDetialViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "SelectTaskFuzerController.h"
#import "TaskDetialModel.h"
#import "NormalTableCell.h"
#import "TaskInputView.h"
#import <PDTSimpleCalendarViewController.h>
#import <LCActionSheet.h>
#import "NoDequTableCell.h"
#import "HomeNavigationController.h"
#import "ShowBigImgVController.h"
#import "TaskRecordTableCell.h"
#import "TaskDiscussTableCell.h"


@interface TaskDetialViewController ()<UITableViewDelegate,UITableViewDataSource,PDTSimpleCalendarViewDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) TaskDetialModel *detialModel;
/** 输入框 */
@property (strong,nonatomic) TaskInputView *taskInputView;
/** 线 */
@property (strong,nonatomic) UIImageView *xian1;
@property (strong,nonatomic) UIImageView *xian2;
@property (strong,nonatomic) UIImageView *xian3;

// 切换完成状态的按钮
@property (strong,nonatomic) UIButton *switchButton;
// 任务名称
@property (strong,nonatomic) UILabel *taskNameLabel;
// 任务是否完成的图片
@property (strong,nonatomic) UIImageView *isFinishedImgV;
// 是否关注的星标
@property (strong,nonatomic) UIButton *isGuanzhuBtn;


@end

@implementation TaskDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self getData];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.taskInputView = [[TaskInputView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 50) DidClick:^(NSString *contentStr) {
        [self.view endEditing:YES];
        
        NSString *url = [NSString stringWithFormat:TaskSendContent_Url,[ZCAccountTool account].userID,self.detialModel.pid,1,self.detialModel.id,contentStr];
        [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                NSString *url = [NSString stringWithFormat:TaskDetial_Url,[ZCAccountTool account].userID,self.listModel.id];
                [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    int code = [[[responseObject objectForKey:@"code"] description] intValue];
                    NSString *message = [[responseObject objectForKey:@"message"] description];
                    if (code == 1) {
                        NSDictionary *result = [responseObject objectForKey:@"result"];
                        self.detialModel = [TaskDetialModel mj_objectWithKeyValues:result];
                        [self.tableView reloadData];
                    }else{
                        [self showErrorTips:message];
                    }
                } fail:^(NSURLSessionDataTask *task, NSError *error) {
                    
                    [self sendErrorWarning:error.localizedDescription];
                }];
            }else{
                [self showWarningTips:message];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [self sendErrorWarning:error.localizedDescription];
        }];
    }];
    [self.view addSubview:self.taskInputView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTaskName)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if(section == 1){
        return self.detialModel.dynamic.count;
    }else{
        return self.detialModel.discuss.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 项目详情
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            
            [cell addSubview:self.xian1];
            [self.xian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left);
                make.width.equalTo(@(self.view.width));
                make.height.equalTo(@1);
            }];
            
            // 切换完成状态
            [cell addSubview:self.switchButton];
            
            // 任务名称
            [cell addSubview:self.taskNameLabel];
            // 任务是否完成
            [cell addSubview:self.isFinishedImgV];
            // 是否关注的星标
            [cell addSubview:self.isGuanzhuBtn];
            
            return cell;
        }else if (indexPath.row == 1){
            // 负责人
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = @"负责人";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentLabel.text = self.detialModel.nickname;
            [cell addSubview:self.xian2];
            [self.xian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left);
                make.width.equalTo(@(self.view.width));
                make.height.equalTo(@1);
            }];
            return cell;
        }else if (indexPath.row == 2){
            // 截止日期
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = @"截止日期";
            // 往后推迟一天
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detialModel.deadline];
            NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
            NSString *time = [NSString stringWithFormat:@"%@",nextDay];
            NSString *chooseDate = [time substringWithRange:NSMakeRange(0, 16)];
            cell.contentLabel.text = chooseDate;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell addSubview:self.xian3];
            [self.xian3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left);
                make.width.equalTo(@(self.view.width));
                make.height.equalTo(@1);
            }];
            return cell;
        }else {
            // 检查项
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.text = @"检查项";
            [self addCheckLabes:cell];
            return cell;
        }
    }else if (indexPath.section == 1){
        // 任务记录
        TaskRecordTableCell *cell = [TaskRecordTableCell sharedTaskRecordTableCell:tableView];
        cell.dynamicModel = self.detialModel.dynamic[indexPath.row];
        return cell;
    }else{
        // 项目评论记录
        TaskDiscussTableCell *cell = [TaskDiscussTableCell sharedTaskDiscussCell:tableView];
        TaskDetialDiscussModel *disModel = self.detialModel.discuss[indexPath.row];
        cell.discussModel = disModel;
        cell.DidBlock = ^(NSInteger am_type){
            [self.view endEditing:YES];
            if (am_type == 1) {
                // 查看大图
                
                ShowBigImgVController *show = [ShowBigImgVController new];
                HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:show];
                show.iconStr = disModel.am_uri;
                [self presentViewController:nav animated:NO completion:^{
                    
                }];
                
            }else{
                // 查看文件
                NSArray *itemArr = @[disModel.am_uri];
                UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:itemArr applicationActivities:nil];
                [self presentViewController:activity animated:TRUE completion:nil];
            }
        };
        return cell;
    }
}
#pragma mark - 修改任务状态
- (void)updateTaskStatusWithStatus:(BOOL)status ComPleteBlock:(CompleteBlock)complete
{
    
    if (self.detialModel.status == 1) {
        [self showSuccessTips:@"任务已完成"];
        return;
    }
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"您确定已完成该任务？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [MBProgressHUD showMessage:@"修改中···"];
            NSString *url = [NSString stringWithFormat:UpdateTaskStatus_Url,[ZCAccountTool account].userID,self.detialModel.pid,self.detialModel.id,status];
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideHUD];
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [[responseObject objectForKey:@"message"] description];
                if (code == 1) {
                    [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
                    self.detialModel.status = 1;
                    complete();
                }else{
                    [self sendErrorWarning:message];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [self sendErrorWarning:error.localizedDescription];
            }];
        }
    } otherButtonTitles:@"确定已完成", nil];
    [sheet show];
    
    
}
#pragma mark - 修改截止日期
- (void)updateEndDate:(NSString *)newDateStr Chuo:(NSTimeInterval)NewDealine
{
    NSString *url = [NSString stringWithFormat:UpdateTaskDate_Url,[ZCAccountTool account].userID,self.detialModel.pid,self.detialModel.id,newDateStr];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            // 告诉之前的界面刷新数据
            [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
            self.detialModel.deadline = NewDealine;
            [self.tableView reloadData];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 修改任务名称
- (void)editTaskName
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"编辑任务" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改任务名称" preferredStyle:UIAlertControllerStyleAlert];
            
            // 创建文本框
            [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"如：人像摄影年会";
                textField.secureTextEntry = NO;
            }];
            
            // 创建操作
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 读取文本框的值显示出来
                UITextField *userEmail = alertDialog.textFields.firstObject;
                if (userEmail.text.length > 0) {
                    NSString *newName = userEmail.text;
                    NSString *url = [NSString stringWithFormat:UpdateTaskName_Url,[ZCAccountTool account].userID,self.detialModel.pid,self.detialModel.id,newName];
                    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        [MBProgressHUD hideHUD];
                        int code = [[[responseObject objectForKey:@"code"] description] intValue];
                        NSString *message = [[responseObject objectForKey:@"message"] description];
                        if (code == 1) {
                            // 告诉之前的界面刷新数据
                            [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
                            self.taskNameLabel.text = newName;
                        }else{
                            [self showErrorTips:message];
                        }
                    } fail:^(NSURLSessionDataTask *task, NSError *error) {
                        [self sendErrorWarning:error.localizedDescription];
                    }];
                }
            }];
            
            
            // 添加操作（顺序就是呈现的上下顺序）
            [alertDialog addAction:cancleAction];
            [alertDialog addAction:okAction];
            
            // 呈现警告视图
            [self presentViewController:alertDialog animated:YES completion:nil];
            
        }else if(buttonIndex == 2){
            // 删除任务
            NSString *url = [NSString stringWithFormat:DeleteTask_URL,[ZCAccountTool account].userID,self.detialModel.pid,self.detialModel.id];
            [MBProgressHUD showMessage:@"删除任务中"];
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideHUD];
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 1) {
                    // 告诉之前的界面刷新数据
                    [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self sendErrorWarning:message];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [self sendErrorWarning:error.localizedDescription];
            }];
        }
    } otherButtonTitles:@"修改任务昵称",@"删除任务", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@2];
    [sheet show];
}
#pragma mark - 修改负责人
- (void)updateFuzerMemModel:(ProduceMemberModel *)model
{
    NSString *url = [NSString stringWithFormat:UpdateTaskFuzer_Url,[ZCAccountTool account].userID,self.detialModel.pid,self.detialModel.id,model.uid];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        KGLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            // 告诉之前的界面刷新数据
            [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
            self.detialModel.nickname = model.nickname;
            [self.tableView reloadData];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 懒加载
- (UIButton *)switchButton
{
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setFrame:CGRectMake(15, 10, 30, 30)];
        if (self.detialModel.status) {
            [_switchButton setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
        }else{
            [_switchButton setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        }
        __weak __block TaskDetialViewController *copy_self = self;
        [_switchButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) { //  EditControlSelected
            // 先判断自己是否为负责人
            ZCAccount *account = [ZCAccountTool account];
            if (![account.userID isEqualToString:copy_self.detialModel.uid]) {
                [copy_self sendErrorWarning:@"抱歉，您不是该任务负责人。暂无权修改任务状态。"];
            }else{
                
                [copy_self updateTaskStatusWithStatus:!copy_self.detialModel.status ComPleteBlock:^{
                    if (copy_self.detialModel.status) {
                        // 改为没完成状态
                        copy_self.detialModel.status = 0;
                        [copy_self.switchButton setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
                        [copy_self.isFinishedImgV setImage:[UIImage imageNamed:@"task_unfinished"]];
                    }else{
                        // 改为完成状态
                        copy_self.detialModel.status = 1;
                        [copy_self.switchButton setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
                        [copy_self.isFinishedImgV setImage:[UIImage imageNamed:@"task_isfinished"]];
                    }
                }];
                
            }
        }];
        
        
    }
    return _switchButton;
}
- (UILabel *)taskNameLabel
{
    if (!_taskNameLabel) {
        _taskNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, SCREEN_WIDTH - 50, 30)];
        _taskNameLabel.font = [UIFont systemFontOfSize:15];
        _taskNameLabel.text = self.detialModel.name;
    }
    return _taskNameLabel;
}
- (UIButton *)isGuanzhuBtn
{
    if (!_isGuanzhuBtn) {
        _isGuanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.detialModel.isCare) {
            [_isGuanzhuBtn setImage:[UIImage imageNamed:@"task_isguanzhu"] forState:UIControlStateNormal];
        }else{
            [_isGuanzhuBtn setImage:[UIImage imageNamed:@"task_noguanzhu"] forState:UIControlStateNormal];
        }
        [_isGuanzhuBtn setFrame:CGRectMake(SCREEN_WIDTH - 45, 10, 30, 30)];
        __weak __block TaskDetialViewController *copy_self = self;
        [_isGuanzhuBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            ZCAccount *account = [ZCAccountTool account];
            NSString *url = [NSString stringWithFormat:CareOrNotCareTask_URL,account.userID,copy_self.detialModel.pid,copy_self.detialModel.id,!copy_self.detialModel.isCare];
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"responseObject = %@",responseObject);
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [[responseObject objectForKey:@"message"] description];
                if (code == 1) {
                    [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
                    if (copy_self.detialModel.isCare) {
                        [copy_self.isGuanzhuBtn setImage:[UIImage imageNamed:@"task_noguanzhu"] forState:UIControlStateNormal];
                    }else{
                        [copy_self.isGuanzhuBtn setImage:[UIImage imageNamed:@"task_isguanzhu"] forState:UIControlStateNormal];
                    }
                }else{
                    [copy_self showErrorTips:message];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [copy_self sendErrorWarning:error.localizedDescription];
            }];
            
        }];
    }
    return _isGuanzhuBtn;
}
- (UIImageView *)isFinishedImgV
{
    if (!_isFinishedImgV) {
        _isFinishedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 5, 70, 70)];
        if (self.detialModel.status) {
            [_isFinishedImgV setImage:[UIImage imageNamed:@"task_isfinished"]];
        }else{
            [_isFinishedImgV setImage:[UIImage imageNamed:@"task_unfinished"]];
        }
    }
    return _isFinishedImgV;
}
- (UIImageView *)xian1
{
    if (!_xian1) {
        _xian1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    }
    return _xian1;
}
- (UIImageView *)xian2
{
    if (!_xian2) {
        _xian2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    }
    return _xian2;
}
- (UIImageView *)xian3
{
    if (!_xian3) {
        _xian3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    }
    return _xian3;
}
#pragma mark - 表格其他方法
- (void)addCheckLabes:(NormalTableCell *)cell
{
    
    CGFloat X = 80;
    for (int i = 0; i < self.detialModel.check.count; i++) {
        
        TaskDetialCheckModel *checkModel = self.detialModel.check[i];
        NSString *checkStr = checkModel.content;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]};
        CGFloat W = [checkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        W = W + 25;
        UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, 8, W, 25)];
        checkLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        checkLabel.text = checkStr;
        checkLabel.textAlignment = NSTextAlignmentCenter;
        checkLabel.layer.masksToBounds = YES;
        checkLabel.layer.cornerRadius = 2;
        checkLabel.backgroundColor = HWRandomColor;
        checkLabel.textColor = [UIColor whiteColor];
        [cell addSubview:checkLabel];
        X = X + W;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            // 修改负责人
            if (self.detialModel.status == 1) {
                
                return;
            }
            SelectTaskFuzerController *select = [SelectTaskFuzerController new];
            select.title = @"修改负责人";
            select.SelectBlock = ^(ProduceMemberModel *model){
                // 调用修改接口
                [self updateFuzerMemModel:model];
            };
            select.produceID = self.detialModel.pid;
            [self.navigationController pushViewController:select animated:YES];
        }else if (indexPath.row == 2){
            // 修改截止日期
            if (self.detialModel.status == 1) {
                
                return;
            }
            PDTSimpleCalendarViewController *calendar = [PDTSimpleCalendarViewController new];
            calendar.title = @"修改任务截止日期";
            calendar.delegate = self;
            calendar.overlayTextColor = MainColor;
            calendar.weekdayHeaderEnabled = YES;
            calendar.firstDate = [NSDate date];
            calendar.lastDate = [NSDate dateWithHoursFromNow:2*30*24]; // 8个月
            
            [self.navigationController pushViewController:calendar animated:YES];
        }else {
            
        }
    }
}
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *chooseDate = [time substringWithRange:NSMakeRange(0, 10)];
    
    NSTimeInterval timeInterVal = [nextDay timeIntervalSince1970];
    
    // 修改截止日期
    [self updateEndDate:chooseDate Chuo:timeInterVal];
    [controller.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 任务详情
            return 80;
        }else if (indexPath.row == 1){
            // 负责人
            return 44;
        }else if (indexPath.row == 2){
            // 截止日期
            return 44;
        }else {
            // 检查项
            return 44;
        }
    }else if (indexPath.section == 1){
        return 24;
    }else {
        TaskDetialDiscussModel *disModel = self.detialModel.discuss[indexPath.row];
        if (disModel.am_type == 0) {
            // 没有附件
            return 60;
        }else if (disModel.am_type == 1){
            // 附件是图片
            return 150;
        }else {
            // 附件是文件
            return 150;
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // 任务详细
        return 28;
    }else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // 任务详情
        
        // --项目名称
        NSString *proStr = [NSString stringWithFormat:@"项目：%@",self.detialModel.project];
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 28)];
        headV.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
        label.text = proStr;
        label.font = [UIFont systemFontOfSize:14];
        [headV addSubview:label];
        
        // --多少人关注
        UILabel *guanzhuL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 65, 30)];
        guanzhuL.text = [NSString stringWithFormat:@"%ld人关注",(unsigned long)self.detialModel.care.count];
        guanzhuL.textColor = [UIColor grayColor];
        guanzhuL.font = label.font;
        [headV addSubview:guanzhuL];
        
        return headV;
    }else{
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)getData
{
    NSString *url = [NSString stringWithFormat:TaskDetial_Url,[ZCAccountTool account].userID,self.listModel.id];
    [MBProgressHUD showMessage:@"正在加载···"];
    KGLog(@"任务详情url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.detialModel = [TaskDetialModel mj_objectWithKeyValues:result];
            [self setupSubViews];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

@end
