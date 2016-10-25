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

@interface EaseConvertToCommonEmoticonsHelper : NSObject

/** 图形表情转为文字表情 */
+ (NSString *)convertToCommonEmoticons:(NSString *)text;

/** 文字表情转为图形表情 */
+ (NSString *)convertToSystemEmoticons:(NSString *)text;

@end
