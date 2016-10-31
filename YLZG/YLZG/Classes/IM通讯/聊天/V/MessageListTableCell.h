//
//  MessageListTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageListTableCell : UITableViewCell

@property (strong,nonatomic) EMConversation *model;

+ (instancetype)sharedMessageListCell:(UITableView *)tableView;

@end
