//
//  SuperTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/26.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperTableViewController.h"

@interface SuperTableViewController ()

@end

@implementation SuperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.view.backgroundColor = NorMalBackGroudColor;
    
}
- (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end
