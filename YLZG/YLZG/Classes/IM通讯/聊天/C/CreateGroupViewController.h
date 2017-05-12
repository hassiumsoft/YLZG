//
//  CreateGroupViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface CreateGroupViewController : SuperViewController

/** 初始化的时候把另外一个同事模型传过来 */
- (instancetype)initWithAnother:(ContactersModel *)otherContact;
/** 创建完毕之后的回调。Pop到主界面 */
//@property (copy,nonatomic) void (^CreatedBlock)();

@end
