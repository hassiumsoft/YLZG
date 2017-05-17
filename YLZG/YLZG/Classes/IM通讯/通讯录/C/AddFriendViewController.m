//
//  AddFriendViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AddFriendViewController.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "ApplyViewController.h"
#import "ApplyModel.h"
#import "StudioContactManager.h"
#import "HuanxinContactManager.h"
#import "ContactersModel.h"
#import "ColleaguesModel.h"
#import "FriendTableViewCell.h"
#import "UserInfoManager.h"
#import "UserInfoModel.h"
#import "ApplyViewController.h"


@interface AddFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 搜索框 */
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) NSString *putURL;

@property (strong,nonatomic) NSString *message;
//好友列表的数组
@property (strong,nonatomic) NSArray *listArray;

@property (strong,nonnull) UITextField *progressText;
//同一影楼没有加好友的数组
@property (strong,nonatomic) NSMutableArray *myListArray;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    [self getMyColleges];
    
    [self setupSubViews];
}
- (void)getMyColleges
{
    
    if (self.isPresent) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
    
    NSMutableArray *tongshiArr = [NSMutableArray array];
    
    NSMutableArray  *listFriend = [StudioContactManager getAllStudiosContactsInfo];
    UserInfoModel *myModel = [[UserInfoManager sharedManager] getUserInfo];
    for (int i = 0; i < listFriend.count; i++) {
        ColleaguesModel *lastModel = listFriend[i];
        for(int j = 0 ;j <lastModel.member.count;j++){
            ContactersModel *model = lastModel.member[j];
            if (![model.name isEqualToString:myModel.username]) {
                [tongshiArr addObject:model];
            }
        }
    }
    NSMutableArray *huanXF = [HuanxinContactManager getAllHuanxinContactsInfo]; // ContactersModel
    for (int i = 0 ; i < huanXF.count;i++) {
        ContactersModel *contactModel = huanXF[i];
        for (int j = 0 ; j < tongshiArr.count; j++) {
            ContactersModel *model = tongshiArr[j];
            if ([model.name isEqualToString:contactModel.name]) {
                [tongshiArr removeObjectAtIndex:j];
                break;
            }
        }
    }
    self.array = tongshiArr;
    [self.tableView reloadData];
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -- 创建表格
- (void)setupSubViews
{
    self.title = @"添加好友";
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}
#pragma mark -- 查找好友时取数据
- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/fuzzy_search?uid=%@&info=%@",account.userID,self.searchBar.text];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *user = [responseObject objectForKey:@"user"];
            NSMutableArray *modelArr = [ContactersModel mj_objectArrayWithKeyValuesArray:user];
            for (ContactersModel *model in modelArr) {
                [self.array addObject:model];
                
            }
            [self.tableView reloadData];
            
        }else{
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        KGLog(@"error = %@",error.localizedDescription);
    }];
}
#pragma mark -- 上传加的好友的数据
- (void)putData:(NSString *)userName
{
    // 环信加好友写法
    //    EMError *error = [[EMClient sharedClient].contactManager addContact:userName message:self.message];
    //    KGLog(@"------userName------ = %@",userName);
    // 智诚服务器写法
    
    [HTTPManager GET:self.putURL params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            [self showSuccessTips:@"好友请求发送成功"];
            
        }else{
            [self showErrorTips:message];
        }
        [self hideHud:1];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        KGLog(@"error = %@",error.localizedDescription);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [FriendTableViewCell sharedFriendTableViewCell:tableView];
    ContactersModel *contactModel = self.array[indexPath.row];
    cell.contactModel = contactModel;
    cell.addBtn = ^(){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selectedIndexPath = indexPath;
        ContactersModel *model = self.array[indexPath.row];
        ZCAccount *account = [ZCAccountTool account];
        if ([self didBuddyExist:model.uid]) {
            NSString *message = @"对方已经是您的好友";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UserInfoModel *myModel = [[UserInfoManager sharedManager] getUserInfo];
            self.message = [NSString stringWithFormat:@"我是%@",myModel.realname];
            NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/askfriend?uid=%@&aname=%@&anick=%@&ahead=%@&msg=%@&fuid=%@&fname=%@&fnick=%@&fhead=%@",account.userID,myModel.username,myModel.nickname,myModel.head,self.message,model.uid,model.name,model.nickname,model.head];
            self.putURL = url;
            [self showMessageAlertView:contactModel.name];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.array.count >= 1) {
        // 显示“是否一键添加？”
        UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
        headView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]init];
        label.text = @"以下都是您的同事";
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.left.equalTo(headView.mas_left).offset(12);
            make.width.equalTo(@180);
            make.height.equalTo(@48);
        }];
        
        //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [button setTitle:@"一键添加" forState:UIControlStateNormal];
        //        button.backgroundColor = MainColor;
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [button addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        //        button.layer.masksToBounds =YES;
        //        button.layer.cornerRadius = 6.f;
        //        button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        //        [headView addSubview:button];
        //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.equalTo(headView.mas_right).offset(-10);
        //            make.height.equalTo(@35);
        //            make.centerY.equalTo(headView.mas_centerY);
        //            make.width.equalTo(@60);
        //        }];
        
        return headView;
    }else{
        // 显示我的登录号
        UserInfoModel *myModel = [[UserInfoManager sharedManager] getUserInfo];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
        headView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"我的影楼ID：%@",myModel.username];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_top).offset(5);
            make.centerX.equalTo(headView.mas_centerX);
            make.height.equalTo(@24);
        }];
        return headView;
    }
    
}
#pragma  mark -- 一键添加好友
- (void)addFriend
{
    
    
    
    dispatch_async(ZCGlobalQueue, ^{
        for (int i = 0 ; i < self.array.count/5; i++) {
            
            KGLog(@"线程  =  %@",[NSThread currentThread]);
            
            ContactersModel *model = self.array[i];
            if ([self didBuddyExist:model.uid]) {
                NSString *message = @"对方已经是您的好友";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                [self showMessageAlertView:model.name];
            }
        }
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
#pragma mark - searchBar的各种代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.array removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchAction];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.view endEditing:YES];
    //    [self.array removeAllObjects];
    //    [self.tableView reloadData];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [self getMyColleges];
}
#pragma mark - 懒加载
- (NSMutableArray *)myListArray{
    if (!_myListArray) {
        _myListArray = [NSMutableArray array];
    }
    return _myListArray;
}
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"影楼ID/手机号";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    return _searchBar;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma  mark -- 做判断是否在列表中
- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSMutableArray *huanXF = [HuanxinContactManager getAllHuanxinContactsInfo];
    ColleaguesModel *lastModel = [ColleaguesModel new];
    lastModel.member = huanXF;
    for (ContactersModel *model in huanXF) {
        if ([model.name isEqualToString:buddyName]||[model.uid isEqualToString:buddyName]){
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 给添加的好友提供备注
- (void)showMessageAlertView:(NSString *)userName
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"备注" preferredStyle:UIAlertControllerStyleAlert];
    _progressText = [UITextField new];
    _progressText.placeholder = @"请输入备注";
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = _progressText.placeholder;
        _progressText = textField;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        return ;
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *messageStr = @"";
        NSString *myName = [[EMClient sharedClient] currentUsername];
        if (_progressText.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", myName, _progressText.text];
        }
        else{
            messageStr = [NSString stringWithFormat:@"%@ 邀请你为好友", myName];
        }
        //        [self sendFriendApplyAtIndexPath:self.selectedIndexPath
        //                                 message:messageStr];
        [self putData:userName];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//#pragma mark -- 反馈发送是否成功
//- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
//                           message:(NSString *)message
//{
//    ContactersModel *model = self.array[indexPath.row];
//    if (model.nickname && model.nickname.length > 0) {
//        [self showHudInView:self.view hint:@"正在发送申请..."];
//        EMError *error = [[EMClient sharedClient].contactManager addContact:model.nickname message:message];
//        [self hideHud];
//        if (error) {
//            [self showHint:@"发送申请失败，请重新操作"];
//        }
//        else{
//            [self showHint:@"发送申请成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}
#pragma mark - 搜索好友判断是否是自己或者对方已经加过你了
- (void)searchAction
{
    [self.searchBar resignFirstResponder];
    if(self.searchBar.text.length > 0)
    {
        //#warning 由用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
        //#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
        //做判断当前的用户名是否和写入的相同
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if ([self.searchBar.text isEqualToString:loginUsername]) {
            [self sendErrorWarning:@"您自己不能加自己哦"];
            return;
        }
        
        //判断是否已发来申请
        ApplyViewController *ylApply = [[ApplyViewController alloc] init];
        NSArray *applyArray = ylApply.dataSource;
        if (applyArray && [applyArray count] > 0) {
            for (ApplyModel *model in applyArray) {
                YLApplyStyle style = [model.status intValue];
                BOOL isGroup = style == YLApplyStyleFriend ? NO : YES;
                if (!isGroup && [model.fname isEqualToString:self.searchBar.text] &&[model.fnick isEqualToString:self.searchBar.text]) {
                    
                    NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", self.searchBar.text];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
            }
        }
        [self getData];
    }
}



@end
