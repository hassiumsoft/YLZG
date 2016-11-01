//
//  GudingBanciVController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GudingBanciVController.h"
#import "EditPaibanTableCell.h"
#import "NormalTableCell.h"
#import "ChooseBanciVController.h"
#import "GudingPaibanModel.h"
#import "AddNewBanciController.h"
#import "HomeNavigationController.h"
#import <MJExtension.h>
#import <Masonry.h>

@interface GudingBanciVController ()<UITableViewDelegate,UITableViewDataSource,EditPaibanTableCellDelegate,ChooseBanciDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

/** 底部View */
@property (strong,nonatomic) UIView *footView;

/** 批量设置的班次名称 */
@property (strong,nonatomic) UILabel *piliangBanci;
/** 批量设置的上下班时间 */
@property (strong,nonatomic) UILabel *piliangTime;

/** 需要传递的数组 */
@property (strong,nonatomic) NSMutableArray *resultArray;


@end

@implementation GudingBanciVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"固定班制时间";
    [self setupSubViews];
}

- (void)setupSubViews
{
    NSArray *weakArray = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    for (int i = 0; i < 7; i++) {
        GudingPaibanModel *model = [[GudingPaibanModel alloc]init];
        model.week = weakArray[i];
        model.classid = @"";
        model.isSelected = NO;
        model.classname = @"";
        model.start = @"";
        model.end = @"";
        
        [self.array addObject:model];
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 44;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footView;
    
}

#pragma mark - 表格相关
- (NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        // 批量班次AAA？
        cell.textLabel.text = @"一键设置班制";
        [cell addSubview:self.piliangBanci];
        [self.piliangBanci mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.centerX.equalTo(cell.mas_left).offset(SCREEN_WIDTH/2);
            make.height.equalTo(@21);
        }];
        // 批量班次时间
        [cell addSubview:self.piliangTime];
        [self.piliangTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-30);
            make.height.equalTo(@21);
        }];
        return cell;
    }else{
        EditPaibanTableCell *cell = [EditPaibanTableCell sharedEditPaibanTableCell:tableView];
        cell.delegate = self;
        GudingPaibanModel *model = self.array[indexPath.row];
        cell.model = model;
        model.index = indexPath.row;
        return cell;
    }
    
}
#pragma mark - 排班的代理
- (void)editPaibanCellWithModel:(GudingPaibanModel *)model
{
    [self.array replaceObjectAtIndex:model.index withObject:model];
    
    [self.tableView reloadData];
    
}
#pragma mark - 保存
- (void)saveAction
{
    
    for (GudingPaibanModel *model in self.array) {
        if (!model.isSelected) {
            model.start = @"";
            model.end = @"";
            model.classname = @"";
            model.classid = @"";
        }
        NSDictionary *dict = [model mj_keyValues];
        [self.resultArray addObject:dict];
    }
    NSString *jsonStr = [self toJsonStr:self.resultArray];
    // 传给上个界面
    if ([self.delegate respondsToSelector:@selector(gudingbanciWithJsonStr:WithModelArray:)]) {
        [self.delegate gudingbanciWithJsonStr:jsonStr WithModelArray:self.array];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ChooseBanciVController *chooseBanci = [ChooseBanciVController new];
        chooseBanci.type = @"1"; // 固定班制
        chooseBanci.delegate = self;
        [self.navigationController pushViewController:chooseBanci animated:YES];
    }
    
}

- (void)chooseMoreBanciWithArray:(NSArray *)modelAray
{
    
}

#pragma mark - 固定班次的回调
- (void)chooseOneBanciWithModel:(BanciModel *)model
{
    self.piliangTime.text = [NSString stringWithFormat:@"%@-%@",model.start,model.end];
    self.piliangBanci.text = model.classname;
    
    [self.array removeAllObjects];
    
    NSArray *weakArray = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    
    for (int i = 0; i < 7; i++) {
        GudingPaibanModel *gudingModel = [GudingPaibanModel new];
        gudingModel.classname = model.classname;
        gudingModel.classid = model.classid;
        gudingModel.week = weakArray[i];
        gudingModel.start = model.start;
        gudingModel.end = model.end;
        gudingModel.isSelected = YES;
        [self.array addObject:gudingModel];
    }
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectZero];
    head.backgroundColor = self.view.backgroundColor;
    return head;
}

#pragma mark - 懒加载
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (UILabel *)piliangBanci
{
    if (!_piliangBanci) {
        _piliangBanci = [[UILabel alloc]init];
        _piliangBanci.textAlignment = NSTextAlignmentCenter;
        _piliangBanci.textColor = [UIColor grayColor];
        _piliangBanci.font = [UIFont systemFontOfSize:14];
        
    }
    return _piliangBanci;
}

- (UILabel *)piliangTime
{
    if (!_piliangTime) {
        _piliangTime = [[UILabel alloc]init];
        _piliangTime.text = @"";
        _piliangTime.textColor = [UIColor lightGrayColor];
        _piliangTime.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
    return _piliangTime;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44*8 - 8 * 2 - 12 - 64)];
        _footView.backgroundColor = self.view.backgroundColor;
        _footView.userInteractionEnabled = YES;
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(20, SCREEN_HEIGHT - 44*8 - 8 * 2 - 12 - 64 - 55, SCREEN_WIDTH - 40, 38)];
        button.layer.cornerRadius = 4;
        button.backgroundColor = MainColor;
        [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"保 存" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [_footView addSubview:button];
    }
    return _footView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc]init];
    }
    return _resultArray;
}



@end
