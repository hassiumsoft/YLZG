//
//  PaizhaoPreViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PaizhaoPreViewController.h"
#import <Masonry.h>
#import "ShekongbenCell.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NormalIconView.h"
#import "ShekongbenModel.h"
#import "ShekongDetialVController.h"

@interface PaizhaoPreViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 数组 */
@property (strong,nonatomic) NSMutableArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

/** 空图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;


@end

@implementation PaizhaoPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
#pragma mark - 获取数据
- (void)loadDataWithDate:(NSString *)dateStr
{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData:dateStr];
    }];
    [self.tableView.mj_header beginRefreshing];
    if (self.array.count < 1) {
        [self refreshData:dateStr];
    }
}

- (void)refreshData:(NSString *)dateStr
{
    NSString *url = [NSString stringWithFormat:Shekongben_Url,dateStr,(int)self.index,[ZCAccountTool account].userID];
    KGLog(@"拍照url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        // NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            NSArray *array = [responseObject objectForKey:@"result"];
            if (array.count >= 1) {
                [self.array removeAllObjects];
                self.array = [ShekongbenModel mj_objectArrayWithKeyValuesArray:array];
                [self.emptyBtn removeFromSuperview];
                [self.view addSubview:self.tableView];
                [self.tableView reloadData];
                UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                footLabel.text = @"💡您可以通过日历选择日期查看\r影楼未来30天内的预约数量";
                footLabel.numberOfLines = 2;
                footLabel.backgroundColor = NorMalBackGroudColor;
                footLabel.textAlignment = NSTextAlignmentCenter;
                footLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                footLabel.textColor = RGBACOLOR(67, 67, 67, 1);
                _tableView.tableFooterView = footLabel;
            }else{
                [self.array removeAllObjects];
                [self.tableView reloadData];
                [self loadEmptyView:@"当天无拍照预约"];
            }
        }else{
            [self.array removeAllObjects];
            [self.tableView reloadData];
            [self loadEmptyView:@"当天无拍照预约"];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.array removeAllObjects];
        [self.tableView reloadData];
        [self loadEmptyView:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
//    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShekongbenModel *model = self.array[indexPath.row];
    ShekongbenCell *cell = [ShekongbenCell sharedShekongbenCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShekongDetialVController *shekongdetial = [ShekongDetialVController new];
    shekongdetial.model = self.array[indexPath.row];
    [self.navigationController pushViewController:shekongdetial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
//    CATransition *animation = [CATransition animation];
//    animation.duration = 2.f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"rippleEffect";
//    animation.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn = [NormalIconView sharedHomeIconView];
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.numberOfLines = 0;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.emptyBtn];
    
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -52, SCREEN_WIDTH, self.view.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = self.view.backgroundColor;
        
        
        
    }
    return _tableView;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

@end
