//
//  SearchMessageViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchMessageViewController.h"
#import "HistoryMessageTableCell.h"
#import <UIImageView+WebCache.h>
#import "EaseConvertToCommonEmoticonsHelper.h"

@interface SearchMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 发送方头像 */
@property (strong,nonatomic) UIImageView *senderImageView;
/** 发送方昵称 */
@property (strong,nonatomic) UILabel *senderNameLabel;
/** 会话 */
@property (strong,nonatomic) EMConversation *conversation;

/** 搜索框 */
@property (strong,nonatomic) UISearchController *searchController;

@end

@implementation SearchMessageViewController

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息检索";
    [self setupSubViews];
}


- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.height = 60;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)showEmptyWithMessage:(NSString *)message
{
//    self.tableView.hidden = NO;
    [self showEmptyViewWithMessage:message];
}

#pragma mark - 搜索代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 1) {
        return;
    }
    
    // 检索消息
    [self.conversation loadMessagesWithKeyword:searchBar.text timestamp:[self getCurrentTimestamp] count:20 fromUser:nil searchDirection:EMMessageSearchDirectionDown completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            if (aMessages.count > 0) {
                self.array = aMessages;
                [self hideMessageAction];
//                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                [self showEmptyWithMessage:@"没有消息"];
            }
        }else{
            [self showEmptyWithMessage:aError.errorDescription];
        }
        
    }];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length < 1) {
        return;
    }
    
    // 检索消息
    [self.conversation loadMessagesWithKeyword:searchBar.text timestamp:[self getCurrentTimestamp] count:20 fromUser:nil searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            if (aMessages.count > 0) {
                self.array = aMessages;
                [self hideMessageAction];
//                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                [self showEmptyWithMessage:@"没有消息"];
            }
        }else{
            [self showEmptyWithMessage:aError.errorDescription];
        }
        
    }];
}


- (long long)getCurrentTimestamp{
    
    NSDate* data= [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval interval=[data timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];//转为字符型
    long long time = timeString.longLongValue;
    return time;
    
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.array = nil;
    [self.tableView reloadData];
    return YES;
}

#pragma mark - 表格相关
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
    HistoryMessageTableCell *cell = [HistoryMessageTableCell sharedHistoryCell:tableView];
    EMMessage *message = self.array[indexPath.row];
    [[YLZGDataManager sharedManager] getOneStudioByUserName:message.from Block:^(ContactersModel *model) {
        
        cell.contactModel = model;
        cell.lastMessage = [self getSwitchMessage:message];
        cell.time = [self timeChanged:message.localTime];
        
    }];
    return cell;
}

- (UIImageView *)senderImageView
{
    if (!_senderImageView) {
        _senderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
        _senderImageView.frame = CGRectMake(15, 10, 40, 40);
        _senderImageView.layer.masksToBounds = YES;
        _senderImageView.layer.cornerRadius = 4;
        
    }
    return _senderImageView;
}

- (NSString *)getSwitchMessage:(EMMessage *)emMessage
{
    NSString *messageStr = nil;
    switch (emMessage.body.type) {
        case EMMessageBodyTypeText:
        {
            messageStr = ((EMTextMessageBody *)emMessage.body).text;
            messageStr = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:messageStr];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            messageStr = @"[图片]";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            messageStr = @"[位置]";
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            messageStr = @"[语音]";
        }
            break;
        case EMMessageBodyTypeVideo:{
            messageStr = @"[视频]";
        }
            break;
        default:
            break;
    }
    return messageStr;
}

- (NSString *)timeChanged:(long long)time
{
    NSString *newTime;
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)time];
    NSDate *localDate = [messageDate dateByAddingHours:8];
    NSString *timeStr = [NSString stringWithFormat:@"%@",localDate];
    if ([messageDate isToday]) {
        newTime = [timeStr substringWithRange:NSMakeRange(11, 5)];
    }else if([messageDate isYesterday]){
        newTime = [NSString stringWithFormat:@"昨天 %@",[timeStr substringWithRange:NSMakeRange(11, 5)]];
    }else{
        newTime = [timeStr substringWithRange:NSMakeRange(0, 11)];
        if ([newTime containsString:@":"]) {
            newTime = [newTime stringByReplacingOccurrencesOfString:@":" withString:@"/"];
        }
    }
    return newTime;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMMessage *message = self.array[indexPath.row];
    NSString *lastMessage = [self getSwitchMessage:message];
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:lastMessage];
    [MBProgressHUD showSuccess:@"已复制"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *message = self.array[indexPath.row];
    NSString *lastMessage = [self getSwitchMessage:message];
    CGFloat height = [lastMessage boundingRectWithSize:CGSizeMake(self.view.width - 65 - 5 - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]} context:nil].size.height + 42;
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

@end
