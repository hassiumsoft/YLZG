//
//  CreateMobanViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CreateMobanViewController.h"
#import "WSImagePickerView.h"
#import "ZCAccountTool.h"
#import "HomeNavigationController.h"
#import "HTTPManager.h"
#import "NoDequTableCell.h"
#import <Masonry.h>


@interface CreateMobanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UIView *photoView;

@property (nonatomic, strong) WSImagePickerView *pickerView;

@property (strong,nonatomic) UITextField *nameField;

@property (strong,nonatomic) UITextView *contentTextView;

@property (strong,nonatomic) UISwitch *switchV;

@property (assign,nonatomic) CGFloat PhotoHeight;

@property (strong,nonatomic) UIView *footView;

@end


#define ContentPlace @"将作为您发送到朋友圈的文字描述"

@implementation CreateMobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建模板";
    [self setupSubViews];
}

#pragma mark - 上传模板
- (void)uploadMoban
{
    [self.view endEditing:YES];
    
    if (self.nameField.text.length < 1) {
        [self showErrorTips:@"请输入模板名称"];
        return;
    }
    if (self.contentTextView.text.length < 1) {
        [self showErrorTips:@"请输入模板内容"];
        return;
    }
    NSArray *imageArray = [self.pickerView getPhotos];
    if (imageArray.count < 1) {
        [self showErrorTips:@"请选择图片"];
        return;
    }
    
    NSString *url = UpLoadMoban_Url;
    NSString *isShare;
    if (self.switchV.on) {
        isShare = @"1";
    }else{
        isShare = @"0";
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[ZCAccountTool account].userID forKey:@"uid"];
    [param setObject:self.nameField.text forKey:@"name"];
    [param setObject:self.contentTextView.text forKey:@"content"];
    [param setObject:isShare forKey:@"isShare"];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        UIImage *image = imageArray[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *baseStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *key = [NSString stringWithFormat:@"file%d",i+1];
        
        [param setObject:baseStr forKey:key];
    }
    [self showHudMessage:@"正在上传···"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud:0];
        KGLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

#pragma mark - 视图相关
- (void)setupSubViews
{
    
    self.PhotoHeight = 280/3;
    self.array = @[@"模板名称",@"模板描述",@"共享模板"];
    [self.view addSubview:self.tableView];
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.PhotoHeight)];
    self.footView.backgroundColor = self.view.backgroundColor;
    self.footView.userInteractionEnabled = YES;
    
    // 放置9张图片的UI
    self.photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH, self.PhotoHeight)];
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.footView addSubview:self.photoView];
    
    CGFloat space = 20;
    CGFloat W = (SCREEN_WIDTH - space * 4)/3;
    
    WSImagePickerConfig *config = [WSImagePickerConfig new];
    config.itemSize = CGSizeMake(W, W);
    config.photosMaxCount = 9;
    
    WSImagePickerView *pickerView = [[WSImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) config:config];
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
        
        self.PhotoHeight = height;
        
        [weakSelf.footView setHeight:self.PhotoHeight];
        weakSelf.photoView.height = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.navigationController = self.navigationController;
    [self.photoView addSubview:pickerView];
    self.pickerView = pickerView;
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
    
    self.tableView.tableFooterView = self.footView;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(uploadMoban)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

#pragma mark - 表格绘制
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
    if (indexPath.section == 0) {
        // 模板名称
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.textLabel.text = self.array[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentLabel removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        // 模板描述
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.textLabel.text = self.array[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentLabel removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.self.contentTextView];
        return cell;
    }else{
        // 共享模板
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.textLabel.text = self.array[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentLabel removeFromSuperview];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.switchV];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = self.view.backgroundColor;
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 80;
    }else{
        return 44;
    }
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _tableView;
}
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, self.view.width - 90 - 10, 44)];
        _nameField.placeholder = @"如：春节大放送";
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        _nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:dict];
        _nameField.font = [UIFont systemFontOfSize:15];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return _nameField;
}
- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(90, 10, self.view.width - 100, 60)];
        _contentTextView.text = ContentPlace;
        _contentTextView.delegate = self;
        _contentTextView.font = [UIFont systemFontOfSize:13];
        _contentTextView.textColor = [UIColor lightGrayColor];
        _contentTextView.backgroundColor = [UIColor whiteColor];
        _contentTextView.layer.masksToBounds = YES;
        _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentTextView.layer.borderWidth = 0.5;
        _contentTextView.layer.cornerRadius = 6;
        
    }
    return _contentTextView;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:ContentPlace]) {
        textView.text = @"";
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = ContentPlace;
        textView.font = [UIFont systemFontOfSize:12];
        textView.textColor = [UIColor lightGrayColor];
    }

}
- (UISwitch *)switchV
{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 60, 4, 50, 36)];
        [_switchV setOnTintColor:MainColor];
        [_switchV setOn:YES animated:YES];
    }
    return _switchV;
}


@end

