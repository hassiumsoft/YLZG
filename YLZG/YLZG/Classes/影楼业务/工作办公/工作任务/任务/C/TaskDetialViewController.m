//
//  TaskDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDetialViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>


@interface TaskDetialViewController ()

@end

@implementation TaskDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self getData];
}

- (void)getData
{
    NSString *url = [NSString stringWithFormat:TaskDetial_Url,[ZCAccountTool account].userID,self.listModel.id];
    NSLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"任务详情 = %@",responseObject);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

@end
