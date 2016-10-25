//
//  SpotViewController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@protocol SpotSelectDelegate <NSObject>

- (void)spotSelectWithSpotJson:(NSString *)spotJson PlaceStr:(NSString *)place;

@end

@interface SpotViewController : SuperViewController

@property (weak,nonatomic) id<SpotSelectDelegate> delegate;

@end
