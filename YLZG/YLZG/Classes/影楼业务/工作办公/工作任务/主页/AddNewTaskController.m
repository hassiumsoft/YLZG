//
//  AddNewTaskController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddNewTaskController.h"
#import "NormalTableCell.h"
#import "HTTPManager.h"

@interface AddNewTaskController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 输入任务名称 */
@property (strong,nonatomic) UITextField *nameField;


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
    self.array = @[@[@"输入任务名称"],@[@"选择项目",@"选择负责人",@"设置截止日期",@"添加关注人"],@[@"任务描述"],@[@"设置检查项"],@[@"创建任务"]];
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
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        cell.imageView.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        
        return cell;
    }else {
        // 第三行
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
}

#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 17, 48)];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.placeholder = @"输入任务名称";
        _nameField.font = [UIFont systemFontOfSize:15];
    }
    return _nameField;
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
