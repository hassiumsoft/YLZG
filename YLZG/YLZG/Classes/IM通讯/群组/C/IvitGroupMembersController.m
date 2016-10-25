//
//  IvitGroupMembersController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IvitGroupMembersController.h"
#import "HuanxinContactManager.h"
#import "StudioContactManager.h"
#import "IvitMembersTableCell.h"



@interface IvitGroupMembersController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 选中的 */
@property (strong,nonatomic) NSMutableArray *selectArray;

@end

@implementation IvitGroupMembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请成员";
    
    [self setupSubViews];

}
- (void)setupSubViews
{
//    NSArray *huanxinArr = [HuanxinContactManager getAllHuanxinContactsInfo];
    NSArray *studioArr = [StudioContactManager getAllStudiosContactsInfo];
    for (int i = 0; i < studioArr.count; i++) {
        ColleaguesModel *collegus = studioArr[i];
        for (int j = 0; j < collegus.member.count; j++) {
            ContactersModel *model = collegus.member[j];
            [self.array addObject:model];
        }
    }
    
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactersModel *model = self.array[indexPath.row];
    IvitMembersTableCell *cell = [IvitMembersTableCell sharedIvitMembersTableCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactersModel *model = self.array[indexPath.row];
    if (model.isSelected) {
        model.isSelected = NO;
        [self.array replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
        [self.selectArray removeObject:model];
    }else{
        model.isSelected = YES;
        [self.tableView reloadData];
        [self.selectArray addObject:model];
    }
    
    [self setupRightBar:self.selectArray];
    
}
- (void)setupRightBar:(NSArray *)memberArr
{
    NSString *members = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)memberArr.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:members style:UIBarButtonItemStylePlain target:self action:@selector(kkkkkk)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
- (void)kkkkkk
{
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < self.selectArray.count; i++) {
        ContactersModel *model = self.selectArray[i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = model.name;
        dict[@"sid"] = model.sid;
        dict[@"uid"] = model.uid;
        [resultArr addObject:dict];
    }
    if (_MemebersBlock) {
        _MemebersBlock(resultArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

@end
