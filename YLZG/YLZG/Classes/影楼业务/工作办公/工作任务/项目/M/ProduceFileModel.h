//
//  ProduceFileModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProduceFileModel : NSObject

/** 上传人头像 */
@property (copy,nonatomic) NSString *head;
/** ID */
@property (copy,nonatomic) NSString *id;
/** 名称 */
@property (copy,nonatomic) NSString *name;
/** 上传人昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 项目ID */
@property (copy,nonatomic) NSString *pid;
/** 项目名称 */
@property (copy,nonatomic) NSString *project;
/** 缩略图 */
@property (copy,nonatomic) NSString *thumb;
/** 类型：图片1还是文件2 */
@property (assign,nonatomic) int type;
/** 上传时间戳 */
@property (assign,nonatomic) NSTimeInterval upload_at;
/** 上传人ID */
@property (copy,nonatomic) NSString *upload_user;
/** 文件地址 */
@property (copy,nonatomic) NSString *uri;


@end
