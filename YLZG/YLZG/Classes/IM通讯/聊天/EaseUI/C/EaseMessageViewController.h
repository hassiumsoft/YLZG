//
//  EaseMessageViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "EaseRefreshTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EaseRefreshTableViewController.h"

#import "IMessageModel.h"
#import "EaseMessageModel.h"
#import "EaseBaseMessageCell.h"
#import "EaseMessageTimeCell.h"
#import "EaseChatToolbar.h"
#import "SendLocaltionController.h"
#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "IMChatManager.h"
#import "ContactersModel.h"
#import "YLGroup.h"

@interface EaseAtTarget : NSObject
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *nickname;

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname;
@end

typedef void(^EaseSelectAtTargetCallback)(EaseAtTarget*);

@class EaseMessageViewController;

@protocol EaseMessageViewControllerDelegate <NSObject>

@optional

/*!
 @method
 @brief 获取消息自定义cell
 @discussion 用户根据messageModel判断是否显示自定义cell,返回nil显示默认cell,否则显示用户自定义cell
 @param tableView 当前消息视图的tableView
 @param messageModel 消息模型
 @result 返回用户自定义cell
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 获取消息cell高度
 @discussion 用户根据messageModel判断,是否自定义显示cell的高度
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param cellWidth 视图宽度
 @result 返回用户自定义cell
 */
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

/*!
 @method
 @brief 发送消息成功
 @discussion 消息发送成功的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
          didSendMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 发送消息失败
 @discussion 消息发送失败的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param error 错误描述
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
   didFailSendingMessageModel:(id<IMessageModel>)messageModel
                        error:(EMError *)error;

/*!
 @method
 @brief 接收到消息的已读回执
 @discussion 接收到消息的已读回执的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
 didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 选中消息
 @discussion 选中消息的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 点击消息头像
 @discussion 获取用户点击头像回调
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 选中底部功能按钮
 @discussion 消息发送成功的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param index 选中底部功能按钮索引
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

/*!
 @method
 @brief 底部录音功能按钮状态回调
 @discussion 获取底部录音功能按钮状态回调,根据EaseRecordViewType,用户自定义处理UI的逻辑
 @param viewController 当前消息视图
 @param recordView 录音视图
 @param type 录音按钮当前状态
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
          didSelectRecordView:(UIView *)recordView
                 withEvenType:(EaseRecordViewType)type;

/*!
 @method
 @brief 获取要@的对象
 @discussion 用户输入了@，选择要@的对象
 @param selectedCallback 用于回调要@的对象的block
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback;

@end


@protocol EaseMessageViewControllerDataSource <NSObject>

@optional


/**
 指定消息附件上传或者下载进度的监听者,默认self
 
 @param viewController  当前消息视图
 @param messageBodyType messageBodyType
 
 @return ID
 */
- (id)messageViewController:(EaseMessageViewController *)viewController
progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;


/**
 附件进度有更新
 
 @param viewController 当前消息视图
 @param progress       进度
 @param messageModel   messageModel
 @param messageBody    消息体
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<IMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;


/**
 消息时间间隔描述
 
 @param viewController 当前消息视图
 @param date           时间
 
 @return 消息时间描述
 */
- (NSString *)messageViewController:(EaseMessageViewController *)viewController stringForDate:(NSDate *)date;


/**
 获取消息，返回EMMessage类型的数据列表
 
 @param viewController 当前消息视图
 @param timestamp      时间
 @param count          个数
 
 @return 返回EMMessage类型的数据列表
 */
- (NSArray *)messageViewController:(EaseMessageViewController *)viewController
          loadMessageFromTimestamp:(long long)timestamp
                             count:(NSInteger)count;


/**
 将EMMessage类型转换为符合<IMessageModel>协议的类型
 
 @param viewController 当前消息界面
 @param message        聊天消息对象类型
 
 @return 返回<IMessageModel>协议的类型
 */
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message;

/*!
 @method
 @brief 是否允许长按
 @discussion 获取是否允许长按的回调,默认是NO
 @param viewController 当前消息视图
 @param indexPath 长按消息对应的indexPath
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @brief 触发长按手势
 @discussion 获取触发长按手势的回调,默认是NO
 @param viewController 当前消息视图
 @param indexPath 长按消息对应的indexPath
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @brief 是否标记为已读
 @discussion 是否标记为已读的回调
 @param viewController 当前消息视图
 */
- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController;


/**
 是否发送已读回执
 
 @param viewController 当前消息视图
 @param message        要发送已读回执的message
 @param read           message是否已读
 
 @return 真假
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read;

/**
 判断消息是否为表情消息
 
 @param viewController 当前消息视图
 @param messageModel   要发送已读回执的message
 
 @return 判断消息是否为表情消息
 */
- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel;

/**
 根据消息获取表情信息
 
 @param viewController 当前消息视图
 @param messageModel   要发送已读回执的message
 
 @return 真假
 */
- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel;


/**
 获取表情列表
 
 @param viewController 当前消息视图
 
 @return 表情列表
 */
- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController;

/**
 获取发送表情消息的扩展字段
 
 @param viewController 当前消息视图
 @param easeEmotion    easeEmotion
 
 @return 表情扩展
 */
- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion;

@end

@interface EaseMessageViewController : EaseRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, EMChatManagerDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, EaseChatBarMoreViewDelegate,EMChatroomManagerDelegate, EaseMessageCellDelegate>

@property (weak, nonatomic) id<EaseMessageViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EaseMessageViewControllerDataSource> dataSource;

/** 对方的信息模型 */
@property (strong,nonatomic) ContactersModel *contactModel;
/** 群组的模型 */
@property(nonatomic,strong) YLGroup *groupModel;
/** 聊天类型-群还是单聊 */
@property (assign,nonatomic) EMChatType chatType;

/*!
 @property
 @brief 聊天的会话对象
 */
@property (strong, nonatomic) EMConversation *conversation;

/*!
 @property
 @brief 时间间隔标记
 */
@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

/*!
 @property
 @brief 如果conversation中没有任何消息，退出该页面时是否删除该conversation
 */
@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

/*!
 @property
 @brief 当前页面显示时，是否滚动到最后一条
 */
@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

/*!
 @property
 @brief 页面是否处于显示状态
 */
@property (nonatomic) BOOL isViewDidAppear;

/*!
 @property
 @brief 加载的每页message的条数
 */
@property (nonatomic) NSInteger messageCountOfPage; //default 50

/*!
 @property
 @brief 时间分割cell的高度
 */
@property (nonatomic) CGFloat timeCellHeight;

/*!
 @property
 @brief 显示的EMMessage类型的消息列表
 */
@property (strong, nonatomic) NSMutableArray *messsagesSource;

/*!
 @property
 @brief 底部输入控件
 */
@property (strong, nonatomic) UIView *chatToolbar;

/*!
 @property
 @brief 底部功能控件
 */
@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;

/*!
 @property
 @brief 底部表情控件
 */
@property(strong, nonatomic) EaseFaceView *faceView;

/*!
 @property
 @brief 底部录音控件
 */
@property(strong, nonatomic) EaseRecordView *recordView;

/*!
 @property
 @brief 菜单(消息复制,删除)
 */
@property (strong, nonatomic) UIMenuController *menuController;

/*!
 @property
 @brief 选中消息菜单索引
 */
@property (strong, nonatomic) NSIndexPath *menuIndexPath;

/*!
 @property
 @brief 图片选择器
 */
@property (strong, nonatomic) UIImagePickerController *imagePicker;


/**
 初始化聊天页面
 
 @param conversationChatter 会话对方的用户名. 如果是群聊, 则是群组的id
 @param conversationType    会话类型
 
 @return init
 */
- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;


/**
 下拉加载更多
 */
- (void)tableViewDidTriggerHeaderRefresh;


/**
 发送文本消息
 
 @param text 文本消息
 */
- (void)sendTextMessage:(NSString *)text;


/**
 发送文本消息
 
 @param text 文本消息
 @param ext  扩展信息
 */
- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

/**
 发送图片消息
 
 @param image 发送图片
 */
- (void)sendImageMessage:(UIImage *)image;


/**
 发送位置消息
 
 @param latitude  经度
 @param longitude 维度
 @param address   地址
 */
- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

/**
 发送语音消息
 
 @param localPath 语音本地地址
 @param duration  时长
 */
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;


/**
 发送视频消息
 
 @param url 视频url
 */
- (void)sendVideoMessageWithURL:(NSURL *)url;

/**
 添加消息
 
 @param message  聊天消息类
 @param progress 聊天消息发送接收进度条
 */
-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress;


/**
 显示消息长按菜单
 
 @param showInView  菜单的父视图
 @param indexPath   索引
 @param messageType 消息类型
 */
-(void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;


/**
 判断消息是否要发送已读回执
 
 @param message 聊天消息
 @param read    是否附件消息已读
 
 @return 真假
 */
-(BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                 read:(BOOL)read;

@end

