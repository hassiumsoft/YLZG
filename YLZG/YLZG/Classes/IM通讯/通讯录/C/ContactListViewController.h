//
//  ContactListViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface ContactListViewController : SuperViewController

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyViewWithBadgeNumber:(NSInteger) number;
// 刷新未处理好友请求
- (void)refreshUntreatedApplys;

@end
