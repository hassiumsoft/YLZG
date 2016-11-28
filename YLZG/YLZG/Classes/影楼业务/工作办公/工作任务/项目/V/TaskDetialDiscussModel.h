//
//  TaskDetialDiscussModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/****** 讨论记录模型 *********/

@interface TaskDetialDiscussModel : NSObject

/** 附件名称 */
@property (copy,nonatomic) NSString *am_name;
/** 附件缩略图 */
@property (copy,nonatomic) NSString *am_thumb;
/** 附件类型 1 图片 2文件 */
@property (assign,nonatomic) int am_type;
/** 附件地址 */
@property (copy,nonatomic) NSString *am_uri;
/** 讨论内容 */
@property (copy,nonatomic) NSString *content;
/** 评论时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 评论人头像 */
@property (copy,nonatomic) NSString *head;
/** 栏目（任务）ID */
@property (copy,nonatomic) NSString *item;
/** 评论人昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 栏目类型 1任务 2文件 */
@property (assign,nonatomic) int type;
/** 评论人UID */
@property (copy,nonatomic) NSString *uid;


@end
