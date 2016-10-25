//
//  BanciButton.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetialBanciModel.h"

@interface BanciButton : UIButton

/** 日期 */
@property (copy,nonatomic) NSString *date;

@property (nonatomic, copy) NSString * start;

@property (nonatomic, copy) NSString * end;

/** detial对应的字典 */
@property (strong,nonatomic) DetialBanciModel *detialBanciModel;

@end
