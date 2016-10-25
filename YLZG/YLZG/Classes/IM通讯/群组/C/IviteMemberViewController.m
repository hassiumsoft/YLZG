//
//  IviteMemberViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IviteMemberViewController.h"
#import "IvitMembersTableCell.h"
#import "StudioContactManager.h"
#import "HuanxinContactManager.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"

@interface IviteMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据呀 */
@property (strong,nonatomic) NSMutableArray *array;


@property (strong,nonatomic) NSMutableArray *selectArray;

@end

@implementation IviteMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"选择联系人";
    
    if (self.type == AddMemberType) {
        NSArray *huanxinArr = [HuanxinContactManager getAllHuanxinContactsInfo];
        NSArray *studioArr = [StudioContactManager getAllStudiosContactsInfo];
        self.array = [NSMutableArray arrayWithArray:huanxinArr];
        for (int i = 0; i < studioArr.count; i++) {
            ColleaguesModel *colleagus = studioArr[i];
            for (int j = 0; j < colleagus.member.count; j++) {
                ContactersModel *model = colleagus.member[j];
                [self.array addObject:model];
            }
        }
        
        for (ContactersModel *model in huanxinArr) {
            [self.array addObject:model];
        }
        // 还需要把重复的人去除
    }else{
        self.array = [NSMutableArray arrayWithArray:self.groupArr];
    }
    
    
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactersModel *model = self.array[indexPath.row];
    IvitMembersTableCell *cell = [IvitMembersTableCell sharedIvitMembersTableCell:tableView];
    cell.model = model;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZCAccount *account = [ZCAccountTool account];
    ContactersModel *model = self.array[indexPath.row];
    
    
    
    if (self.type == DeleteMemberType) {
        if ([model.name isEqualToString:account.username]) {
            [self showErrorTips:@"不能踢自己"];
            return;
        }
    }else{
        if ([model.name isEqualToString:account.username]) {
            [self showErrorTips:@"您已在群里"];
            return;
        }
    }
    
    
    if (model.isSelected) {
        model.isSelected = NO;
        [self.array replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
        [self.selectArray removeObject:model];
    }else{
        model.isSelected = YES;
        [self.tableView reloadData];
        [self.selectArray addObject:model];
    }
    
    [self setupRightBars:self.selectArray];
}
#pragma mark - 操作
- (void)buttonClick
{
//    http://zsylou.wxwkf.com/index.php/home/easemob/invite_to_group?uid=144&sid=9&gid=1467017904457&id=4&members=[{"name":"aermei_ll","sid":"9","uid":"150"}]  // 加人
//    http://zsylou.wxwkf.com/index.php/home/easemob/kick_out_group?uid=144&sid=9&gid=1467017904457&id=4&members=[{"name":"aermei_ll","sid":"9","uid":"150"}]    踢人  会崩
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url;
    NSArray *dicArr = [ContactersModel mj_keyValuesArrayWithObjectArray:self.selectArray];
    NSString *memberJson = [self toJsonStr:dicArr];
    if (self.type == AddMemberType) {
        url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/invite_to_group?uid=%@&sid=%@&gid=%@&id=%@&members=%@",account.userID,self.groupModel.sid,self.groupModel.gid,self.groupModel.id,memberJson];
    }else{
        url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/kick_out_group?uid=%@&sid=%@&gid=%@&id=%@&members=%@",account.userID,self.groupModel.sid,self.groupModel.gid,self.groupModel.id,memberJson];
    }
    
    [self showHudMessage:@"请稍后"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self showSuccessTips:message];
//            if (self.type == DeleteMemberType) {
//                if (_AddMembersBlock) {
//                    _AddMembersBlock(self.selectArray);
//                }
//            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [self hideHud:0];
            NSString *kkk = [NSString stringWithFormat:@"[%@]:建议您每次选择一个成员",message];
            [self sendErrorWarning:kkk];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self showErrorTips:error.localizedDescription];
    }];
    
}
- (void)setupRightBars:(NSMutableArray *)members
{
    NSString *message;
    if (members.count >= 1) {
        message = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)members.count];
    }else{
        message = @"";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:message style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    }
    return _tableView;
}
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
