//
//  PayMoneyViewController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


typedef NS_ENUM(NSInteger,PayMoneyType) {
    WechatPayType = 1,
    ZhifubaoType = 2,
    CashType = 3,
    BankCarPayType = 4
};


@interface PayMoneyViewController : SuperViewController

/** 订单ID */
@property (copy,nonatomic) NSString *orderID;
/** 价钱 */
@property (copy,nonatomic) NSString *price;

/** 支付方式 */
@property (assign,nonatomic) PayMoneyType payType;

@end
