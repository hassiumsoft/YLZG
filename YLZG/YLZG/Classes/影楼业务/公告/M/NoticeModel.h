//
//  NoticeModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

/** 时间 */
@property (assign,nonatomic) NSTimeInterval create_time;
/** 标题 */
@property (copy,nonatomic) NSString *title;
/** 内容 */
@property (copy,nonatomic) NSString *content;
/** 是否置顶 */
@property (assign,nonatomic) BOOL top;
/** 发布人ID */
@property (copy,nonatomic) NSString *uid;
/** 发布人在店内的ID */
@property (copy,nonatomic) NSString *sid;
/** 发布人名字 */
@property (copy,nonatomic) NSString *realname;

@end
