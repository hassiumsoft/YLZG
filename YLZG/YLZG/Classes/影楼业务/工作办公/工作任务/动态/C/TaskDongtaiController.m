//
//  TaskDongtaiController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDongtaiController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <Masonry.h>

@interface TaskDongtaiController ()

@end

@implementation TaskDongtaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

- (void)getData
{
    NSString *date = [self getCurrentTime];
    NSString *url = [NSString stringWithFormat:TaskDongtai_Url,[ZCAccountTool account].userID,date];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int isEnd = [[[responseObject objectForKey:@"isEnd"] description] intValue];
        if (code == 1) {
            if (isEnd == 1) {
                [self CreateEmptyView:@"过去三天没有更多动态"];
            }
        }else{
            [self CreateEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)CreateEmptyView:(NSString *)message
{
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getData];
}

@end
