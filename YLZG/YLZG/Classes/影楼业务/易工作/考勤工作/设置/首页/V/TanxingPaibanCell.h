//
//  TanxingPaibanCell.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanciModel.h"
#import "StaffInfoModel.h"


@protocol TanxingDelegate <NSObject>

- (void)tanxingPaibanWithRulesDict:(NSDictionary *)rulesDict;

@end


@interface TanxingPaibanCell : UITableViewCell


/** 班次模型 */
@property (strong,nonatomic) BanciModel *banciModel;
/** 考勤组人员的模型 */
@property (strong,nonatomic) StaffInfoModel *memModel;
/** 日期数组 */
@property (copy,nonatomic) NSArray *dateArray;

/** 大字典，改员工的排班信息 */
@property (strong,nonatomic) NSMutableDictionary *bigDict;


@property (weak,nonatomic) id<TanxingDelegate> delegate;



+ (instancetype)shatedTanxingPaibanCell:(UITableView *)tableView MemModel:(StaffInfoModel *)memModel BanciModel:(BanciModel *)banciModel DateArray:(NSArray *)dateArray;

@end
