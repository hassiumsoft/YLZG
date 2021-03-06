//
//  ProduceDiscussVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDiscussVController.h"
#import "ProduceDiscussModel.h"
#import "NormalIconView.h"
#import "ProduceDetialDiscussCell.h"
#import <Masonry.h>

@interface ProduceDiscussVController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;


@end

@implementation ProduceDiscussVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讨论";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.discussArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProduceDiscussModel *model = self.discussArray[indexPath.row];
    ProduceDetialDiscussCell *cell = [ProduceDetialDiscussCell sharedDetialDiscussCell:tableView];
    cell.discussModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [[UIView alloc]init];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

- (void)createEmptyView:(NSString *)message
{
    
    // 全部为空值
    NormalIconView *emptyBtn = [NormalIconView sharedHomeIconView];
    emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    emptyBtn.label.text = message;
    emptyBtn.label.numberOfLines = 0;
    emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyBtn];
    
    
    [emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}

- (void)setDiscussArray:(NSArray *)discussArray
{
    _discussArray = discussArray;
    if (discussArray.count >= 1) {
        [self.tableView reloadData];
    }else{
        [self createEmptyView:@"暂无讨论"];
    }
}
@end
