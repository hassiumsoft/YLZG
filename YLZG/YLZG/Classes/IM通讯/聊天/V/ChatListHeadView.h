//
//  ChatListHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatListHeadView : UIView

@property (strong,nonatomic) UIImageView *imageV;

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *descLabel;

@property (assign,nonatomic) BOOL isUnRead;

- (void)reloadData;

+ (instancetype)sharedChatListHeadView;

@end
