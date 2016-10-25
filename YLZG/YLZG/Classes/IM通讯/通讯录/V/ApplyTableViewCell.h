//
//  ApplyTableViewCell.h
//  YLZG
//
//  Created by 周聪 on 16/9/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyModel.h"

typedef enum : NSUInteger {
    AGREE_BUTTON = 0,
    UNAGREE_BUTTON,
} BUTTON_FLAG;
@class AgreeButton;
typedef void (^AgreeButtonEvent)(BUTTON_FLAG flag);


@interface ApplyTableViewCell : UITableViewCell
/** 图片、头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 昵称 */
@property (strong,nonatomic) UILabel *nickNameLabel;
/** 信息 */
@property (strong,nonatomic) UILabel *messageNameLabel;
/** 线 */
@property (strong,nonatomic) UIImageView *xian;

@property (strong,nonatomic) ApplyModel *aModel;

@property (nonatomic, copy) AgreeButtonEvent agreeBtn;

+ (instancetype)sharedAddFriendTableViewCell:(UITableView *)tableView;

@end
