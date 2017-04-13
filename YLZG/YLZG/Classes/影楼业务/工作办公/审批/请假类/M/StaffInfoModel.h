//
//  StaffInfoModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffInfoModel : NSObject

/** 生日 */
@property (nonatomic, copy) NSString * birth;
/** 加入时间 */
@property (nonatomic, assign) NSTimeInterval createtime;
@property (nonatomic, copy) NSString * dept;
@property (nonatomic, copy) NSString * gender;
/** 头像URL */
@property (nonatomic, copy) NSString * head;
@property (nonatomic, copy) NSString * is_register_easemob;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * loginip;
@property (nonatomic, copy) NSString * logintime;
/** 手机号码 */
@property (nonatomic, copy) NSString * mobile;
/** 昵称 */
@property (nonatomic, copy) NSString * nickname;
/** ERP密码 */
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * qq;
/** 真实昵称 */
@property (nonatomic, copy) NSString * realname;
/** sid --- 所在店铺的ID */
@property (nonatomic, copy) NSString * sid;
@property (nonatomic, copy) NSString * store_simple_name;
/** suid :员工 */
@property (nonatomic, copy) NSString * suid;
/** type --- 1是店长、0是店员 */
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * uid;
/** ERP登录账户 */
@property (nonatomic, copy) NSString * username;

/** 多选里的是否被选中 */
@property (assign,nonatomic) BOOL isSelected;
/** 索引 */
@property (assign,nonatomic) NSInteger index;

@end
