//
//  UserInfoModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/26.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  独立于CoreData的用户信息模型
 */

@interface UserInfoModel : NSObject

/** 在雷哥服务器端的uid */
@property (copy,nonatomic) NSString *uid;
/** 加入时间 */
@property (copy,nonatomic  ) NSString *createtime;
/** ERP登录账户 */
@property (copy,nonatomic  ) NSString *username;
/** ERP密码 --- 登录后没有返回 */
@property (copy,nonatomic  ) NSString *password;


/** 影楼简称 */
@property (copy,nonatomic) NSString *store_simple_name;
/** 在APP上的昵称，聊天显示 */
@property (copy,nonatomic  ) NSString *nickname;
/** 真是名字，一般是影楼服务器设置好的 */
@property (copy,nonatomic) NSString *realname;
/** 手机号码 */
@property (copy,nonatomic  ) NSString *mobile;
/** 头像URL */
@property (copy,nonatomic  ) NSString *head;
/** 生日 */
@property (copy,nonatomic) NSString *birth;
/** type --- 1是店长、0是店员 */
@property (copy,nonatomic) NSString *type;
/** sid --- 所在店铺的ID */
@property (copy,nonatomic  ) NSString *sid;
/** suid??? */
@property (copy,nonatomic) NSString *suid;
/** 登录IP */
@property (copy,nonatomic) NSString *loginip;
/** 登录时间 */
@property (copy,nonatomic) NSString *logintime;

/** QQ */
@property (copy,nonatomic) NSString *qq;
/** vicp */
@property (copy,nonatomic) NSString *vcip;
/** 处于的考勤组 */
@property (copy,nonatomic) NSString *attence_group;
/** 所管理的考勤组 */
@property (copy,nonatomic) NSString *attence_admin_group;
/** 部门 */
@property (copy,nonatomic) NSString *dept;
/** 性别 */
@property (copy,nonatomic) NSString *gender;
/** 是否在环信服务器注册 */
@property (copy,nonatomic) NSString *is_register_easemob;
/** 城市 */
@property (copy,nonatomic) NSString *location;

//location = 北京,
//vcip = 0,
//attence_admin_group = ,
//nickname = 陈晨,
//dept = 门市部,
//logintime = <null>,
//realname = 陈晨,
//loginip = ,
//type = 2,
//sid = 9,
//is_register_easemob = 1,
//suid = <null>,
//birth = <null>,
//uid = 162,
//gender = 2,
//mobile = 13027554867,
//head = <null>,
//store_simple_name = aermei,
//modify_time = 1468466129,
//attence_group = 0,
//createtime = 1466496346,
//password = 888888,
//qq = 224876044,
//username = cchen


@end
