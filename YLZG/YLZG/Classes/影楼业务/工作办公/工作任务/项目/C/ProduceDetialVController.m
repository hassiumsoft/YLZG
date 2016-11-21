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
#import <MJExtension.h>
#import "ProduceDetialModel.h"


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
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            ProduceDetialModel *model = [ProduceDetialModel mj_objectWithKeyValues:result];
            NSLog(@"responseObject = %@", model);
        }else{
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}

@end
