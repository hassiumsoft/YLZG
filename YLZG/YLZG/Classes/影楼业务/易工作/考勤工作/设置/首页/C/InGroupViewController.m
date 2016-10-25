//
//  InGroupViewController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "InGroupViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"


@interface InGroupViewController ()

@end

@implementation InGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤组";
    [self getData];
}

- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:QiandaoDakaAll_Url,account.userID];
     KGLog(@"url == %@",url);
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                [self showSuccessTips:@""];
            }else{
                [self sendErrorWarning:message];
            }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
         [self showErrorTips:error.localizedDescription];
    }];
    
}

@end
