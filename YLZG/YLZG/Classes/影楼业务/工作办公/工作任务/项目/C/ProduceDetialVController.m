//
//  ProduceDetialVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialVController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"


@interface ProduceDetialVController ()

@end

@implementation ProduceDetialVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目详情";
    [self getDetialData];
}
- (void)getDetialData
{
    NSString *url = [NSString stringWithFormat:ProduceDetial_URL,[ZCAccountTool account].userID,_listModel.id];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject = %@", responseObject);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}

@end
