//
//  ChatViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChatViewController.h"
#import "YLZGChatManager.h"
#import "EaseEmotionManager.h"
#import "ReSendViewController.h"

#import "UserInfoManager.h"
#import "EaseEmoji.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserInfoViewController.h"
#import "FriendDetialController.h"
#import "YLChatGroupDetailController.h"
#import "GroupListManager.h"

@interface ChatViewController ()<EMClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.conversation.type == EMConversationTypeChat) {
        self.title = self.contactModel.realname.length>0 ? self.contactModel.realname : self.contactModel.nickname;
    }else{
        self.title = self.groupModel.gname;
    }
    
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self setupBarButtonItem];
    [YLNotificationCenter addObserver:self selector:@selector(deleteAllMessages:) name:HXRemoveAllMessages object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(exitGroup) name:HXExitGroup object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(handleCallNotification:) name:KNOTIFICATION_CALL object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(handleCallNotification:) name:KNOTIFICATION_CALL_CLOSE object:nil];
}

#pragma mark - 右边的item
- (void)setupBarButtonItem
{
    
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_feature_fullprofiles"] style:UIBarButtonItemStylePlain target:self action:@selector(toChatDetialController)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        
    }else{
        //群聊
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"group"] style:UIBarButtonItemStylePlain target:self action:@selector(showGroupDetailAction)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
}

#pragma mark - 去双方聊天的详细界面
- (void)toChatDetialController
{
    [self.view endEditing:YES];
    NSString *userName = self.contactModel.name; // 聊天界面为空时nil
    for (EaseMessageModel *messageModel in self.dataArray) {
        if (![messageModel isKindOfClass:[NSString class]]) {
            if (!messageModel.isSender) {
                userName = messageModel.message.from;
                KGLog(@"userName -= %@",userName);
            }else{
                // 当对方没有回复时不能查看对方详情
                
            }
        }
    }
    if (userName.length > 2) {
        FriendDetialController *friendVC = [[FriendDetialController alloc]init];
        friendVC.userName = userName;
        friendVC.isRootPush = NO;
        [self.navigationController pushViewController:friendVC animated:YES];
    }
    
}
#pragma mark - 查看详细群组
- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    
    
    YLChatGroupDetailController *groupDetial = [YLChatGroupDetailController new];
    groupDetial.GroupModelBlock = ^(YLGroup *groupModel){
        self.groupModel = groupModel;
        self.title = self.groupModel.gname;
    };
    groupDetial.groupModel = self.groupModel;
    groupDetial.isRootPush = NO;
    [self.navigationController pushViewController:groupDetial animated:YES];
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 长按消息
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

#pragma mark - 点击头像
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    
    UserInfoModel *model = [UserInfoManager getUserInfo];
    if ([messageModel.nickname containsString:model.store_simple_name]) {
        // 同事
        if (messageModel.isSender) {
            // 自己
            UserInfoViewController *userInfo = [[UserInfoViewController alloc]init];
            [self.navigationController pushViewController:userInfo animated:YES];
        }else{
            // 对方界面
            
            FriendDetialController *friendVC = [FriendDetialController new];
            friendVC.userName = messageModel.message.from;
            friendVC.isRootPush = YES;
            [self.navigationController pushViewController:friendVC animated:YES];
            
        }
    }else{
        // 其他影楼的人
        FriendDetialController *friendVC = [FriendDetialController new];
        friendVC.userName = messageModel.message.from;
        [self.navigationController pushViewController:friendVC animated:YES];
    }
    
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"user_place"];
    model.failImageName = @"imageDownloadFail";
    model.nickname = viewController.contactModel.realname;
    model.avatarURLPath = viewController.contactModel.head;
    
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        // @"[示例%d]",index]
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@""] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    UserInfoModel *userModel = [UserInfoManager getUserInfo];
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES),@"avatarURLPath":userModel.head,@"nickname":userModel.realname,@"uid":userModel.uid};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


#pragma mark - 界面不见了之后
- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[YLZGChatManager sharedManager] setChatVC:nil];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:^(NSString *aConversationId, EMError *aError) {
                
            }];
            
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除全部聊天信息
- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:@"暂无消息"];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:@"暂无消息"];
        }
    }else if ([sender isKindOfClass:[UIBarButtonItem class]]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"缺点删除全部消息记录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.dataArray removeAllObjects];
            [self.messsagesSource removeAllObjects];
            
            [self.tableView reloadData];
        }];
        
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 转发消息
- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ReSendViewController *listViewController = [[ReSendViewController alloc]init];
        listViewController.messageModel = model;
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}
#pragma mark - 复制
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}
#pragma mark - 删除某条消息
- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - 收到通知
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:^(EMError *aError) {
            
        }];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - 转发、删除、复制
- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //退出聊天室，删除会话
        NSString *chatter = [self.conversation.conversationId copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
            if (error !=nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        });
    }
    
    [[EMClient sharedClient] removeDelegate:self];
    [self backAction];
}


@end
