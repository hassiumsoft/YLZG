//
//  CaiwuDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CaiwuDetialViewController.h"
#import "CaiwuDetialCell.h"
#import <Masonry.h>
#import "NormalIconView.h"


@interface CaiwuDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation CaiwuDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.type;
    if (self.model.list.count >= 1) {
        [self.view addSubview:self.tableView];
    }else{
        [self loadEmptyView:@"还没有该项数据"];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaiwuDetialCell *cell = [CaiwuDetialCell sharedCaiwuDetialCell:tableView];
    cell.model = self.model.list[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}
#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"happyness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(209, 40, 123, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
        make.height.equalTo(@45);
    }];
}

@end
