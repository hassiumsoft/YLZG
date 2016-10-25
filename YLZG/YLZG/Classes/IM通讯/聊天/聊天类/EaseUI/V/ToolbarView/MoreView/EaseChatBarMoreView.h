/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>

typedef enum{
    EMChatToolbarTypeChat,
    EMChatToolbarTypeGroup,
}EMChatToolbarType;

@protocol EaseChatBarMoreViewDelegate;
@interface EaseChatBarMoreView : UIView

@property (nonatomic,assign) id<EaseChatBarMoreViewDelegate> delegate;

@property (nonatomic) UIColor *moreViewBackgroundColor UI_APPEARANCE_SELECTOR;  //moreview背景颜色,default whiteColor

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type;


/**
 新增一个新的功能按钮

 @param image            按钮图片
 @param highLightedImage 高亮图片
 @param title            按钮标题
 */
- (void)insertItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title;


/**
 修改功能按钮图片

 @param image            按钮图片
 @param highLightedImage 高亮图片
 @param title            按钮标题
 @param index            按钮索引
 */
- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;


/**
 根据索引删除功能按钮

 @param index 按钮索引
 */
- (void)removeItematIndex:(NSInteger)index;

@end

@protocol EaseChatBarMoreViewDelegate <NSObject>

@optional


/**
 默认功能

 @param moreView 功能view
 */
- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView; // 发图片
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView; // 发拍照图片
- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView; // 发送位置
- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView; // 语言通话
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView; // 视频通话

/*!
 @method
 @brief 发送消息后的回调
 @param moreView 功能view
 @param index    按钮索引
 */
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index;

@end
