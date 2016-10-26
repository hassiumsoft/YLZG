//
//  ReSendViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/26.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ReSendViewController.h"
#import "ContactTableViewCell.h"
#import "IMChatManager.h"
#import "ChatViewController.h"
#import "EaseEmotionManager.h"
#import "YLZGDataManager.h"
#import "UserInfoManager.h"

@interface ReSendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation ReSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转发消息";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    
    self.array = [[YLZGDataManager sharedManager] getAllFriendInfo];
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
    ContactTableViewCell *cell = [ContactTableViewCell sharedContactTableViewCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    cell.contactModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactersModel *model = self.array[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"确定给%@发送消息？",model.realname];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 确定发送消息
        [self.navigationController popViewControllerAnimated:YES];
        [self reSendMessageTo:model];
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}



/**
 给谁发送消息

 @param contactModel 对方
 */
- (void)reSendMessageTo:(ContactersModel *)contactModel
{
    BOOL flag = YES;
    if (self.messageModel) {
        if (self.messageModel.bodyType == EMMessageBodyTypeText) {
            // 注意gif消息
//            EMMessage *message = [IMChatManager sendTextMessage:self.messageModel.text to:contactModel.name messageType:EMChatTypeChat];
            EMMessage *msg = self.messageModel.message;
            NSDictionary *ext = msg.ext;
            EMMessage *message = [IMChatManager sendGifEmoticonMsg:self.messageModel.text to:contactModel.name messageType:EMChatTypeChat ext:ext];
            
            __weak typeof(self) weakself = self;
            [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
                
            } completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:contactModel.name conversationType:EMConversationTypeChat];
                    
                    [[YLZGDataManager sharedManager] getOneStudioByUserName:contactModel.name Block:^(ContactersModel *model) {
                        chatVC.chatType = EMChatTypeChat;
                        chatVC.contactModel = model;
                        if ([array count] >= 3) {
                            [array removeLastObject];
                            [array removeLastObject];
                        }
                        [array addObject:chatVC];
                        [weakself.navigationController setViewControllers:array animated:YES];
                    }];
                    
                }else{
                    [weakself showErrorTips:@"转发失败"];
                }
            }];
        }else if(self.messageModel.bodyType == EMMessageBodyTypeImage){
            // 转发图片
            flag = NO;
            UIImage *image = self.messageModel.image;
            if (!image) {
                image = [UIImage imageWithContentsOfFile:self.messageModel.fileLocalPath];
            }
            if (!image) {
                [self hideHud:0];
                [self showErrorTips:@"转发失败"];
                [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                return;
            }
            EMMessage *message= [IMChatManager sendImageMessageWithImage:image to:contactModel.name messageType:EMChatTypeChat];
            [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
                
            } completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:contactModel.name conversationType:EMConversationTypeChat];
                    
                    [[YLZGDataManager sharedManager] getOneStudioByUserName:contactModel.name Block:^(ContactersModel *model) {
                        chatVC.chatType = EMChatTypeChat;
                        chatVC.contactModel = model;
                        if ([array count] >= 3) {
                            [array removeLastObject];
                            [array removeLastObject];
                        }
                        [array addObject:chatVC];
                        [self.navigationController setViewControllers:array animated:YES];
                    }];
                    
                }else{
                    [self showErrorTips:@"转发失败"];
                }
            }];
        }
    }
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

@end
