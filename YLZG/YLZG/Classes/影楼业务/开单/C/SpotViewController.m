//
//  SpotViewController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SpotViewController.h"
#import "MutableSpotTableCell.h"
#import "ZCAccountTool.h"
#import "SVProgressHUD.h"
#import "MutableSelectedModel.h"
#import "HTTPManager.h"


@interface SpotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@property (strong,nonatomic) NSMutableArray *selectArray;

@end

@implementation SpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择风景";
    [self loadData];
    [self setupSubViews];
    
}

- (void)loadData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SearchSpot_Url,account.userID];
    [self showHudMessage:@"加载中···"];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self hideHud:0];
        if (code == 1) {
            NSArray *tempArray = [responseObject objectForKey:@"spot"];
            for (int i = 0; i < tempArray.count; i++) {
                MutableSelectedModel *model = [MutableSelectedModel new];
                model.isSelected = NO;
                model.title = tempArray[i];
                [self.array addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MutableSpotTableCell *cell = [MutableSpotTableCell sharedMutableSpotTableCell:tableView];
    MutableSelectedModel *model = self.array[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MutableSelectedModel *model = self.array[indexPath.row];
    if (!model.isSelected) {
        for (int i = 0; i < self.array.count; i++) {
            if (i == indexPath.row) {
                MutableSelectedModel *mm = self.array[i];
                mm.isSelected = YES;
                [self.array replaceObjectAtIndex:indexPath.row withObject:mm];
                [self.tableView reloadData];
                
                [self.selectArray addObject:mm.title];
                
                [self setupNav:self.selectArray];
            }
        }
    }
    
}
- (void)setupNav:(NSMutableArray *)array
{
    
    NSString *title;
    if (self.selectArray.count > 0) {
        title = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectArray.count];
    }else{
        title = @"确定";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
#pragma mark - 完成回调
- (void)doneAction
{
    if (self.selectArray.count < 1) {
        [self showErrorTips:@"请选择拍摄景点"];
        return;
    }
    NSString *place;
    if (self.selectArray.count == 1) {
        place = [self.selectArray firstObject];
    }else{
        place = [NSString stringWithFormat:@"%@等%d景",[self.selectArray firstObject],(int)self.selectArray.count];
    }
    
    KGLog(@"place = %@",place);
    NSString *spotStr = [self toJsonStr:self.selectArray];
    
    if ([self.delegate respondsToSelector:@selector(spotSelectWithSpotJson:PlaceStr:)]) {
        [self.delegate spotSelectWithSpotJson:spotStr PlaceStr:place];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.rowHeight = 48;
    }
    return _tableView;
}
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}


@end
