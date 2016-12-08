//
//  CreateMobanViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CreateMobanViewController.h"
#import "WSImagePickerView.h"

@interface CreateMobanViewController ()

@property (strong,nonatomic) UIView *photoView;

@property (nonatomic, strong) WSImagePickerView *pickerView;


@end

@implementation CreateMobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建模板";
    [self setupSubViews];
}
- (void)setupSubViews
{
    
    self.photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 280)];
    self.photoView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.photoView];
    
    WSImagePickerConfig *config = [WSImagePickerConfig new];
    config.itemSize = CGSizeMake(80, 80);
    config.photosMaxCount = 9;
    
    
    WSImagePickerView *pickerView = [[WSImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) config:config];
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
//        weakSelf.photoViewHieghtConstraint.constant = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.navigationController = (HomeNavigationController *)self.navigationController;
    [self.photoView addSubview:pickerView];
    self.pickerView = pickerView;
    
    //refresh superview height
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
}



@end
