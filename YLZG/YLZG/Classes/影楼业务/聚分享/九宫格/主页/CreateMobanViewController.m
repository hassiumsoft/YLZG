//
//  CreateMobanViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CreateMobanViewController.h"
#import "WSImagePickerView.h"
#import "ZCAccountTool.h"
#import "HomeNavigationController.h"
#import "HTTPManager.h"
#import <Masonry.h>

@interface CreateMobanViewController ()<UITextViewDelegate>

@property (strong,nonatomic) UIView *photoView;

@property (nonatomic, strong) WSImagePickerView *pickerView;

@property (strong,nonatomic) UITextField *nameField;

@property (strong,nonatomic) UITextView *contentTextView;

@property (strong,nonatomic) UISwitch *switchV;


@end

#define ContentPlace @"将作为您发送到朋友圈的文字描述"

@implementation CreateMobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建模板";
    [self setupSubViews];
}
- (void)setupSubViews
{
    // 模板名称
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 44)];
    label1.text = @"模板名称";
    label1.textColor = RGBACOLOR(37, 37, 37, 1);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 44)];
    self.nameField.placeholder = @"如：春节大放送";
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:dict];
    self.nameField.font = [UIFont systemFontOfSize:15];
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.leftView = label1;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.nameField];
    
    // 模板内容
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 10, 80, 44)];
    label2.text = @"模板内容";
    label2.textColor = label1.textColor;
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), 78, self.view.width - 80 - 10, 80)];
    self.contentTextView.text = ContentPlace;
    self.contentTextView.delegate = self;
    self.contentTextView.font = [UIFont systemFontOfSize:13];
    self.contentTextView.textColor = [UIColor lightGrayColor];
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.layer.cornerRadius = 6;
    [self.view addSubview:self.contentTextView];
    
    // 是否共享
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentTextView.frame) + 10, self.view.width, 44)];
    shareView.userInteractionEnabled = YES;
    shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareView];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    label3.text = @"共享模板";
    label3.textColor = label1.textColor;
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:16];
    [shareView addSubview:label3];
    
    self.switchV = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 60, 4, 50, 36)];
    [self.switchV setOnTintColor:MainColor];
    [self.switchV setOn:YES animated:YES];
    [shareView addSubview:self.switchV];
    
    // 9张图片的视图
    self.photoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame) + 15, SCREEN_WIDTH, 280/3)];
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoView];
    
    WSImagePickerConfig *config = [WSImagePickerConfig new];
    config.itemSize = CGSizeMake(80, 80);
    config.photosMaxCount = 9;
    
    WSImagePickerView *pickerView = [[WSImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) config:config];
    //Height changed with photo selection
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
        weakSelf.photoView.height = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.navigationController = self.navigationController;
    [self.photoView addSubview:pickerView];
    self.pickerView = pickerView;
    
    //refresh superview height
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
    
    // 保存模板按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.backgroundColor = MainColor;
    [saveButton setTitle:@"保存模板" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 4;
    [saveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        // 上传模板
        
        [self uploadMoban];
    }];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.photoView.mas_bottom).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@40);
    }];
    
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


#pragma mark - 上传模板
- (void)uploadMoban
{
    
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
    NSString *url = [NSString stringWithFormat:UpLoadMoban_Url,[ZCAccountTool account].userID,self.nameField.text,self.contentTextView.text,self.switchV.on];
    
    
    NSString *name = @"file";
    NSString *fileName = @"moban.png";
    [self showHudMessage:@"上传中···"];
    
    
/**
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    //遍历这个图片数组
    
    NSMutableArray *imageSourceArr = [NSMutableArray array];
    
    for (UIImage *image in imageArray) {
        
        //将每张图片转化成data数据
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        
        //将转化后的data数据加入到一个可变数组中
        [imageSourceArr addObject:imageData];
    }
    
    //请求格式为二进制格式
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    //创建请求对象
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //循环遍历imageSourceArr可变数组
        [imageSourceArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [formData appendPartWithFileData:obj name:name fileName:fileName mimeType:@"image/jpg"];
        }];
        
    } error:nil];
    //创建网络请求的管理类对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //创建上传任务对象
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress *uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [self showHudMessage:error.localizedDescription];
        }
        [self hideHud:0];
        NSLog(@"responseObject = %@",responseObject);
    }];
    
    [uploadTask resume];
 
 */
    
    
    [HTTPManager uploadMoreImagesURL:url imagesArray:imageArray params:nil name:name fileName:fileName mimeType:@"image/png" progress:^(NSProgress *progress) {
        NSLog(@" progress = %@",progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud:0];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (code == 1) {
            [self sendErrorWarning:message];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

@end
