//
//  UserInfoViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoManager.h"
#import <LCActionSheet.h>
#import <PDTSimpleCalendar.h>
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "NoDequTableCell.h"
#import "HTTPManager.h"
#import "ImageBrowser.h"
#import "ZCAccountTool.h"
#import "NameViewController.h"
#import "PhoneViewController.h"
#import "CityViewController.h"
#import "NSDate+Category.h"


@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,PDTSimpleCalendarViewDelegate>

/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *dateSource;
/** 头像图片 */
@property (strong,nonatomic) UIImageView *headImag;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.dateSource = @[@[@"头像",@"姓名",@"手机号码"],@[@"生日",@"地区"]];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dateSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dateSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 头像
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.dateSource[indexPath.section][indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.layer.masksToBounds = YES;
            imageV.userInteractionEnabled = YES;
            imageV.layer.cornerRadius = 4.f;
            if ([self.userModel.gender intValue] == 1) {
                [imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
            } else {
                [imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.head] placeholderImage:[UIImage imageNamed:@"male_place"]];
            }
            [cell addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-30);
                make.width.and.height.equalTo(@58);
            }];
            self.headImag = imageV;
            // 给图片添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                [ImageBrowser showImage:imageV];
            }];
            [self.headImag addGestureRecognizer:tap];
            
            return cell;
        } else if(indexPath.row == 1){
            // 昵称
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.dateSource[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.title;
            
            return cell;
        }else{
            // 手机号码
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.dateSource[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.mobile;
            
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            // 生日
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.dateSource[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.birth;
            
            return cell;
        }else{
            // 地区
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.dateSource[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.location;
            
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 头像
            LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
            [actionSheet show];
            
        } else if(indexPath.row == 1){
            // 姓名
            NameViewController *name = [NameViewController new];
            [self.navigationController pushViewController:name animated:YES];
        }else{
            // 手机号码
            PhoneViewController *phone = [PhoneViewController new];
            [self.navigationController pushViewController:phone animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            // 生日
            PDTSimpleCalendarViewController *calendar = [PDTSimpleCalendarViewController new];
            calendar.title = @"我的生日";
            calendar.delegate = self;
            calendar.overlayTextColor = MainColor;
            calendar.weekdayHeaderEnabled = YES;
            calendar.firstDate = [NSDate dateWithHoursBeforeNow:12*30*24*35]; // 8个月
            calendar.lastDate = [NSDate date];
//            [calendar scrollToDate:[NSDate dateWithTimeIntervalSinceNow:60*60*8] animated:YES];
            [self.navigationController pushViewController:calendar animated:YES];
        } else {
            // 地区
            CityViewController *city = [CityViewController new];
            city.CityBlock = ^(NSString *city){
                self.userModel.location = city;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:city animated:YES];
        }
    }
}
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *chooseTime = [time substringWithRange:NSMakeRange(0, 10)];
    
    [self updataBirthDay:chooseTime];
    
    
}
- (void)updataBirthDay:(NSString *)birth
{
    [self showHudMessage:@"更新中···"];
    ZCAccount *account = [ZCAccountTool account];
    NSString *str = [NSString stringWithFormat:UploadBirthURL,birth,account.userID];
    [HTTPManager GET:str params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        if (status == 1) {
            [UserInfoManager updataUserInfoWithKey:@"birth" Value:birth];
            self.userModel = [UserInfoManager getUserInfo];
            [self.tableView reloadData];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *message = [[responseObject objectForKey:@"message"] description];
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
}


#pragma mark - 选择头像
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            // 拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing = YES;
                [self presentViewController:imagePickerController animated:YES completion:^{
                }];
                
            }
            break;
        }
        case 2:
        {
            // 从相册中选择
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagepicker.allowsEditing = YES;
            imagepicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [imagepicker.navigationBar setBarTintColor:NavColor];
            [self presentViewController:imagepicker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self showHudMessage:@"正在上传"];
    //    __weak typeof(self) weakSelf = self;
    UIImage * orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
        
        NSString *url = [NSString stringWithFormat:UploadHeadUTL,[ZCAccountTool account].userID];
        // 上传头像 模糊度如果是1会出现失败
        NSData *data = UIImageJPEGRepresentation(orgImage, 0.5);
        NSString *name = @"file";
        NSString *fileName = @"head.jpeg";
        
        
        [HTTPManager uploadWithURL:url params:nil fileData:data name:name fileName:fileName mimeType:@"jpeg" progress:^(NSProgress *progress) {
            
            KGLog(@"progress = %@",progress);
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self hideHud:0];
            
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                
                [YLNotificationCenter postNotificationName:YLHeadImageChanged object:nil];
                
                NSString *head = [[responseObject objectForKey:@"head"] description];
                BOOL result = [UserInfoManager updataUserInfoWithKey:@"head" Value:head];
                if (result) {
                    [self showSuccessTips:message];
                    self.userModel = [UserInfoManager getUserInfo];
                    [self.tableView reloadData];
                }
            }else{
                [self showErrorTips:message];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud:0];
            KGLog(@"error = %@",error.localizedDescription);
        }];
        
    }else {
        [self hideHud:0];
        [self showErrorTips:@"上传失败"];
    }
}


#pragma mark - 取消上传
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 其他设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 75;
    }else{
        return 50;
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = [UserInfoManager getUserInfo];
    self.title = self.userModel.nickname.length >= 1 ? self.userModel.nickname : self.userModel.realname;
    [self.tableView reloadData];
    
}

@end
