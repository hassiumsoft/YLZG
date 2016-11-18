//
//  AddNewTaskController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddNewTaskController.h"
#import "HTTPManager.h"

@interface AddNewTaskController ()

@end

@implementation AddNewTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建任务";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
}

- (void)addNewTask
{
//    创建项目
//    地址：http://192.168.0.18/index.php/home/project/create?uid=159&name=项目名称&member=[“129”,”130”]
//    必选参数：UID 、 name 、member
//    可选参数：无
//    正确返回：
//    code = 1,
//    message = “成功“
//    注意：member是项目组成员的uid，转json字符串形式
    
}

@end
