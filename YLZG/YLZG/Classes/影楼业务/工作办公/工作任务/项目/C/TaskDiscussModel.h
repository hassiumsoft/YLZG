//
//  TaskDiscussModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDiscussModel : NSObject

/** 附件名称(上次文件的原名称) */
@property (copy,nonatomic) NSString *am_name;
/** 附件缩略图 */
@property (copy,nonatomic) NSString *am_thumb;
/** 附件类型-1图片 2文件 */
@property (assign,nonatomic) int am_type;
/** 附件地址 */
@property (copy,nonatomic) NSString *am_uri;
/** 评论内容 */
@property (copy,nonatomic) NSString *content;
/** 评论时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 评论人头像 */
@property (copy,nonatomic) NSString *head;
/** 评论ID */
@property (copy,nonatomic) NSString *id;
/** <#这是什么属性#> */



@end
