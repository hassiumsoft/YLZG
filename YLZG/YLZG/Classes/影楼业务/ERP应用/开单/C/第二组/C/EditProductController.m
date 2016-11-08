//
//  EditProductController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "EditProductController.h"
#import "EditProductCell.h"
#import "AddProductController.h"
#import "NormalTableCell.h"
#import "LCActionSheet.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "TaoxiProductModel.h"
#import "CalendarHomeViewController.h"
#import "ZCAccountTool.h"
#import <Masonry.h>




@interface EditProductController ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UITextFieldDelegate,EditProductDelegate,AddProductVCDelegate>

{
    UIButton *mengBtn;
    UIView *editView;
    UITextField *priceField; // 价格输入框
    UITextField *numField; // 数量输入框
    NSString *sumPrice; // 总价格
    CGFloat sum;
}

@property (strong,nonatomic) UITableView *tableView;

//@property (strong,nonatomic) TaoxiProductModel *productModel;

@property (strong,nonatomic) NSDictionary *modelDict;

@end

@implementation EditProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.taoName.length > 0) {
        self.title = [NSString stringWithFormat:@"编辑%@",self.taoName];
    }else{
        self.title = @"编辑套系产品";
    }
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 75;
    [self.view addSubview:self.tableView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    // tableHeaderView
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    headV.userInteractionEnabled = YES;
    headV.backgroundColor = NorMalBackGroudColor;
    
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"product_bg"]];
    imagev.userInteractionEnabled = YES;
    imagev.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, 75 - 8);
    [headV addSubview:imagev];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProduct)];
    tap.numberOfTapsRequired = 1;
    [imagev addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = headV;
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    footLabel.backgroundColor = self.view.backgroundColor;
    footLabel.text = @"💡左滑可编辑产品";
    footLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.tableView.tableFooterView = footLabel;
}
- (void)confirm
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaoxiProductModel *model = self.array[indexPath.section];
    EditProductCell *cell = [EditProductCell sharedEditProductCell:tableView];
    model.section = indexPath.section;
    cell.model = model;
    if (!model.isJiaji) {
        model.jiajiTime = @"";
    }
        
    return cell;
}

#pragma mark - 修改套系数量和价格
- (void)changeProduct
{
    // 问题TaoxiProductModel没传递下来
    
    TaoxiProductModel *model = [TaoxiProductModel mj_objectWithKeyValues:self.modelDict];
    
    model.pro_price = priceField.text;
    model.pro_num = numField.text;
    
    
    [self removeMengBtn];
    
    KGLog(@"pro_price = %@,pro_num = %@,section = %ld",model.pro_price,model.pro_num,(long)model.section);
    
    [self.array replaceObjectAtIndex:model.section withObject:model];
    
    
    [self.tableView reloadData];
    
}
- (void)removeMengBtn
{
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.4f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"suckEffect";
//    animation.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [mengBtn removeFromSuperview];
    [editView removeFromSuperview];
}
#pragma mark - 消除警告
- (void)editProductArray:(NSArray *)productlist
{
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"除移" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除该产品
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"本地除移该套系产品，您仍可点击添加产品" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.array removeObjectAtIndex:indexPath.section];
                [self.tableView reloadData];
            }
        } otherButtonTitles:@"确定除移", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *jiajiAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加急" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 加急该产品
        CalendarHomeViewController *calender = [[CalendarHomeViewController alloc]init];
        calender.calendartitle = @"选择加急时间";
        [calender setAirPlaneToDay:365 ToDateforString:nil];
        __weak EditProductController * weakSelf = self;
        calender.calendarblock = ^(CalendarDayModel *model){
            
            NSString *jiajiTime = [NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)(unsigned long)model.month,(unsigned long)model.day];
            
            TaoxiProductModel *taoxiModel = weakSelf.array[indexPath.section];
            taoxiModel.isJiaji = YES;
            taoxiModel.jiajiTime = jiajiTime;
            
            [weakSelf.array replaceObjectAtIndex:indexPath.section withObject:taoxiModel];
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:calender animated:YES];
        
    }];
    jiajiAction.backgroundColor = [UIColor brownColor];
    
    return @[deleteAction,jiajiAction];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    if (section == self.array.count - 1) {
        // 最后一行
        UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
        foot.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//        label.text = [NSString stringWithFormat:@"￥%@",sumPrice];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        label.textColor = RGBACOLOR(232, 67, 67, 1);
        label.textAlignment = NSTextAlignmentRight;
        [foot addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(foot.mas_centerY);
            make.right.equalTo(foot.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        return foot;
    }else{
        // 前面几行
        UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
        foot.backgroundColor = self.view.backgroundColor;
        return foot;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.array.count > 0) {
        if (section == self.array.count - 1) {
            return 40;
        }else{
            return 10;
        }
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)addProduct
{
    AddProductController *addProduct = [[AddProductController alloc]init];
    addProduct.delegate = self;
    [self.navigationController pushViewController:addProduct animated:YES];
}
#pragma mark - 接收回调过来的产品
- (void)addProductModel:(AllProductList *)model
{
    // 需要先转义一下
    TaoxiProductModel *product = [[TaoxiProductModel alloc]init];
    product.pro_name = model.pro_name;
    product.pro_price = model.pro_price;
    
    
    product.pro_num = @"1";
    [self.array addObject:product];
    [self.tableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeMengBtn];
    
    if ([self.delegate respondsToSelector:@selector(editProductArray:)]) {
        [self.delegate editProductArray:self.array];
    }
    
}

@end
