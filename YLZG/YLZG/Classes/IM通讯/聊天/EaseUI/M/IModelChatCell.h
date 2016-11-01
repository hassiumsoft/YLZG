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

#import <Foundation/Foundation.h>

#import "IModelCell.h"

@protocol IModelChatCell <NSObject,IModelCell>

@required

@property (strong, nonatomic) id model;

@optional


/**
 判断是否为自定义Cell

 @param model 消息模型

 @return 真假
 */
- (BOOL)isCustomBubbleView:(id)model;


/**
 设置自定义Cell气泡

 @param model 消息
 */
- (void)setCustomBubbleView:(id)model;



/**
 设置自定义Cell

 @param model 消息
 */
- (void)setCustomModel:(id)model;


/**
 修改自定义气泡位置

 @param bubbleMargin bubbleMargin
 @param mode         消息
 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;

@optional

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end
