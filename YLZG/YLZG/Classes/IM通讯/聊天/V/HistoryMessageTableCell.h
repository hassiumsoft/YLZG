//
//  HistoryMessageTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


/****** 搜索历史消息的cell *****/
@interface HistoryMessageTableCell : UITableViewCell

/** 联系人模型 */
@property (strong,nonatomic) ContactersModel *contactModel;
/** 最后一条消息 */
@property (copy,nonatomic) NSString *lastMessage;
/** 时间 */
@property (copy,nonatomic) NSString *time;

+ (instancetype)sharedHistoryCell:(UITableView *)tableView;

@end
