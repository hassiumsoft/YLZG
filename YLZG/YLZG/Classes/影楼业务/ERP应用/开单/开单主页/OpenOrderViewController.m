//
//  OpenOrderViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "OpenOrderViewController.h"
#import "NoDequTableCell.h"
#import "RightBadgeView.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "EditProductCell.h"
#import <MJExtension.h>
#import "ChangeTaoxiController.h"
#import "OpenOrderTableCell.h"
#import "CusTypeViewController.h"
#import "LixianOrderController.h"
#import "CardNumViewController.h"
#import "SpotViewController.h"
#import "TaoxiTypeViewController.h"
#import "AllTaoxiProductModel.h"
#import "AllProductList.h"
#import "AllProductModel.h"


#define ProductHeight 70

@interface OpenOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 开单表格 */
@property (strong,nonatomic) UITableView *orderTableView;
/** 开单表格数据源 */
@property (copy,nonatomic) NSArray *orderArray;
/** 套系产品表格 */
@property (strong,nonatomic) UITableView *productTableView;
/** 套系产品数据源 */
@property (strong,nonatomic) NSMutableArray *productArray;
/** 开单表格FootView */
@property (strong,nonatomic) UIView *footView;
/** 产品表格FootView */
@property (strong,nonatomic) UIView *proFootView;


/** 客户姓名* */
@property (strong,nonatomic) UITextField *cusNameField;
/** 客户电话* */
@property (strong,nonatomic) UITextField *cusPhoneField;
/** 客户来源* */
@property (copy,nonatomic) NSString *cusTypeStr;
/** 客户姓名2 */
@property (strong,nonatomic) UITextField *cusNameField2;
/** 客户电话2 */
@property (strong,nonatomic) UITextField *cusPhoneField2;

/** 套系类别* */
@property (copy,nonatomic) NSString *taoxiClassStr;
/** 套系名称* */
@property (copy,nonatomic) NSString *taoxiNameStr;
/** 套系金额* */
@property (strong,nonatomic) UITextField *taoxiPriceField;
/** 套系产品json* */
@property (strong,nonatomic) NSString *taoxiProductJson;



/** 风景* */
@property (copy,nonatomic) NSString *spotJsonStr;
@property (copy,nonatomic) NSString *spotStr;
/** 入底* */
@property (strong,nonatomic) UITextField *rudiField;
/** 入册* */
@property (strong,nonatomic) UITextField *ruceField;
/** 会员卡号 */
@property (copy,nonatomic) NSString *cardNumStr;
/** 订单备注 */
@property (strong,nonatomic) UITextField *beizhuField;


@end

@implementation OpenOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开单";
    [self setupSubViews];
}
#pragma mark - 获取表格
- (void)setupSubViews
{
    self.orderArray = @[@[@"客户姓名*",@"客户电话*",@"客户来源*",@"客户姓名2",@"客户电话2"],@[@"套系类别*",@"套系名称*",@"套系金额*",@"套系产品*"],@[@"选择风景*",@"入底*",@"入册*",@"会员卡号",@"订单备注"]];
    
    [self.view addSubview:self.orderTableView];
    self.orderTableView.tableFooterView = self.footView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.orderTableView) {
        return self.orderArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.orderTableView) {
        return [self.orderArray[section] count];
    }else{
        return self.productArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.orderTableView) {
        UITableViewCell *orderCell = [self CreateOrderTableCell:tableView IndexPath:indexPath];
        return orderCell;
    } else {
        UITableViewCell *orderCell = [self CreateProductCell:tableView IndexPath:indexPath];
        return orderCell;
    }
    
}
- (UITableViewCell *)CreateOrderTableCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 客户信息
        if (indexPath.row == 0) {
            // 客户姓名*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.cusNameField];
            return cell;
        }else if (indexPath.row == 1){
            // 客户电话*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.cusPhoneField];
            return cell;
        }else if (indexPath.row == 2){
            // 客户来源*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusTypeStr;
            return cell;
        }else if (indexPath.row == 3){
            // 客户姓名2
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.cusNameField2];
            return cell;
        }else {
            // 客户电话2
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.cusPhoneField2];
            return cell;
        }
    }else if (indexPath.section == 1) {
        // 套系产品
        if (indexPath.row == 0) {
            // 套系类别*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.taoxiClassStr;
            return cell;
        }else if (indexPath.row == 1){
            // 套系名称*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.taoxiNameStr;
            return cell;
        }else if (indexPath.row == 2){
            // 套系金额*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.taoxiPriceField];
            return cell;
        }else {
            // 套系产品*
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            NSLog(@"self.productArray = %@",self.productArray);
            if (self.productArray.count >= 1) {
                // 添加产品表格
                
                self.productTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, self.productArray.count * ProductHeight + self.proFootView.height);
                
                [cell.contentView addSubview:self.productTableView];
                [self.productTableView reloadData];
            }
            return cell;
        }
    }else {
        // 其他信息
        if (indexPath.row == 0) {
            // 选择风景
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.spotStr;
            return cell;
        }else if (indexPath.row == 1){
            // 入底
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.rudiField];
            return cell;
        }else if (indexPath.row == 2){
            // 入册
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.ruceField];
            return cell;
        }else if (indexPath.row == 3){
            // 会员卡号
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cardNumStr;
            return cell;
        }else {
            // 订单备注
            OpenOrderTableCell *cell = [OpenOrderTableCell sharedOpenOrderTableCell:tableView];
            cell.nameLabel.text = self.orderArray[indexPath.section][indexPath.row];
            [cell.contentLabel removeFromSuperview];
            [cell.contentView addSubview:self.beizhuField];
            return cell;
        }
    }
}
- (UITableViewCell *)CreateProductCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    TaoxiProductModel *model = self.productArray[indexPath.item];
    EditProductCell *cell = [EditProductCell sharedEditProductCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 客户信息
        if (indexPath.row == 2) {
            // 客户来源
            CusTypeViewController *cusType = [CusTypeViewController new];
            cusType.SelectBlock = ^(NSString *CusType){
                self.cusTypeStr = CusType;
                [self.orderTableView reloadData];
            };
            [self.navigationController pushViewController:cusType animated:YES];
        }
    }else if (indexPath.section == 1){
        // 套系产品
        if (indexPath.row == 0) {
            // 选择套系类别
            TaoxiTypeViewController *taoxiType = [[TaoxiTypeViewController alloc]init];
            taoxiType.SelectBlock = ^(NSString *TaoxiType){
                self.taoxiClassStr = TaoxiType;
                [self.orderTableView reloadData];
            };
            [self.navigationController pushViewController:taoxiType animated:YES];
        }else if (indexPath.row == 1){
            // 选择套系名称
            ChangeTaoxiController *changeTaoxi = [ChangeTaoxiController new];
            changeTaoxi.SelectBlock = ^(TaoxiNamePrice *taoxiNamePrice){
                self.taoxiPriceField.text = taoxiNamePrice.set_price;
                self.taoxiNameStr = taoxiNamePrice.set_name;
                [self.orderTableView reloadData];
                // 加载套系产品列表
                [self loadProductData];
            };
            [self.navigationController pushViewController:changeTaoxi animated:YES];
        }else if (indexPath.row == 2){
            // 套系金额
            
        }else {
            // 产品列表
            
        }
    }else {
        // 其他信息
        if (indexPath.row == 0) {
            // 选择风景
            SpotViewController *spotVC = [SpotViewController new];
            spotVC.SelectBlock = ^(NSString *spotJson,NSString *place){
                self.spotStr = place;
                self.spotJsonStr = spotJson;
                [self.orderTableView reloadData];
            };
            [self.navigationController pushViewController:spotVC animated:YES];
        }else if(indexPath.row == 3){
            // 会员卡号
            CardNumViewController *card = [CardNumViewController new];
            card.SelectCardNum = ^(NSString *cardNum){
                self.cardNumStr = cardNum;
                [self.orderTableView reloadData];
            };
            [self.navigationController pushViewController:card animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.orderTableView) {
        
        if (indexPath.section == 1 && indexPath.row == 3) {
            if (self.productArray.count >= 1) {
                NSInteger count = self.productArray.count;
                return ProductHeight*count + self.proFootView.height + 48;
            }else{
                return 48;
            }
        }else{
            return 48;
        }
    } else {
        return ProductHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.orderTableView) {
        NSArray *titleArr = @[@"👱客户信息",@"📷套系产品",@"🍂其他信息"];
        UIView *headV = [UIView new];
        
        UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
        xian.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
        [headV addSubview:xian];
        
        headV.backgroundColor = MainColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, SCREEN_WIDTH - 30, 30)];
        label.text = titleArr[section];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [headV addSubview:label];
        return headV;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.orderTableView) {
        return 30;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
#pragma mark - 其他方法
// - 获取数据-- 如果这个之前没有被加载过，无法实现离线订单
- (void)loadProductData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:TaoxiProduct_Url,self.taoxiNameStr,account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.productArray = [NSMutableArray arrayWithCapacity:1];
        [self.productArray removeAllObjects];
        
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        if (status == 1) {
            
            
            // 先判断self.taoName。空就是全部套系及下产品，不空就是该套系下的产品
            if (self.taoxiNameStr.length < 1) {
                // 全部
//                self.isAllProduct = YES;
                NSArray *result = [responseObject objectForKey:@"result"];
                NSMutableArray *bigArray = [NSMutableArray array]; // 装着外层模型的数组
                for (NSDictionary *dic in result) {
                    AllTaoxiProductModel *model  = [AllTaoxiProductModel mj_objectWithKeyValues:dic];
                    [bigArray addObject:model];
                }
                
                for (AllTaoxiProductModel *bigModel in bigArray) {
                    NSArray *oneList = bigModel.productList;  // 一个套系下的产品数组
                    for (TaoxiProductModel *model in oneList) {
                        [self.productArray addObject:model];
                    }
                }
                
                [self.orderTableView reloadData];
                
            }else{
                // 不是全部
//                self.isAllProduct = NO;
                NSArray *result = [responseObject objectForKey:@"result"];
                self.productArray = [TaoxiProductModel mj_objectArrayWithKeyValuesArray:result];
                
                [self.orderTableView reloadData];
                
            }
            
        }else{
            // 会出现自定义套系。没有对应的产品
            NSString *message = [responseObject objectForKey:@"message"];
            if ([message isEqualToString:@"没有套系包含的产品信息"]) {
                [self sendErrorWarning:@"该套系没有包含的产品信息，请到ERP后台添加产品信息"];
            }else{
                [self sendErrorWarning:message];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupRightBar];
}
- (void)setupRightBar
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        // 去离线订单界面
        [self.view endEditing:YES];
        
        LixianOrderController *lixian = [[LixianOrderController alloc]init];
        [self.navigationController pushViewController:lixian animated:YES];
    }];
    RightBadgeView *rightBar = [RightBadgeView sharedRightBadgeView];
    [rightBar addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBar];
    
}
#pragma mark - 懒加载
- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _orderTableView.dataSource = self;
        _orderTableView.delegate = self;
        _orderTableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _orderTableView;
}

- (UITableView *)productTableView
{
    if (!_productTableView) {
        _productTableView = [[UITableView alloc]init];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        _productTableView.scrollEnabled = NO;
        _productTableView.backgroundColor = HWRandomColor;
        _productTableView.tableFooterView = self.proFootView;
    }
    return _productTableView;
}
- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        _footView.backgroundColor = self.view.backgroundColor;
        _footView.userInteractionEnabled = YES;
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = MainColor;
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 4;
        [sendButton setFrame:CGRectMake(20, 50, SCREEN_WIDTH - 40, 40)];
        [sendButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footView addSubview:sendButton];
    }
    return _footView;
}
- (UIView *)proFootView
{
    if (!_proFootView) {
        _proFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _proFootView.backgroundColor = HWRandomColor;
        _proFootView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self showErrorTips:@"添加产品"];
        }];
        [_proFootView addGestureRecognizer:tap];
    }
    return _proFootView;
}
- (UITextField *)cusNameField
{
    if (!_cusNameField) {
        _cusNameField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _cusNameField.textAlignment = NSTextAlignmentRight;
        _cusNameField.textColor = RGBACOLOR(37, 37, 37, 1);
        _cusNameField.font = [UIFont systemFontOfSize:14];
        _cusNameField.placeholder = @"如：郭一鸣";
    }
    return _cusNameField;
}
- (UITextField *)cusPhoneField
{
    if (!_cusPhoneField) {
        _cusPhoneField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _cusPhoneField.textAlignment = NSTextAlignmentRight;
        _cusPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        _cusPhoneField.textColor = RGBACOLOR(37, 37, 37, 1);
        _cusPhoneField.font = [UIFont systemFontOfSize:14];
        _cusPhoneField.placeholder = @"如：13686865959";
    }
    return _cusPhoneField;
}

- (UITextField *)cusNameField2
{
    if (!_cusNameField2) {
        _cusNameField2 = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _cusNameField2.textAlignment = NSTextAlignmentRight;
        _cusNameField2.textColor = RGBACOLOR(37, 37, 37, 1);
        _cusNameField2.font = [UIFont systemFontOfSize:14];
        _cusNameField2.placeholder = @"如：刘菲菲";
    }
    return _cusNameField2;
}
- (UITextField *)cusPhoneField2
{
    if (!_cusPhoneField2) {
        _cusPhoneField2 = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _cusPhoneField2.keyboardType = UIKeyboardTypeNumberPad;
        _cusPhoneField2.textAlignment = NSTextAlignmentRight;
        _cusPhoneField2.textColor = RGBACOLOR(37, 37, 37, 1);
        _cusPhoneField2.font = [UIFont systemFontOfSize:14];
        _cusPhoneField2.placeholder = @"如：17626265959";
    }
    return _cusPhoneField2;
}
- (UITextField *)taoxiPriceField
{
    if (!_taoxiPriceField) {
        _taoxiPriceField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _taoxiPriceField.keyboardType = UIKeyboardTypeNumberPad;
        _taoxiPriceField.textAlignment = NSTextAlignmentRight;
        _taoxiPriceField.textColor = WechatRedColor;
        _taoxiPriceField.font = [UIFont systemFontOfSize:14];
        _taoxiPriceField.placeholder = @"如：999";
    }
    return _taoxiPriceField;
}
// 入底
- (UITextField *)rudiField
{
    if (!_rudiField) {
        _rudiField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _rudiField.keyboardType = UIKeyboardTypeNumberPad;
        _rudiField.textAlignment = NSTextAlignmentRight;
        _rudiField.textColor = RGBACOLOR(37, 37, 37, 1);
        _rudiField.font = [UIFont systemFontOfSize:14];
        _rudiField.placeholder = @"如：20";
    }
    return _rudiField;
}
// 入册
- (UITextField *)ruceField
{
    if (!_ruceField) {
        _ruceField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _ruceField.keyboardType = UIKeyboardTypeNumberPad;
        _ruceField.textAlignment = NSTextAlignmentRight;
        _ruceField.textColor = RGBACOLOR(37, 37, 37, 1);
        _ruceField.font = [UIFont systemFontOfSize:14];
        _ruceField.placeholder = @"如：20";
    }
    return _ruceField;
}
// 订单备注
- (UITextField *)beizhuField
{
    if (!_beizhuField) {
        _beizhuField = [[UITextField alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
        _beizhuField.textAlignment = NSTextAlignmentRight;
        _beizhuField.textColor = RGBACOLOR(37, 37, 37, 1);
        _beizhuField.font = [UIFont systemFontOfSize:14];
        _beizhuField.placeholder = @"带*号的为必填项";
    }
    return _beizhuField;
}

@end
