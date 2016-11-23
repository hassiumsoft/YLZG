//
//  TaskProductsController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskProductsController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import "TaskProduceListModel.h"
#import <MJExtension.h>
#import "ProduceDetialVController.h"
#import "TaskProductTableCell.h"
#import <LCActionSheet.h>
#import "AddNewTaskProController.h"

@interface TaskProductsController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@property (strong,nonatomic) UIView *createView;

@end

@implementation TaskProductsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影楼项目";
    [self setupSubViews];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)loadData
{
    NSString *url = [NSString stringWithFormat:TaskProductList_URL,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (result.count >= 1) {
                self.array = [TaskProduceListModel mj_objectArrayWithKeyValuesArray:result];
                [self.tableView reloadData];
            }else{
                [self showErrorTips:@"您暂未参与任何项目"];
            }
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
    }];
}
- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.createView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskProductTableCell *cell = [TaskProductTableCell sharedTaskProductCell:tableView];
    cell.proModel = self.array[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProduceDetialVController *detial = [ProduceDetialVController new];
    detial.listModel = self.array[indexPath.section];
    [self.navigationController pushViewController:detial animated:YES];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.row == 0) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定删除该项目？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self deleteProduce:indexPath];
                }
            } otherButtonTitles:@"确定删除!", nil];
            sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
            [sheet show];
        }
    }];
    action.backgroundColor = WechatRedColor;
    return @[action];
}
- (void)deleteProduce:(NSIndexPath *)indexPath
{
    // 删除项目
    TaskProduceListModel *model = self.array[indexPath.section];
    NSString *url = [NSString stringWithFormat:DeleteTaskProduce_Url,[ZCAccountTool account].userID,model.id];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self.array removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (UIView *)createView
{
    if (!_createView) {
        
        CGFloat margin = 10;
        CGFloat headH = 60;
        _createView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.width, headH)];
        _createView.userInteractionEnabled = YES;
        _createView.backgroundColor = self.view.backgroundColor;
        
        CGFloat imageH = 3*margin;
        CGFloat imageW = 3*margin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*margin, (headH - imageH)/2, imageW, imageH)];
        imageView.image = [UIImage imageNamed:@"btn_xiangmu_lan"];
        [_createView addSubview:imageView];
        
        
        CGFloat newLabelX = CGRectGetMaxX(imageView.frame) + 20;
        CGFloat newLabelH = 4*margin;
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, (headH - newLabelH)/2, SCREEN_WIDTH -newLabelX, newLabelH) ];
        newLabel.text = @"新建项目";
        newLabel.adjustsFontSizeToFitWidth = YES;
        newLabel.font = [UIFont systemFontOfSize:14];
        newLabel.textColor = MainColor;
        [_createView addSubview:newLabel];
        
        UIImageView *addImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_tianjia_lan"]];
        [_createView addSubview:addImageV];
        [addImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_createView.mas_centerY);
            make.right.equalTo(_createView.mas_right).offset(-18);
            make.width.and.height.equalTo(@23);
        }];
        
        /**添加手势*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            AddNewTaskProController *add = [AddNewTaskProController new];
            add.ReloadDataBlock = ^(){
                [self loadData];
            };
            [self.navigationController pushViewController:add animated:YES];
        }];
        [_createView addGestureRecognizer:tap];
    }
    return _createView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}

@end
