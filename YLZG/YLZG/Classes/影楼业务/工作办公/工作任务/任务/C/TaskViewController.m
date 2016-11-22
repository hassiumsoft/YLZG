//
//  TaskViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "TaskListModel.h"



@interface TaskViewController ()
/** seg */
@property (strong,nonatomic) UISegmentedControl *segView;
/** 子控制器 */

/** 内容视图 */
@property (strong,nonatomic) UIScrollView *contentView;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作任务";
    [self setupSubViews];
    [self getData];
}

- (void)setupSubViews
{
    [self.view addSubview:self.segView];
}

- (UISegmentedControl *)segView
{
    if (!_segView) {
        _segView = [[UISegmentedControl alloc]initWithItems:@[@"我负责的",@"我发起的",@"我关注的"]];
        __block TaskViewController *weakSelf = self;
        [_segView addBlockForControlEvents:UIControlEventValueChanged block:^(UISegmentedControl *sender) {
            [weakSelf showErrorTips:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
        }];
        _segView.selectedSegmentIndex = 0;
        _segView.tintColor = MainColor;
        _segView.frame = CGRectMake(30*CKproportion, 8, SCREEN_WIDTH - 60*CKproportion, 33);
    }
    return _segView;
}
- (void)getData
{
    NSString *url = [NSString stringWithFormat:TaskList_Url,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (code == 1) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSArray *care = [result objectForKey:@"care"];
            NSArray *create = [result objectForKey:@"create"];
            NSArray *manage = [result objectForKey:@"manage"];
            
            NSArray *careModel = [TaskListModel mj_objectArrayWithKeyValuesArray:care];
            NSArray *createModel = [TaskListModel mj_objectArrayWithKeyValuesArray:create];
            NSArray *manageModel = [TaskListModel mj_objectArrayWithKeyValuesArray:manage];
            NSLog(@"responseObject = %@",responseObject);
            
        }else{
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
}

@end
