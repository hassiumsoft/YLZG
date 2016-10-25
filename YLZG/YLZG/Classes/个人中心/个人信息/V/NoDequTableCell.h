//
//  NoDequTableCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDequTableCell : UITableViewCell

/** 右边内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 初始化 */
+ (instancetype)sharedNoDequTableCell;

@end
