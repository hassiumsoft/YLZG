//
//  ZhuanfaListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 转发人列表数据 */
@interface ZhuanfaListModel : NSObject

/** 转发人头像 */
@property (copy,nonatomic) NSString *head;
/** 转发次数 */
@property (copy,nonatomic) NSString *times;
/** 用户ID */
@property (copy,nonatomic) NSString *uid;
/** 上次转发时间 */
@property (assign,nonatomic) NSTimeInterval create_at;

@end
