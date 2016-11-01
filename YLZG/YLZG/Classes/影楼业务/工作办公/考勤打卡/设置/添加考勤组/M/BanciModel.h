//
//  BanciModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/******* 班次模型classes ********/

@interface BanciModel : NSObject

@property (copy,nonatomic) NSString *classid;

@property (copy,nonatomic) NSString *classname;

@property (copy,nonatomic) NSString *start;

@property (copy,nonatomic) NSString *end;

@property (assign,nonatomic) BOOL isSelected;

@end
