//
//  WoViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WoViewController.h"
#import "UserInfoManager.h"
#import "ImageBrowser.h"
#import "NormalTableCell.h"
#import <UIImageView+WebCache.h>
#import "SettingViewController.h"
#import "UserInfoViewController.h"
#import "MyAreaManagerController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "MyStudioVController.h"
#import "ForgetSecretController.h"
#import "AboutUSController.h"
#import "WXApiManager.h"
#import <LCActionSheet.h>
#import "YLZGDataManager.h"


@interface WoViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 挑剔数组 */
@property (copy,nonatomic) NSArray *array;
/** 头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 影楼ID */
@property (strong,nonatomic) UILabel *IDLabel;
/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;


@end

@implementation WoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.array = @[@[@"我的信息"],@[@"我的影楼",@"区域经理",@"修改密码",@"分享影楼掌柜",@"关于我们"],@[@"设置"]];
    [self.view addSubview:self.tableView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.userModel = [UserInfoManager getUserInfo];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell.xian removeFromSuperview];
        [cell.imageV removeFromSuperview];
        [cell.label removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        // 添加头像和昵称
        [cell addSubview:self.headImageV];
        [cell addSubview:self.nameLabel];
        [cell addSubview:self.IDLabel];
        
        self.nameLabel.text = self.userModel.nickname.length >= 1 ? self.userModel.nickname : self.userModel.realname;
        
        if ([self.userModel.gender intValue] == 1) {
            [_headImageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
        } else {
            [_headImageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
        }
        
        return cell;
    } else if(indexPath.section == 1){
        
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell.xian removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSArray *iconArr = @[@"ic_myshop",@"my_manager",@"change_pass",@"ic_share",@"ic_aboutus"];
        cell.imageV.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.label.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else{
        // 设置
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell.xian removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.imageV.image = [UIImage imageNamed:@"ic_setting"];
        cell.label.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 我
        UserInfoViewController *userInfo = [UserInfoViewController new];
        [self.navigationController pushViewController:userInfo animated:YES];
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 我的影楼
            MyStudioVController *mystu = [MyStudioVController new];
            [self.navigationController pushViewController:mystu animated:YES];
        } else if(indexPath.row == 1){
            // 区域经理
            MyAreaManagerController *area = [MyAreaManagerController new];
            area.transitioningDelegate = self;
            area.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:area animated:YES completion:^{
                
            }];
        }else if(indexPath.row == 2){
            // 修改密码
            ForgetSecretController *secret = [ForgetSecretController new];
            [self.navigationController pushViewController:secret animated:YES];
        }else if(indexPath.row == 3){
            //  分享
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                [[YLZGDataManager sharedManager] getShareUrlCompletion:^(NSString *url) {
                    if (buttonIndex == 1) {
                        [self sharetoWechat:url Type:0];
                    }else if(buttonIndex == 2){
                        [self sharetoWechat:url Type:1];
                    }
                }];
                
            } otherButtonTitles:@"微信好友",@"朋友圈", nil];
            [sheet show];
            
        }else{
            // 关于我们
            AboutUSController *about = [AboutUSController new];
            [self.navigationController pushViewController:about animated:YES];
        }
    }else{
        // 设置
        SettingViewController *settingVC = [SettingViewController new];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)sharetoWechat:(NSString *)url Type:(int)shareType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"影楼掌柜-专业的儿童影楼APP";
    message.description = @"随时随地掌握您的影楼工作。";
    [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = url;
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = shareType;
    [WXApi sendReq:req];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 48;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}
#pragma mark - POP动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _tableView;
}
- (UIImageView *)headImageV
{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _headImageV.contentMode = UIViewContentModeScaleAspectFill;
        _headImageV.layer.cornerRadius = 4;
        _headImageV.layer.masksToBounds = YES;
    }
    return _headImageV;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200, 21)];
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _nameLabel.text = self.userModel.nickname.length >= 1 ? self.userModel.nickname : self.userModel.realname;
        
    }
    return _nameLabel;
}
- (UILabel *)IDLabel
{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 42, 270, 21)];
        _IDLabel.text = [NSString stringWithFormat:@"影楼ID:%@",self.userModel.username];
        _IDLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _IDLabel.textColor = RGBACOLOR(10, 10, 10, 1);
    }
    return _IDLabel;
}
@end
