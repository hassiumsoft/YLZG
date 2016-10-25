//
//  FriendDetialController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FriendDetialController.h"
#import "HuanxinContactManager.h"
#import "StudioContactManager.h"
#import "NormalTableCell.h"
#import "NSString+StrCategory.h"
#import <SVProgressHUD.h>
#import "YLZGDataManager.h"
#import "DetailHeadView.h"
#import "DetailFootView.h"
#import <MJExtension.h>
#import "NoDequTableCell.h"
#import <Masonry.h>

@interface FriendDetialController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic, strong)NSArray * nameArray;

@property (strong,nonatomic) DetailHeadView *headV;

@property (strong,nonatomic) ContactersModel *model;

@end

@implementation FriendDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameArray = @[@"昵称 :",@"电话 :",@"QQ :",@"生日 :",@"部门 :",@"地址 :"];
    self.title = self.userName;
    
    [self setupSubViews];
    [self getFriendInfo];
    
}



-(void)setupSubViews{
    
    [self.view addSubview:self.tableView];
    
    self.headV = [[DetailHeadView alloc] init];
    self.headV.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT *0.17);
    self.tableView.tableHeaderView = self.headV;
    

    DetailFootView *footV =[[DetailFootView alloc] init];
    footV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.2);
    [footV.messageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [footV.phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView  = footV ;
    
    
}
#pragma mark - 获取好友详情
- (void)getFriendInfo
{
    NSArray *huanxinArr = [HuanxinContactManager getAllHuanxinContactsInfo];
    NSArray *studioArr = [StudioContactManager getAllStudiosContactsInfo];
    NSMutableArray *sumArr = [NSMutableArray arrayWithArray:huanxinArr];
    for (int i = 0; i < studioArr.count; i++) {
        ColleaguesModel *colleagus = studioArr[i];
        for (int j = 0; j < colleagus.member.count; j++) {
            ContactersModel *model = colleagus.member[j];
            [sumArr addObject:model];
        }
    }
    
    for (ContactersModel *model in sumArr) {
        if ([self.userName isEqualToString:model.name]) {
            self.model = model;
            self.headV.model = model;
            self.title = self.model.realname.length >= 1 ? self.model.realname : self.model.nickname;
            [self.tableView reloadData];
        }
    }
    
    if (self.model.name.length < 1) {
        // 本地没有，请求网络
        [[YLZGDataManager sharedManager] getOneStudioByUserName:self.userName Block:^(ContactersModel *model) {
            self.model = model;
            self.headV.model = model;
            self.title = self.model.realname.length >= 1 ? self.self.model.realname : self.model.nickname;
            [self.tableView reloadData];
        }];
    }

    
}




#pragma mark - 发送消息
- (void)sendMessage
{
    if (self.isRootPush) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [YLNotificationCenter postNotificationName:HXRePushToChat object:@"1" userInfo:[self.model mj_keyValues]];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 打电话
-(void)call{
    
    NSString *number = self.model.mobile;
    NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
    [self.view addSubview:phoneWebView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(indexPath.row ==0){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.realname.length >= 1 ? self.self.model.realname : self.model.nickname ;
        }
        else if(indexPath.row ==1){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.mobile;
        }

        else if(indexPath.row ==2){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.qq;
        }
        else if(indexPath.row ==3){
            cell.textLabel.text = _nameArray[indexPath.row];
//            NSTimeInterval interval = [NSTimeInterval alloc];
            cell.contentLabel.text = self.model.birth;
         }
        else if(indexPath.row ==4){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.dept;
        }
        else if(indexPath.row ==5){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.location;
        
        }
            return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = self.view.backgroundColor;

    return foot;
    
  
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}




@end
