//
//  NineDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineDetialViewController.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "NineDetialModel.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "ZhuanfaCountModel.h"
#import "ZhuanfaListModel.h"
#import <UIImageView+WebCache.h>
#import "ZhuanfaCountController.h"
#import "XLPhotoBrowser.h"


@interface NineDetialViewController ()

{
    int LoadCount;
}

/** 模板详细模型 */
@property (strong,nonatomic) NineDetialModel *detialModel;

/** 转发统计模型，只有管理员有权限 */
@property (strong,nonatomic) ZhuanfaCountModel *countModel;

/** 保存的图片数组 */
//@property (strong,nonatomic) NSMutableArray *imageArray;
/** 保存ImageView的数组 */
@property (strong,nonatomic) NSMutableArray *imgViewArray;

@end

@implementation NineDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"模板详细";
    LoadCount = 0;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self getData];
    
}
#pragma mark - 获取数据
- (void)getData
{
    
    NSString *url = [NSString stringWithFormat:NineDetial_Url,[ZCAccountTool account].userID,self.mobanID,self.date];
    [MBProgressHUD showMessage:@"加载中···"];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.detialModel = [NineDetialModel mj_objectWithKeyValues:result];
#warning 有错，确实count
            self.countModel = [ZhuanfaCountModel mj_objectWithKeyValues:self.detialModel.count];
            
            [self setupSubViews:self.detialModel];
            
        }else{
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

#pragma mark - 绘制UI界面
- (void)setupSubViews:(NineDetialModel *)model
{
    
    // 描述文字
    UITextView *descLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, self.view.width - 20, 110*CKproportion)];
    descLabel.editable = NO;
    descLabel.backgroundColor = self.view.backgroundColor;
    descLabel.text = model.content;
    descLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    descLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:descLabel];
    
    // 九宫格
    CGFloat spaceH = 3; // 横向间距
    CGFloat spaceZ = 3; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*4 - 30)/3;  // 宽
    CGFloat H = W;
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (int i = 0; i < model.images.count; i++) {
        
        CGRect frame;
        frame.size.width = W;
        frame.size.height = H;
        frame.origin.x = (i%3) * (frame.size.width + spaceH) + spaceH + 15;
        frame.origin.y = floor(i/3) * (frame.size.height + spaceZ) + spaceZ + 120*CKproportion;
        
        NineDetialImageModel *imageModel = model.images[i];
        [urlArray addObject:imageModel.url];
        
        
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
        
        [imageV setFrame:frame];
        imageV.tag = i;
        
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:[self imageWithBgColor:HWRandomColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (!error) {
                LoadCount++;
            }
        }];
        
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [XLPhotoBrowser showPhotoBrowserWithImages:urlArray currentImageIndex:imageV.tag];
        }];
        [imageV addGestureRecognizer:tap];
        
        [self.view addSubview:imageV];
        [self.imgViewArray addObject:imageV];
    }
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70 - 64, SCREEN_WIDTH, 70)];
//    bottomV.backgroundColor = HWRandomColor;
    [self.view addSubview:bottomV];
    
    if (self.isManager) {
        // 有管理权限
        NSArray *titleArr = @[@"转发统计",@"一键转发",@"提醒转发"];
        CGFloat space = 20;
        CGFloat W = (SCREEN_WIDTH - space*(titleArr.count + 1))/titleArr.count;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4;
            button.layer.borderColor = NormalColor.CGColor;
            button.layer.borderWidth = 1.f;
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:NormalColor forState:UIControlStateNormal];
            button.tag = 15+i;
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
                if (sender.tag == 15) {
                    // 转发统计
                    ZhuanfaCountController *countVC = [ZhuanfaCountController new];
                    countVC.countModel = self.countModel;
                    [self.navigationController pushViewController:countVC animated:YES];
                }else if (sender.tag == 16) {
                    // 一键转发
                    [self SendToWechat];
                }else {
                    // 转发提醒
                    [self ReSendNotice];
                }
            }];
            [button setFrame:CGRectMake((i%titleArr.count) * (W + space) + space, 5, W, 40)];
            
            [bottomV addSubview:button];
        }
        
    }else{
        // 没有管理权限，一个转发按钮
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = MainColor;
        [sendButton setTitle:@"一键转发" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(SendToWechat) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setFrame:CGRectMake(20, 5, self.view.width - 40, 40)];
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 4;
        [bottomV addSubview:sendButton];
    }
    
}



#pragma mark - 发送到微信
- (void)SendToWechat
{
    if (LoadCount < self.detialModel.images.count) {
        [MBProgressHUD showError:@"下载未完成"];
        return;
    }
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (int i = 0; i < self.imgViewArray.count; i++) {
        
        UIImageView *imageView = self.imgViewArray[i];
        if (imageView.tag == i) {
            [imageArray addObject:imageView.image];
            
        }
        
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于iPhone系统的封闭性，文字描述已复制到剪切板，请在发送前手动粘贴到输入框或编辑文字。适合场景：微信朋友圈、QQ空间、支付宝、Facebook" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIActivity *activity = [[UIActivity alloc]init];
        [activity prepareWithActivityItems:imageArray];
        NSArray *activityArray = @[activity];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:imageArray applicationActivities:activityArray];
        activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToTencentWeibo,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypePostToWeibo,UIActivityTypePostToTwitter,UIActivityTypePostToFacebook];
        
        activityVC.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            if (completed) {
                NSString *url = [NSString stringWithFormat:ZhuanfaCount_Url,[ZCAccountTool account].userID,self.detialModel.id,self.detialModel.cid];
                [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    int code = [[[responseObject objectForKey:@"code"] description] intValue];
                    NSString *message = [[responseObject objectForKey:@"message"] description];
                    if (code != 1) {
                        [self sendErrorWarning:message];
                    }
                } fail:^(NSURLSessionDataTask *task, NSError *error) {
                    
                    [self sendErrorWarning:error.localizedDescription];
                }];
            }
        };
        
        UIPasteboard *pasted = [UIPasteboard generalPasteboard];
        [pasted setString:self.detialModel.content];
//        [MBProgressHUD showSuccess:@"已复制到剪切板"];
        
        [self presentViewController:activityVC animated:TRUE completion:^{
            
        }];
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - 转发提醒
- (void)ReSendNotice
{
    
    NSString *url = [NSString stringWithFormat:NineResendTips_Url,[ZCAccountTool account].userID,self.detialModel.id];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self sendErrorWarning:message];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}


- (NSMutableArray *)imgViewArray
{
    if (!_imgViewArray) {
        _imgViewArray = [NSMutableArray array];
    }
    return _imgViewArray;
}

@end
