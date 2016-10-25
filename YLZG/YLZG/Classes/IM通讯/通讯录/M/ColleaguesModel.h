//
//  ColleaguesModel.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/7.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********** 包含ContactersModel的模型，同事组 ***********/

@interface ColleaguesModel : NSObject

/** 部门名称 */
@property (copy,nonatomic) NSString *dept;
/** 成员数组 */
@property (strong,nonatomic) NSArray *member;


@end
