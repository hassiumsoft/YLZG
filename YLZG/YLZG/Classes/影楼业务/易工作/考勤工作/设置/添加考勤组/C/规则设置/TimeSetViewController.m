//
//  TimeSetViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/13.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "TimeSetViewController.h"
#import "NormalTableCell.h"
#import "GudingBanciVController.h"


@interface TimeSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;


@end

@implementation TimeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择班次";
    // 先获取有没有已经设置好的班次。没有则添加
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == self.array.count) {
        // 最后一行、添加事件
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = @"新增班次";
        cell.imageView.image = [UIImage imageNamed:@"check_addwifi"];
//        cell.imageView.backgroundColor = HWRandomColor;
        return cell;
    }else{
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.array.count) {
        GudingBanciVController *paiban = [GudingBanciVController new];
        [self.navigationController pushViewController:paiban animated:YES];
    }
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
