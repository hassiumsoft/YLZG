//
//  YejiDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YejiDetialViewController.h"
#import "YejiTableViewCell.h"
#import <Masonry.h>


@interface YejiDetialViewController ()<UITableViewDelegate,UITableViewDataSource>


/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 空图 */
@property (strong,nonatomic) UIImageView *emptyImageV;

@end

@implementation YejiDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffYejiModel *model = self.array[indexPath.row];
    model.rank = (int)(indexPath.row) + 1;
    YejiTableViewCell *cell = [YejiTableViewCell sharedYejiTableViewCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)setArray:(NSArray *)array
{
    _array = array;
    if (array.count >= 1) {
        [self.view addSubview:self.tableView];
        [self.emptyImageV removeFromSuperview];
        [self.tableView reloadData];
    }else{
        [self.tableView removeFromSuperview];
        
        [self.view addSubview:self.emptyImageV];
        [self.emptyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(@180);
            make.height.equalTo(@200);
        }];
    }
    
}

- (UIImageView *)emptyImageV
{
    if (!_emptyImageV) {
        _emptyImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_icon"]];
    }
    return _emptyImageV;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

@end
