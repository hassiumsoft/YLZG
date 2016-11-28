//
//  ProduceMemberModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProduceMemberModel : NSObject

/** 成员头像 */
@property (copy,nonatomic) NSString *head;
/** 成员昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 成员ID */
@property (copy,nonatomic) NSString *uid;

@end
