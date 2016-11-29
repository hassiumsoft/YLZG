//
//  AddNewTaskController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddNewTaskController.h"
#import "NormalTableCell.h"
#import <PDTSimpleCalendarViewController.h>
#import <Masonry.h>
#import "ZCAccountTool.h"
#import "SelectTaskCaresController.h"
#import "SelectTaskFuzerController.h"
#import "ChooseProduceController.h"
#import "NoDequTableCell.h"
#import "HTTPManager.h"

@interface AddNewTaskController ()<UITableViewDelegate,UITableViewDataSource,PDTSimpleCalendarViewDelegate>

{
    int HuanHang;
}

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 输入任务名称 */
@property (strong,nonatomic) UITextField *nameField;
/** 任务描述 */
@property (strong,nonatomic) YYTextView *taskDescField;
/** 创建按钮 */
@property (strong,nonatomic) UIButton *button;
/** 设置检查项 */
@property (strong,nonatomic) UILabel *checkLabel;
/** 添加检查项 */
@property (strong,nonatomic) UIView *addView;

/** 检查项数组 */
@property (strong,nonatomic) NSMutableArray *checkArray;

/** 截止日期 */
@property (copy,nonatomic) NSString *endDateStr;
/** 选择的项目 */
@property (copy,nonatomic) NSString *selectProduceStr;
@property (copy,nonatomic) NSString *produceID;
/** 负责人 */
@property (copy,nonatomic) NSString *fuzerStr;
@property (copy,nonatomic) NSString *fuzerID;
/** 关注的人 */
@property (copy,nonatomic) NSString *guanzhuerStr;
@property (copy,nonatomic) NSString *guanzhuArrJson;



@end

@implementation AddNewTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建任务";
    [self setupSubViews];
}
#pragma mark - 绘制表格
- (void)setupSubViews
{
    HuanHang = 1;
    self.selectProduceStr = @" ";
    self.endDateStr = @" ";
    self.fuzerStr = @" ";
    self.guanzhuArrJson = @" ";
    self.guanzhuerStr = @" ";
    self.array = @[@[@"输入任务名称*"],@[@"选择项目*",@"选择负责人*",@"截止日期*",@"添加关注人"],@[@"任务描述"],@[@"设置检查项"],@[@"创建任务"]];
    [self.view addSubview:self.tableView];
    
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
        // 第一行
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        // 第二行
        NSArray *iconArr = @[@"ico_xianjian_xiangmu",@"ico_xianjian_fuzeren",@"ico_xianjian_shijian",@"ico_xianjian_weiguanzhu"];
        NSArray *contentArr = @[self.selectProduceStr,self.fuzerStr,self.endDateStr,self.guanzhuerStr];
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.imageView.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        cell.contentLabel.text = contentArr[indexPath.row];
        
        return cell;
    }else if(indexPath.section == 2){
        // 任务描述
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell addSubview:self.taskDescField];
        return cell;
    }else if (indexPath.section == 3){
        
        // 设置检查项
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.checkLabel];
        self.checkLabel.text = self.array[indexPath.section][indexPath.row];
        
        [cell.contentView addSubview:self.addView];
        [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.height.equalTo(@30);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
        }];
        
        [self setupSubButtons:cell];
        
        return cell;
    }else{
        // 创建任务按钮
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor = self.view.backgroundColor;
        [cell addSubview:self.button];
        return cell;
        
    }
}
- (void)setupSubButtons:(UITableViewCell *)cell
{
    CGFloat W = 0; // 保存前一个button的宽以及前一个button距离边沿的距离
    CGFloat H = 28; // 用来约束控制button距离父控件视图的高
    for (int i = 0; i < self.checkArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        NSString *title = self.checkArray[i];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15 * CKproportion];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.backgroundColor = HWRandomColor;
        
        // 计算大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]};
        CGFloat length = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        
        // 设置button的坐标
        button.frame = CGRectMake(W + 15, H, length + 20*CKproportion, 25);
        if(W + 10 + length + 10 > SCREEN_WIDTH - 30){
            HuanHang++;
            W = 0; //换行时将w置为0
            H = H + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(W + 10, H, length + 20*CKproportion, 25);//重设button的frame
        }
        
        W = button.frame.size.width + button.frame.origin.x;
        [cell addSubview:button];
        CGRect rect = cell.frame;
        rect.size.height = H + 30;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 选择项目
            ChooseProduceController *choose = [ChooseProduceController new];
            choose.DidSelectBlock = ^(TaskProduceListModel *model){
                self.selectProduceStr = model.name;
                self.produceID = model.id;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.row == 1){
            // 选择负责人--必选先选中项目
            if (self.produceID.length < 1) {
                [self showErrorTips:@"请先选择项目"];
                return;
            }
            SelectTaskFuzerController *select = [SelectTaskFuzerController new];
            select.produceID = self.produceID;
            select.title = @"任务负责人";
            select.SelectBlock = ^(ProduceMemberModel *model){
                self.fuzerStr = model.nickname;
                self.fuzerID = model.uid;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:select animated:YES];
        }else if (indexPath.row == 2){
            // 截止日期
            // 选择时间
            PDTSimpleCalendarViewController *calendar = [PDTSimpleCalendarViewController new];
            calendar.title = @"任务截止日期";
            calendar.delegate = self;
            calendar.overlayTextColor = MainColor;
            calendar.weekdayHeaderEnabled = YES;
            calendar.firstDate = [NSDate date];
            calendar.lastDate = [NSDate dateWithHoursFromNow:2*30*24]; // 8个月
            
            [self.navigationController pushViewController:calendar animated:YES];
        }else {
            // 添加关注人
            SelectTaskCaresController *care = [SelectTaskCaresController new];
            care.title = @"添加关注的人";
            care.SelectBlock = ^(NSArray *modelArray){
                NSMutableArray *jsonArr = [NSMutableArray array];
                for (StaffInfoModel *model in modelArray) {
                    [jsonArr addObject:model.uid];
                }
                self.guanzhuArrJson = [self toJsonStr:jsonArr];
                StaffInfoModel *lastModel = [modelArray lastObject];
                self.guanzhuerStr = [NSString stringWithFormat:@"%@等%ld人",lastModel.nickname,modelArray.count];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:care animated:YES];
        }
    }
}
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *chooseDate = [time substringWithRange:NSMakeRange(0, 10)];
    self.endDateStr = chooseDate;
    [self.tableView reloadData];
    [controller.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<=2) {
        return 48;
    }else if(indexPath.section == 3){
        // 检查项
        return 25 + 30 + HuanHang * 30;
    }else{
        // 按钮
        return 150;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)addNewTask
{
    // http://192.168.0.18/index.php/home/task/create?uid=159&pid=1&name=任务名称&manager=159&deadline=2016-11-22&check=[“检查项1”,”检查项2”]&care=[“130”,”131”,”129”]&description=任务描述
    if ((self.nameField.text.length < 1) || (self.selectProduceStr.length < 1) || (self.endDateStr.length < 1)){
        [self showErrorTips:@"完善带*选项"];
        return;
    }
    
    NSString *checkStr;
    if (self.checkArray.count) {
        checkStr = [self toJsonStr:self.checkArray];
    }else{
        checkStr = @"";
    }
    NSString *url = [NSString stringWithFormat:CreateNewTask_Url,[ZCAccountTool account].userID,self.produceID,self.nameField.text,self.fuzerID,self.endDateStr,checkStr,self.guanzhuArrJson,self.taskDescField.text];
    [self showHudMessage:@"创建中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud:0];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (status == 1) {
            
            [YLNotificationCenter postNotificationName:TaskReloadData object:nil];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self showHudMessage:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 17, 48)];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.placeholder = @"输入任务名称*";
        _nameField.font = [UIFont systemFontOfSize:15];
    }
    return _nameField;
}
- (UILabel *)checkLabel
{
    if (!_checkLabel) {
        _checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 21)];
        _checkLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
    }
    return _checkLabel;
}
- (UIView *)addView
{
    if (!_addView) {
        _addView = [[UIView alloc]init];
        _addView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
            // 添加检查项
            // 初始化
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"添加检查项以监督任务" preferredStyle:UIAlertControllerStyleAlert];
            
            // 创建文本框
            [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"如：使用AI修图";
                textField.secureTextEntry = NO;
            }];
            
            // 创建操作
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 读取文本框的值显示出来
                UITextField *userEmail = alertDialog.textFields.firstObject;
                if (userEmail.text.length > 0) {
                    [self.checkArray addObject:userEmail.text];
                    [self.tableView reloadData];
                }
            }];
            
            
            // 添加操作（顺序就是呈现的上下顺序）
            [alertDialog addAction:cancleAction];
            [alertDialog addAction:okAction];
            
            // 呈现警告视图  
            [self presentViewController:alertDialog animated:YES completion:nil];
        }];
        [_addView addGestureRecognizer:tap];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 15, 30)];
        label.text = @"➕ 添加检查项";
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        label.textColor = [UIColor grayColor];
        [_addView addSubview:label];
    }
    return _addView;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(25, 100, self.view.width - 50, 40)];
        [_button setTitle:@"创建任务" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(addNewTask) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundColor:MainColor];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 4;
    }
    return _button;
}
- (YYTextView *)taskDescField
{
    if (!_taskDescField) {
        _taskDescField = [[YYTextView alloc]initWithFrame:CGRectMake(100, 7, self.view.width - 100 - 15, 42)];
        _taskDescField.backgroundColor = [UIColor clearColor];
        _taskDescField.font = [UIFont systemFontOfSize:14];
//        _taskDescField.placeholderText = @"非必填";
    }
    return _taskDescField;
}
- (NSMutableArray *)checkArray
{
    if (!_checkArray) {
        _checkArray = [NSMutableArray array];
    }
    return _checkArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 48;
        _tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        
    }
    return _tableView;
}

@end
