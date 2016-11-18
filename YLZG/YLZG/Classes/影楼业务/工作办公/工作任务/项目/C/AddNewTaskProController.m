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
#import "AddMemberView.h"
#import "NormalTableCell.h"


@interface AddNewTaskProController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) AddMemberView *headView;

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *memberArr;

@end

@implementation AddNewTaskProController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加新项目";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
}
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
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        
        return cell;
    }else if (indexPath.section == 1){
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        return cell;
    }else {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        return cell;
    }
}
- (AddMemberView *)headView
{
    if (!_headView) {
        CGFloat cellW = (SCREEN_WIDTH - 3 * 2)/4;
        _headView = [[AddMemberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2 * cellW + 2)]; // 186.5
        _headView.memberArr = self.memberArr;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.userInteractionEnabled = YES;
        
        UIView *bottomV = [[UIView alloc]init];
        bottomV.backgroundColor = self.view.backgroundColor;
        [_headView addSubview:bottomV];
        [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView.mas_left);
            make.right.equalTo(_headView.mas_right);
            make.height.equalTo(@5);
            make.bottom.equalTo(_headView.mas_bottom);
        }];
        
    }
    return _headView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
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
