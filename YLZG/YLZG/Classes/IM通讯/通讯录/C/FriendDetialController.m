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

#import "YLZGDataManager.h"
#import <MJExtension.h>
#import "ImageBrowser.h"
#import "NoDequTableCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface FriendDetialController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray * nameArray;

@property (strong,nonatomic) UIView *headView;

@property (strong,nonatomic) UIView *footView;

@property (strong,nonatomic) ContactersModel *model;

@end

@implementation FriendDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameArray = @[@"昵称 :",@"QQ :",@"生日 :",@"部门 :",@"地址 :"];
    self.title = self.userName;
    
    [self.view addSubview:self.tableView];
    [self getFriendInfo];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView  = self.footView;
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
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
            self.title = self.model.nickname.length >= 1 ? self.model.nickname : self.model.realname;
            [self.tableView reloadData];
        }
    }
    
    if (self.model.name.length < 1) {
        // 本地没有，请求网络
        [[YLZGDataManager sharedManager] getOneStudioByUserName:self.userName Block:^(ContactersModel *model) {
            self.model = model;
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
        }else if(indexPath.row ==1){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.qq;
        }else if(indexPath.row ==2){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.birth;
         }else if(indexPath.row ==3){
            cell.textLabel.text = _nameArray[indexPath.row];
            cell.contentLabel.text = self.model.dept;
        }else if(indexPath.row ==4){
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
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        imageV.layer.masksToBounds = YES;
        imageV.userInteractionEnabled = YES;
        imageV.layer.cornerRadius = 4;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [ImageBrowser showImage:imageV];
        }];
        [imageV addGestureRecognizer:tap];
        [_headView addSubview:imageV];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 15, 24, SCREEN_WIDTH - 80, 21)];
        nameLabel.text = self.model.nickname.length >= 1 ? self.model.nickname : self.model.realname;
        nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [_headView addSubview:nameLabel];
        
        UILabel *IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+15, CGRectGetMaxY(nameLabel.frame), SCREEN_WIDTH - 80, 21)];
        IDLabel.text = [NSString stringWithFormat:@"影楼ID：%@",self.model.name];
        IDLabel.userInteractionEnabled = YES;
        IDLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        IDLabel.textColor = RGBACOLOR(87, 87, 87, 1);
        [_headView addSubview:IDLabel];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:self.model.name];
            [self showSuccessTips:@"已复制此ID"];
        }];
        [IDLabel addGestureRecognizer:longTap];
        
        
    }
    return _headView;
}
- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180*CKproportion)];
        _footView.userInteractionEnabled = YES;
        _footView.backgroundColor = self.view.backgroundColor;
        
        UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, 20, SCREEN_WIDTH - 34, 40)];
        messageBtn.layer.cornerRadius = 5;
        messageBtn.layer.masksToBounds = YES;
        messageBtn.backgroundColor = MainColor;
        [messageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        messageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_footView addSubview:messageBtn];
        
        
        UIButton *phoneBtn = [[UIButton alloc ] initWithFrame:CGRectMake(17, CGRectGetMaxY(messageBtn.frame) + 12, SCREEN_WIDTH - 34, 40)];
        phoneBtn.layer.cornerRadius = 5;
        phoneBtn.layer.masksToBounds = YES;
        [phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        phoneBtn.layer.masksToBounds = YES;
        [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        UIColor *color = [[YLZGDataManager sharedManager] isSpringFestival] ? NormalColor : SpringColor;
        phoneBtn.layer.borderColor = color.CGColor;
        phoneBtn.layer.borderWidth = 1.f;
        [phoneBtn setTitleColor:MainColor forState:UIControlStateNormal];
        phoneBtn.backgroundColor = [UIColor whiteColor];
        [_footView addSubview:phoneBtn];
        
    }
    return _footView;
}

@end
