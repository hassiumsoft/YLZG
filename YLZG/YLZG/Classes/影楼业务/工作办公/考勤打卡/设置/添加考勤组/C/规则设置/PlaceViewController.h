//
//  PlaceViewController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/12.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

@class BMKPoiInfo;
@protocol PlaceDidSelcedDelegate <NSObject>

- (void)placeDidselectedWithModel:(BMKPoiInfo *)model WithPlaceinfo:(NSDictionary *)dict;

@end

@interface PlaceViewController : SuperViewController

@property (weak,nonatomic) id<PlaceDidSelcedDelegate> delegate;

@end
