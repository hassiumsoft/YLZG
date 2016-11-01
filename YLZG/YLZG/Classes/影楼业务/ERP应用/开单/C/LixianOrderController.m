//
//  LixianOrderController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/20.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "LixianOrderController.h"
#import "OfflineDataManager.h"
#import "OffLineOrder.h"
#import "OfflineOrderTableCell.h"
#import <LCActionSheet.h>
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "HTTPManager.h"
#import "NormalIconView.h"

@interface LixianOrderController ()<UITableViewDataSource,UITableViewDelegate,LCActionSheetDelegate,OfflineOrderCellDelegate>

{
    BOOL isAllSelected;
}

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 孔图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;
/** 底部左图 */
@property (strong,nonatomic) UIView *leftBottomV;
/** 底部右图 */
@property (strong,nonatomic) UIView *rightBottomV;

/** 是否全选的按钮 */
@property (strong,nonatomic) UIButton *allButton;

/**
 *  判断是否为全选
 */
@property (strong,nonatomic) NSMutableArray *selectedArr;
@property (strong,nonatomic) NSMutableArray *nonSelectedArr;

@end

@implementation LixianOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离线订单";
    
    self.selectedArr = [NSMutableArray array];
    self.nonSelectedArr = [NSMutableArray array];
    
    NSArray *array = [OfflineDataManager getAllOffLineOrderFromSandBox];
    self.array = [NSMutableArray arrayWithArray:array];
    if (self.array.count < 1) {
        [self loadEmptyView:@"仅在无网时录入"];
    }else{
        [self setupSubViews];
    }
    
}

#pragma mark - 有数据时
- (void)setupSubViews
{
    isAllSelected = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.leftBottomV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH/2, 44)];
    self.leftBottomV.userInteractionEnabled = YES;
    self.leftBottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.leftBottomV];
    
    self.rightBottomV = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH/2, 44)];
    self.rightBottomV.userInteractionEnabled = YES;
    self.rightBottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rightBottomV];
    
     self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allButton setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    [self.allButton addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBottomV addSubview:self.allButton];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBottomV.mas_centerY);
        make.left.equalTo(self.leftBottomV.mas_left).offset(30);
        make.width.and.height.equalTo(@30);
    }];
    
    UILabel *allSelected = [[UILabel alloc]init];
    allSelected.text = @"全选";
    allSelected.userInteractionEnabled = YES;
    allSelected.font = [UIFont systemFontOfSize:14];
    allSelected.textColor = RGBACOLOR(68, 68, 68, 1);
    allSelected.textAlignment = NSTextAlignmentCenter;
    [self.leftBottomV addSubview:allSelected];
    [allSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBottomV.mas_centerY);
        make.left.equalTo(self.allButton.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"立即发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 4;
    sendButton.backgroundColor = MainColor;
    [self.rightBottomV addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBottomV.mas_centerY);
        make.centerX.equalTo(self.rightBottomV.mas_centerX);
        make.height.equalTo(@35);
        make.left.equalTo(self.rightBottomV.mas_left).offset(20);
    }];
    
}
#pragma mark - 发送
- (void)sendAction
{
    NSMutableArray *sendArray = [NSMutableArray array];
    for (OffLineOrder *order in self.array) {
        if (order.isSelectedSend) {
            [sendArray addObject:order];
        }
    }
    
    if (sendArray.count < 1) {
        [self showWarningTips:@"请选中订单"];
        return;
    }
    
    dispatch_sync(ZCGlobalQueue, ^{
        for (int i = 0; i < sendArray.count; i++) {
            OffLineOrder *model = sendArray[i];
            
            [HTTPManager GET:model.allUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *message = [[responseObject objectForKey:@"message"] description];
                int status = [[[responseObject objectForKey:@"code"] description] intValue];
                
                if (status == 1) {
                    [self showSuccessTips:message];
                    // 除移
                    BOOL result = [OfflineDataManager deleteOrderAtIndex:model.id];
                    if (result) {
                        [self.array removeAllObjects];
                        NSArray *tempArr = [OfflineDataManager getAllOffLineOrderFromSandBox];
                        if (tempArr.count >=1 ) {
                            self.array = [NSMutableArray arrayWithArray:tempArr];
                            [self.tableView reloadData];
                        }else{
                            [self.tableView removeFromSuperview];
                            [self.leftBottomV removeFromSuperview];
                            [self.rightBottomV removeFromSuperview];
                            [self loadEmptyView:@"暂无数据"];
                        }
                        
                    }
                }else{
                    [self sendErrorWarning:message];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [self sendErrorWarning:error.localizedDescription];
            }];
            
            
        }
    });
    
}
#pragma mark - 全选
- (void)allSelected:(UIButton *)sender
{
    isAllSelected = !isAllSelected;
    if (isAllSelected) {
        // 全选中
        [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
        
        for (OffLineOrder *model in self.array) {
            model.isSelectedSend = YES;
        }
        [self.tableView reloadData];
        
    }else{
        // 取消全选
        [sender setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        
        for (OffLineOrder *model in self.array) {
            model.isSelectedSend = NO;
        }
        
        [self.tableView reloadData];
    }
    
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
    OffLineOrder *model = self.array[indexPath.section];
    OfflineOrderTableCell *cell = [OfflineOrderTableCell sharedOfflineOrderCell:tableView];
    cell.delegate = self;
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OffLineOrder *model = self.array[indexPath.section];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"除移" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除该产品
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定删除该订单？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            // 先删除数据库
            BOOL result = [OfflineDataManager deleteOrderAtIndex:model.id];
            if (result) {
                [self.array removeObjectAtIndex:indexPath.section];
                if (self.array.count > 0) {
                    [self.tableView reloadData];
                }else{
                    [self.tableView removeFromSuperview];
                    [self.leftBottomV removeFromSuperview];
                    [self.rightBottomV removeFromSuperview];
                    [self loadEmptyView:@"暂无数据"];
                }
                
            }
        } otherButtonTitles:@"删除", nil];
        
        [sheet show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *jiajiAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"📱" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 联系客户
        
        NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.mobile]];
        UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
        [self.view addSubview:phoneWebView];
        
    }];
    jiajiAction.backgroundColor = [UIColor brownColor];
    
    return @[deleteAction,jiajiAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}
#pragma mark - 是否全选的按钮状态
- (void)offLineOrderCell:(OfflineOrderTableCell *)offCell
{
    
    for (OffLineOrder *model in self.array) {
        if (model.isSelectedSend) {
            [_selectedArr addObject:model];
        }else{
            [_nonSelectedArr addObject:model];
        }
    }
    
    if (_selectedArr.count == self.array.count) {
        // 全选的
        [self.allButton setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        // 非全选
        [self.allButton setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
}
#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
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



@end
