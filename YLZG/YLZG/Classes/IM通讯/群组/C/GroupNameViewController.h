//
//  GroupNameViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "YLGroup.h"

typedef NS_ENUM(NSInteger,ChangeNameDspCreate) {
    CreateGroupType,  // 建群
    ChangeNameType,   // 修改名称
    ChangeDspTye      // 修改简介
};

@interface GroupNameViewController : SuperViewController

@property (copy,nonatomic) void (^NameBlock)(NSString *name);

@property (assign,nonatomic) ChangeNameDspCreate nameType;

@property (strong,nonatomic) YLGroup *groupModel;

@property (copy,nonatomic) void (^YLGroupModelBlock)(YLGroup *groupModel);

@end
