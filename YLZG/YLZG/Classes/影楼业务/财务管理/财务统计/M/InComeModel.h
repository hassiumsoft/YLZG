//
//  InComeModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/29.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** 收入模型 *********/

@interface InComeModel : NSObject

@property (assign,nonatomic) BOOL isPresent; // 是否为百分比格式

/** 总收入 */
@property (copy,nonatomic) NSString *totalin;
/** 前期 */
@property (copy,nonatomic) NSString *prepro;
/** 摄影二次销售 */
@property (copy,nonatomic) NSString *ptsell;
/** 化妆二次销售 */
@property (copy,nonatomic) NSString *mptsell;
/** 选片二次销售sptell */
@property (copy,nonatomic) NSString *sptsell;


@end
