//
//  ContactTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/6.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"

@interface ContactTableViewCell : UITableViewCell

/** 图片、头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 昵称 */
@property (strong,nonatomic) UILabel *nickNameLabel;
/** 红色通知 */
@property (strong,nonatomic) UILabel *addFriendLabel;

/** 通讯录好友模型 */
@property (strong,nonatomic) ContactersModel *contactModel;


+ (instancetype)sharedContactTableViewCell:(UITableView *)tableView;

@end
