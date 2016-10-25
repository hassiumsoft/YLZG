//
//  QiaodaoMapViewController.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuperViewController.h"

@protocol QiaodaoMapViewControllerDelegate <NSObject>

- (void)sendLocationLatitudes:(double)latitude longitudes:(double)longitude andAddress:(NSString *)address;

@end

@interface QiaodaoMapViewController : SuperViewController

@property (nonatomic, strong) id<QiaodaoMapViewControllerDelegate> delegate;

@end
