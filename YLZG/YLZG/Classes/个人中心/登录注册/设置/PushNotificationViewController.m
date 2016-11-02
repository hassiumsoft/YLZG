//
//  PushNotificationViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PushNotificationViewController.h"
#import <LCActionSheet.h>
#import "NoDequTableCell.h"

@interface PushNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;


@property (strong,nonatomic) UIImageView *imageV1;

@property (strong,nonatomic) UIImageView *imageV2;

@property (strong,nonatomic) UIImageView *imageV3;

@end

@implementation PushNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

-(void)setupSubViews{
    
    self.title = @"推送设置";
    
    
    [[EMClient sharedClient].pushOptions setDisplayStyle:EMPushDisplayStyleMessageSummary];
    self.array = @[@"开启",@"夜间勿扰模式",@"全天关闭"];
    [self.view addSubview:self.tableView];
}


#pragma mark - Table view data source
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
    EMPushOptions *pushOption = [EMClient sharedClient].pushOptions;
    
    if (indexPath.row == 0) {
        // 开启。EMPushNoDisturbStatus = EMPushNoDisturbStatusClose
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentLabel removeFromSuperview];
        [cell addSubview:self.imageV1];
        if (pushOption.noDisturbStatus == EMPushNoDisturbStatusClose) {
            // 显示图
            self.imageV1.hidden = NO;
        }else{
            self.imageV1.hidden = YES;
        }
        return cell;
    }else if (indexPath.row == 1){
        // 夜间免打扰。EMPushNoDisturbStatus = EMPushNoDisturbStatusCustom
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentLabel removeFromSuperview];
        
        [cell addSubview:self.imageV2];
        if (pushOption.noDisturbStatus == EMPushNoDisturbStatusCustom) {
            // 显示图
            self.imageV2.hidden = NO;
        }else{
            self.imageV2.hidden = YES;
        }
        return cell;
    }else {
        // 全天关闭。EMPushNoDisturbStatus = EMPushNoDisturbStatusDay
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentLabel removeFromSuperview];
        [cell addSubview:self.imageV3];
        if (pushOption.noDisturbStatus == EMPushNoDisturbStatusDay) {
            // 显示图
            self.imageV3.hidden = NO;
        }else{
            self.imageV3.hidden = YES;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 推送开启 == 关闭免打扰
        [[EMClient sharedClient].pushOptions setNoDisturbStatus:EMPushNoDisturbStatusClose];
        [EMClient sharedClient].pushOptions.noDisturbingStartH = -1;
        [EMClient sharedClient].pushOptions.noDisturbingEndH = -1;
        [self.tableView reloadData];
    }else if (indexPath.row == 1){
        // 夜间勿扰
        [[EMClient sharedClient].pushOptions setNoDisturbStatus:EMPushNoDisturbStatusCustom];
        [EMClient sharedClient].pushOptions.noDisturbingStartH = 22;
        [EMClient sharedClient].pushOptions.noDisturbingEndH = 8;
        [self.tableView reloadData];
    }else {
        // 推送关闭 == 全天免打扰
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择此项后，您将会错过影楼内部的重要信息。\r请您三思！" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[EMClient sharedClient].pushOptions setNoDisturbStatus:EMPushNoDisturbStatusDay];
                [EMClient sharedClient].pushOptions.noDisturbingStartH = -1;
                [EMClient sharedClient].pushOptions.noDisturbingEndH = -1;
                [self.tableView reloadData];
            }
        } otherButtonTitles:@"全天关闭！", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH - 24, 60 - 8)];
    descLabel.text = @"开启后，您随时能收到影楼的推送消息。如果设置为夜间勿扰模式，则只会在8:00到22:00开启消息推送。关闭则不推送消息，您需要主动打开APP查看未读消息。";
    if (iOS_Version >= 8.2) {
        descLabel.font = [UIFont systemFontOfSize:14 weight:0.01];
    }else{
        descLabel.font = [UIFont systemFontOfSize:14];
    }
    descLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    [footV addSubview:descLabel];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

- (UIImageView *)imageV1
{
    if (!_imageV1) {
        _imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 12, 25, 25)];
        _imageV1.image = [UIImage imageNamed:@"selected_yes"];
    }
    return _imageV1;
}

- (UIImageView *)imageV2
{
    if (!_imageV2) {
        _imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 12, 25, 25)];
        _imageV2.image = [UIImage imageNamed:@"selected_yes"];
    }
    return _imageV2;
}

- (UIImageView *)imageV3
{
    if (!_imageV3) {
        _imageV3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 12, 25, 25)];
        _imageV3.image = [UIImage imageNamed:@"selected_yes"];
    }
    return _imageV3;
}


@end
