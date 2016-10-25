//
//  ChooseMemVController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"


@protocol ChooseMemDegate <NSObject>

- (void)chooseMemWithArray:(NSArray *)memArray;

@end

@interface ChooseMemVController : SuperViewController

@property (weak,nonatomic) id <ChooseMemDegate> delegate;

@end
