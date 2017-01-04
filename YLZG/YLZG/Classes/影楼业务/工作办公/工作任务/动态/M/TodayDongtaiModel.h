//
//  TodayDongtaiModel.h
//  YLZG
//
//  Created by Chan_Sir on 2017/1/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayDongtaiModel : NSObject


/** 当前用户UID*/
@property (copy,nonatomic) NSString *cid;
/** 动态内容 */
@property (copy,nonatomic) NSString *content;
/** 操作员头像 */
@property (copy,nonatomic) NSString *head;
/** 动态ID */
@property (copy,nonatomic) NSString *id;
/** 栏目ID */
@property (copy,nonatomic) NSString *item;
/** 栏目名称 */
@property (copy,nonatomic) NSString *item_name;
/** 操作员昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 项目ID */
@property (copy,nonatomic) NSString *pid;
/** 项目名称 */
@property (copy,nonatomic) NSString *project;
/** 操作时间 */
@property (assign,nonatomic) NSTimeInterval time;
/** 栏目类型 1任务 2文件 */
@property (assign,nonatomic) int type;
/** 操作员UID */
@property (copy,nonatomic) NSString *uid;


@end
