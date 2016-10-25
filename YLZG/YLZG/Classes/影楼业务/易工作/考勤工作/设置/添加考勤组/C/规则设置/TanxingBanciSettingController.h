//
//  TanxingBanciSettingController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


@protocol TanxingBanSetDelegate <NSObject>

- (void)tanxingBanxiWithRulesJson:(NSString *)rulesJson;

@end

@interface TanxingBanciSettingController : SuperViewController

/** 班次模型数组 */
@property (strong,nonatomic) NSMutableArray *banciModelArray;
/** 考勤组人员数组 */
@property (strong,nonatomic) NSArray *membersArray;
/** 代理 */
@property (weak,nonatomic) id<TanxingBanSetDelegate> delegate;

@end
