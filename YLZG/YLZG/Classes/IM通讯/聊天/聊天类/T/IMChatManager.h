//
//  IMChatManager.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EMSDK.h>

/** 发送消息的管理者 */

@interface IMChatManager : NSObject<EMClientDelegate>

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)sharedManager;

/******************一些发送消息的方法****************/

/**
 构造文本消息

 @param text        文本内容
 @param to          发送给谁-ConversationID
 @param messageType 消息类型

 @return EMMessage
 */
+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType;


/**
 构造语音消息

 @param localPath   语音路径
 @param duration    方向
 @param to          发送给谁-ConversationID
 @param messageType 消息类型
 
 @return EMMessage
 */
+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType;


/**
 构造位置信息

 @param latitude    经度
 @param longitude   维度
 @param address     位置信息
 @param to          发送给谁-ConversationID
 @param messageType 消息类型

 @return EMMessage
 */
+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType;



/**
 构造图片消息

 @param image       图片
 @param to          发送给谁-ConversationID
 @param messageType 消息类型

 @return EMMessage
 */
+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType;


/**
 构造图片消息

 @param imageData   二进制图片资源
 @param to          发送给谁-ConversationID
 @param messageType 消息类型

 @return EMMessage
 */
+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType;



/**
 构造小视频消息

 @param url         视频路径
 @param to          发送给谁-ConversationID
 @param messageType 消息类型

 @return EMMessage
 */
+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType;

@end
