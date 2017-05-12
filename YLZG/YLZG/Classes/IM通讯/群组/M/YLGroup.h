//
//  YLGroup.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLGroup : NSObject

// 群组在雷哥服务器的ID
@property (copy,nonatomic) NSString * id;
// 群头像
@property (copy,nonatomic) NSString *head_img;
//成员人数
@property (nonatomic, copy) NSString * affiliations;
//是否允许成员邀请人
@property (nonatomic, copy) NSString * allowinvites;
//描述
@property (nonatomic, copy) NSString * dsp;
//环信群ID
@property (nonatomic, copy) NSString * gid;
//群名称
@property (nonatomic, copy) NSString * gname;
//最大成员数
@property (nonatomic, copy) NSString * maxusers;
//只有成员可发言
@property (nonatomic, copy) NSString * membersonly;
//群主
@property (nonatomic, copy) NSString * owner;
//是否为公开群
@property (assign,nonatomic) BOOL pub;
// 店铺ID
@property (copy,nonatomic) NSString *sid;


@end
