//
//  DetialBanciModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** 排班制时detial下的字典数组 **********/

@interface DetialBanciModel : NSObject

@property (copy,nonatomic) NSString *classid;

@property (copy,nonatomic) NSString *classname;

@property (copy,nonatomic) NSString *date;

@property (nonatomic, copy) NSString * start;

@property (nonatomic, copy) NSString * end;

@property (assign,nonatomic) BOOL isSelected;

@end
