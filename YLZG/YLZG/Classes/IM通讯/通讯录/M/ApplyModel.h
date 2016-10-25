//
//  ApplyModel.h
//  YLZG
//
//  Created by 周聪 on 16/9/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ApplyModel : NSObject
/** 申请头像 */
@property (copy,nonatomic) NSString *ahead;
/** 申请消息 */
@property (copy,nonatomic) NSString *amessage;
/** 申请名字 */
@property (copy,nonatomic) NSString *aname;
/** 申请昵称 */
@property (copy,nonatomic) NSString *anick;
/** 申请id */
@property (copy,nonatomic) NSString *auid;
/** 接收头像 */
@property (copy,nonatomic) NSString *fead;
/** 接收消息 */
@property (copy,nonatomic) NSString *fmessage;
/** 接收名字 */
@property (copy,nonatomic) NSString *fname;
/** 接收昵称 */
@property (copy,nonatomic) NSString *fnick;
/** 接收id */
@property (copy,nonatomic) NSString *fuid;

@property (copy,nonatomic) NSString *id;

@property (copy,nonatomic) NSString *status;

@end
