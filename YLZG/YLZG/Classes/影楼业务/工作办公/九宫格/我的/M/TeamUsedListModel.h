//
//  TeamUsedListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamUsedListModel : NSObject


/** 模板分类名称 */
@property (copy,nonatomic) NSString *category;
/** 转发时间（不准确） */
@property (assign,nonatomic) NSTimeInterval create_at;
/** ID */
@property (strong,nonatomic) NSString *id;
/** 必发提醒  1提醒 0不提醒 */
@property (assign,nonatomic) BOOL mind;
/** 模板名称 */
@property (copy,nonatomic) NSString *name;
/** 模板缩略图 */
@property (copy,nonatomic) NSString *thumb;
/** 转发次数 */
@property (copy,nonatomic) NSString *times;
/** 当前用户是否已使用  1是  0否 */
@property (assign,nonatomic) BOOL useis;

@end
