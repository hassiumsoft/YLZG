//
//  GoodsImageBroseVC.m
//  doucui
//
//  Created by 吴振松 on 16/10/12.
//  Copyright © 2016年 lootai. All rights reserved.
//

typedef enum {
    NavigationBarItemTypeBack,
    NavigationBarItemTypeLeft,
    NavigationBarItemTypeRight,
} NavigationBarItemType;

#import "WSPhotosBroseVC.h"
#import <LCActionSheet.h>


@interface WSPhotosBroseVC ()


@end

@implementation WSPhotosBroseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    
}

- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDel)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    
}




- (void)onClickDel {
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"删除这张照片？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if(self.showIndex >= 0 && self.showIndex < self.imageArray.count) {
                [self.imageArray removeObjectAtIndex:self.showIndex];
                [self.collectionView reloadData];
            }
            [self refreshTitle];
            if(self.imageArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } otherButtonTitles:@"确定删除", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@"1"];
    [sheet show];
    
}

- (void)onClickBack {
    if(self.completion) {
        NSMutableArray *array = [NSMutableArray new];
        for (WSImageModel *model in self.imageArray) {
            [array addObject:model.image];
        }
        self.completion(array);
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self onClickBack];
}

@end
