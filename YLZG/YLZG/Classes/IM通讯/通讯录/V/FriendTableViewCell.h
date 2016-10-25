//
//  FriendTableViewCell.h
//  YLZG
//
//  Created by 周聪 on 16/9/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"
@class AddButton;
typedef void (^AddButtonEvent)();
@interface FriendTableViewCell : UITableViewCell

/** 图片、头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 昵称 */
@property (strong,nonatomic) UILabel *nickNameLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *loactionNameLabel;
/** 线 */
@property (strong,nonatomic) UIImageView *xian;
/** 通讯录好友模型 */
@property (strong,nonatomic) ContactersModel *contactModel;

@property (nonatomic, copy) AddButtonEvent addBtn;

+ (instancetype)sharedFriendTableViewCell:(UITableView *)tableView;

@end
