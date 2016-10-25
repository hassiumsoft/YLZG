//
//  IMChatManager.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "IMChatManager.h"
#import "UserInfoManager.h"
#import "EaseConvertToCommonEmoticonsHelper.h"


static IMChatManager *manager = nil;


@implementation IMChatManager

@synthesize isShowingimagePicker = _isShowingimagePicker;

#pragma mark - 初始化
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMChatManager alloc]init];
    });
    return manager;
}
//每次获取最新的扩展信息
+ (NSDictionary *)getNewestExt
{
    UserInfoModel *userModel = [UserInfoManager getUserInfo];
    NSDictionary *ext = @{@"avatarURLPath":userModel.head,@"nickname":userModel.realname,@"uid":userModel.uid};
    return ext;
}

#pragma mark - 发送文本消息<文字/表情>
+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
{
    // 表情映射
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithText:willSendText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc]initWithConversationID:to from:from to:to body:body ext:[self getNewestExt]];
    message.chatType = messageType;
    return message;
}
#pragma mark - 发送语音消息
+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:localPath displayName:@"in"];
    body.duration = (int)duration;
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self getNewestExt]];
    message.chatType = messageType;
    
    return message;
}
#pragma mark - 发送地址信息
+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude longitude:(double)longitude address:(NSString *)address to:(NSString *)to messageType:(EMChatType)messageType
{
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self getNewestExt]];
    message.chatType = messageType;
    
    return message;
}
#pragma mark - 发送图片消息
+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image to:(NSString *)to messageType:(EMChatType)messageType
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    return [self sendImageMessageWithImageData:imageData to:to messageType:messageType];
    
}
+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData to:(NSString *)to messageType:(EMChatType)messageType
{
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self getNewestExt]];
    message.chatType = messageType;
    return message;
}


+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url to:(NSString *)to messageType:(EMChatType)messageType
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:[url path] displayName:@"video.mp4"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self getNewestExt]];
    message.chatType = messageType;
    
    return message;
}









@end
