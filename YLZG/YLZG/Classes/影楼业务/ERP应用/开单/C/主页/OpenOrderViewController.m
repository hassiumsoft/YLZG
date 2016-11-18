//
//  OpenOrderViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "OpenOrderViewController.h"
#import "NoDequTableCell.h"
#import "OrderPhoneController.h"
#import "OrderNameController.h"
#import "ChangeTaoxiController.h"
#import "TaoxiNamePrice.h"
#import "EditProductController.h"
#import "ZCAccountTool.h"
#import "AddProductController.h"
#import <MJExtension.h>
#import "LixianOrderController.h"
#import "AllTaoxiProductModel.h"
#import "AFNetworkReachabilityManager.h"
#import "OfflineDataManager.h"
#import "NSString+StrCategory.h"
#import "SpotViewController.h"
#import "ChangeOrderPriceController.h"
#import "PayMoneyViewController.h"
#import "HTTPManager.h"
#import <Masonry.h>
#import "RightBadgeView.h"
#import "TaoxiTypeViewController.h"
#import "CusTypeViewController.h"
#import "CardNumViewController.h"
#import "RudiRuceVController.h"


#define OrderDescPlace @"您可写上开单人的名字或者其他可备注情况(带*选项为必填)"

@interface OpenOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderNameDelegate,OrderPhoneDelegate,changeTaoxiDelegate,UITextViewDelegate,EditProductDelegate,ChangeOrderPriceDelegate,SpotSelectDelegate>
{
    BOOL isPush; // 是否进去过产品界面
}

/** 发送按钮 */
@property (strong,nonatomic) UIButton *sendBtn;;
/** UITableView */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSArray *array;
/** titleArray */
@property (copy,nonatomic) NSArray *headArray;
/** 客户姓名 */
@property (copy,nonatomic) NSString *cusName;
/** 客户电话 */
@property (copy,nonatomic) NSString *cusPhone;
/** 套系名称 */
@property (copy,nonatomic) NSString *taoName;
/** 景点json */
@property (copy,nonatomic) NSString *spotJson;
/** 景点Str */
@property (copy,nonatomic) NSString *spotStr;
/** 套系金额 */
@property (copy,nonatomic) NSString *taoPrice;
/** 订单说明 */
@property (strong,nonatomic) UITextView *orderDesc;
/** 显示部分产品名称 */
@property (copy,nonatomic) NSString *someProduct;
/** 是否为全部产品 */
@property (assign,nonatomic) BOOL isAllProduct;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 装着产品的数组 */
@property (strong,nonatomic) NSMutableArray *productArray;


/** 套系类别 */
@property (copy,nonatomic) NSString *categoryStr;
/** 会员卡号 */
@property (copy,nonatomic) NSString *CardNumber;
/** 入底 */
@property (copy,nonatomic) NSString *negativeNum;
/** 入册 */
@property (copy,nonatomic) NSString *albumNum;
/** 客户来源 */
@property (copy,nonatomic) NSString *sourceStr;
/** 客户姓名2 */
@property (copy,nonatomic) NSString *cusName2;
/** 客户电话2 */
@property (copy,nonatomic) NSString *cusPhone2;



@end

@implementation OpenOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开单";
    [self setupSubViews];
    [YLNotificationCenter addObserver:self selector:@selector(saveAlert:) name:YLOffLineOrderAlert object:nil];
    
}

#pragma mark - 建表
- (void)setupSubViews
{
    self.headArray = @[@"客户信息",@"套系信息",@"其他信息",@"订单备注"];
    self.array = @[@[@"客户姓名*",@"客户电话*",@"客户来源*",@"客户姓名2",@"客户电话2"],@[@"套系类别*",@"套系名称*",@"套系金额*"],@[@"选择风景*",@"入     底*",@"入     册*",@"会员卡号"],@[@"订单说明",@"提交订单"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 客户名字
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusName;
            return cell;
        } else if(indexPath.row == 1){
            // 客户电话
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusPhone;
            return cell;
            
        }else if (indexPath.row == 2){
            // 客户来源
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.contentLabel.text = self.sourceStr;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
            
        }else if (indexPath.row == 3){
            // 客户名字2
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusName2;
            return cell;
        }else{
            // 客户电话2
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusPhone2;
            return cell;
        }
    } else if(indexPath.section == 1){
        // 套系名称 && 套系金额 || 套系产品
        NSArray *tempArr = self.array[1];
        if (tempArr.count == 3) {
            // 初始阶段
            
            if (indexPath.row == 0) {
                // 套系类别
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.categoryStr;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
                
            }else if (indexPath.row == 1) {
                // 套系名称
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoName;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else{
                // 套系价格
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoPrice;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }
        }else{
            // 添加一行之后
            if (indexPath.row == 0) {
                // 套系类别
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.categoryStr;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else if(indexPath.row == 1) {
                // 套系名称
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoName;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            } else if(indexPath.row == 2){
                // 套系价格
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoPrice;
                cell.contentLabel.textColor = RGBACOLOR(232, 19, 28, 1);
                cell.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
                
            }else{
                // ⚠️套系产品
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.someProduct;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 选择风景
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.contentLabel.text = self.spotStr;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
            
        } else if(indexPath.row == 1){
            
            // 入底
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.contentLabel.text = self.negativeNum;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else if (indexPath.row == 2){
            // 入册
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.contentLabel.text = self.albumNum;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else{
            // 会员卡号
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.contentLabel.text = self.CardNumber;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            // 订单说明
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentLabel removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 90, 21)];
            titleL.text = self.array[indexPath.section][indexPath.row];
            titleL.font = [UIFont systemFontOfSize:15];
            titleL.textColor = RGBACOLOR(20, 20, 20, 1);
            titleL.userInteractionEnabled = YES;
            [cell addSubview:titleL];
            
            self.orderDesc = [[UITextView alloc]init];
            self.orderDesc.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
            self.orderDesc.userInteractionEnabled = YES;
            self.orderDesc.delegate = self;
            self.orderDesc.text = OrderDescPlace;
            self.orderDesc.textColor = [UIColor lightGrayColor];
            [cell addSubview:self.orderDesc];
            [self.orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleL.mas_right);
                make.right.equalTo(cell.mas_right).offset(-17);
                make.top.equalTo(cell.mas_top).offset(2);
                make.height.equalTo(@63);
            }];
            
            return cell;
        } else {
            // 提交订单
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel removeFromSuperview];
            [cell.contentLabel removeFromSuperview];
            cell.backgroundColor = self.view.backgroundColor;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_sendBtn setBackgroundColor:MainColor];
            _sendBtn.layer.cornerRadius = 4;
            [_sendBtn setTitle:self.array[indexPath.section][indexPath.row] forState:UIControlStateNormal];
            [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_sendBtn addTarget:self action:@selector(openOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            _sendBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            [cell addSubview:_sendBtn];
            [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.mas_centerX);
                make.left.equalTo(@20);
                make.bottom.equalTo(cell.mas_bottom).offset(-32);
                make.height.equalTo(@40);
            }];
            
            return cell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 客户姓名
            OrderNameController *orderName = [[OrderNameController alloc]init];
            orderName.delegate = self;
            [self.navigationController pushViewController:orderName animated:YES];
        }else if(indexPath.row == 1){
            // 客户电话
            OrderPhoneController *phone = [[OrderPhoneController alloc]init];
            phone.delegate = self;
            [self.navigationController pushViewController:phone animated:YES];
        }else if (indexPath.row == 2){
            // 客户来源
            CusTypeViewController *cus = [CusTypeViewController new];
            cus.SelectBlock = ^(NSString *CusType){
                self.sourceStr = CusType;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:cus animated:YES];
        }else if (indexPath.row == 3){
            // 客户姓名2
            OrderNameController *orderName = [[OrderNameController alloc]init];
            orderName.NameBlock = ^(NSString *name2){
                self.cusName2 = name2;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:orderName animated:YES];
        }else{
            // 客户电话2
            OrderPhoneController *phone = [[OrderPhoneController alloc]init];
            phone.PhoneBlock = ^(NSString *phone2){
                self.cusPhone2 = phone2;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:phone animated:YES];
        }
    }else if (indexPath.section == 1){
        NSArray *tempArr = self.array[1];
        if (tempArr.count == 3) {
            
            if (indexPath.row == 0) {
                // 套系类别
                TaoxiTypeViewController *taoxiTypeVC = [TaoxiTypeViewController new];
                taoxiTypeVC.SelectBlock = ^(NSString *TaoxiType){
                    self.categoryStr = TaoxiType;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:taoxiTypeVC animated:YES];
                
            }else if(indexPath.row == 1){
                // 套系名称
                // 改变套系self.taoPrice
                ChangeTaoxiController *changeTaoxi = [[ChangeTaoxiController alloc]init];
                changeTaoxi.delegate = self;
                [self.navigationController pushViewController:changeTaoxi animated:YES];
                
            }else{
                // 套系价格
                ChangeTaoxiController *changeTaoxi = [[ChangeTaoxiController alloc]init];
                changeTaoxi.delegate = self;
                [self.navigationController pushViewController:changeTaoxi animated:YES];
            }
        }else{
            // 添加一行之后
            if (indexPath.row == 0) {
                // 套系类别
                TaoxiTypeViewController *taoxiTypeVC = [TaoxiTypeViewController new];
                taoxiTypeVC.SelectBlock = ^(NSString *TaoxiType){
                    self.categoryStr = TaoxiType;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:taoxiTypeVC animated:YES];
            }else if (indexPath.row == 1) {
                // 改变套系self.taoPrice
                ChangeTaoxiController *changeTaoxi = [[ChangeTaoxiController alloc]init];
                changeTaoxi.delegate = self;
                [self.navigationController pushViewController:changeTaoxi animated:YES];
            } else if(indexPath.row == 2){
                // 改变价格
                ChangeOrderPriceController *changePrice = [ChangeOrderPriceController new];
                changePrice.price = self.taoPrice;
                changePrice.delegate = self;
                [self.navigationController pushViewController:changePrice animated:YES];
            }else{
                // 编辑套系产品
                
                EditProductController *product = [[EditProductController alloc]init];
                
                isPush = YES;
                product.taoName = self.taoName;
                product.delegate = self;
                product.array = self.productArray;
                [self.navigationController pushViewController:product animated:YES];
                
            }
            
        }
    }else if(indexPath.section == 2){
        //入底入册那些
        
        if (indexPath.row == 0) {
            
            // 选择景区
            SpotViewController *spotVC = [SpotViewController new];
            spotVC.delegate = self;
            [self.navigationController pushViewController:spotVC animated:YES];
            
        } else if(indexPath.row == 1){
            // 入底
            RudiRuceVController *rudi = [RudiRuceVController new];
            rudi.rudiruceType = YES;
            rudi.title = @"入底";
            rudi.RudiRuceBlock = ^(NSString *numberStr){
                self.negativeNum = numberStr;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:rudi animated:YES];
        }else if (indexPath.row == 2){
            // 入册
            RudiRuceVController *rudi = [RudiRuceVController new];
            rudi.title = @"入册";
            rudi.rudiruceType = NO;
            rudi.RudiRuceBlock = ^(NSString *numberStr){
                self.albumNum = numberStr;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:rudi animated:YES];
        }else{
            // 会员卡号
            CardNumViewController *card = [CardNumViewController new];
            card.SelectCardNum = ^(NSString *cardNum){
                self.CardNumber = cardNum;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:card animated:YES];
    }
        
    }
}



#pragma mark - 代理
- (void)orderCusName:(NSString *)cusName
{
    self.cusName = cusName;
    [self.tableView reloadData];
}
- (void)changeOrderPrice:(NSString *)changedPrice
{
    self.taoPrice = changedPrice;
    [self.tableView reloadData];
}
- (void)orderCusPhone:(NSString *)phoneNum
{
    self.cusPhone = phoneNum;
    [self.tableView reloadData];
}
- (void)spotSelectWithSpotJson:(NSString *)spotJson PlaceStr:(NSString *)place
{
    self.spotStr = place;
    [self.tableView reloadData];
    
    self.spotJson = spotJson;
}
#pragma mark - 选择完套系之后的回调
- (void)changeTaoxiModel:(TaoxiNamePrice *)namePrice
{
    self.taoName = namePrice.set_name;
    self.taoPrice = namePrice.set_price;
    
    /******* ⚠️先增加一行⚠️ ********/

    self.array = @[@[@"客户姓名*",@"客户电话*",@"客户来源*",@"客户姓名2",@"客户电话2"],@[@"套系类别*",@"套系名称*",@"套系金额*",@"套系产品*"],@[@"选择风景*",@"入     底*",@"入     册*",@"会员卡号"],@[@"订单说明",@"提交订单"]];
    
    [self.tableView reloadData];
    
    /** 获取该套系下的产品，没有则获取全部产品 **/
    [self loadProductData];
}

#pragma mark - 获取数据-- 如果这个之前没有被加载过，无法实现离线订单
- (void)loadProductData
{
    ZCAccount *account = [ZCAccountTool account];
    //    self.taoName = @"";  // ⚠️⚠️后面需要注释⚠️⚠️
    NSString *url = [NSString stringWithFormat:TaoxiProduct_Url,self.taoName,account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        self.productArray = [NSMutableArray array]; //
        if (status == 1) {
            // 先判断self.taoName。空就是全部套系及下产品，不空就是该套系下的产品
            if (self.taoName.length < 1) {
                // 全部
                self.isAllProduct = YES;
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
                TaoxiProductModel *mmmodel = [self.productArray firstObject];
                self.someProduct = [NSString stringWithFormat:@"%@等等",mmmodel.pro_name];
                [self.tableView reloadData];
                
            }else{
                // 不是全部
                self.isAllProduct = NO;
                NSArray *result = [responseObject objectForKey:@"result"];
                self.productArray = [TaoxiProductModel mj_objectArrayWithKeyValuesArray:result];
                TaoxiProductModel *mmmodel = [self.productArray firstObject];
                self.someProduct = [NSString stringWithFormat:@"%@等等",mmmodel.pro_name];
                [self.tableView reloadData];
                
            }
            
        }else{
            // 会出现自定义套系。没有对应的产品
            NSString *message = [responseObject objectForKey:@"message"];
            if ([message isEqualToString:@"没有套系包含的产品信息信息"]) {
                EditProductController *edit = [EditProductController new];
                [self.navigationController pushViewController:edit animated:YES];
            }else{
                [self sendErrorWarning:message];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 48;
    } else if(indexPath.section == 1){
        return 48;
    }else if (indexPath.section == 2){
        return 48;
    }else{
        if (indexPath.row == 0) {
            return 65;
        }else{
            return 118;
        }
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:OrderDescPlace]) {
        textView.text = @"";
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = OrderDescPlace;
        textView.font = [UIFont systemFontOfSize:12];
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [UIView new];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    [headV addSubview:xian];
    
    headV.backgroundColor = MainColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, SCREEN_WIDTH - 15, 30)];
    label.text = self.headArray[section];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [headV addSubview:label];
    return headV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
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


#pragma mark - 产品信息的回调
- (void)editProductArray:(NSArray *)productlist
{
    
    // 计算价格或者刷新产品名称   ⚠️未完成⚠️
    TaoxiProductModel *lastModel = [productlist firstObject];
    self.someProduct = [NSString stringWithFormat:@"%@等等",lastModel.pro_name];
    //    self.taoPrice = @"2718";
    [self.tableView reloadData];
    isPush = YES;
    
    NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:productlist];
    
    NSString *json = [self toJsonStr:jsonArray];
    if (json) {
        self.jsonArray = [NSString stringWithString:json];
    }else{
        self.jsonArray = nil;
    }
    KGLog(@"self.jsonArray = %@",self.jsonArray);
    
}
#pragma mark - 点击开单
- (void)openOrder:(UIButton *)sender
{
    // 1.判断网络状况。正常那就发送订单，不正常则保存到离线订单
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 无网络
                [self saveData];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // wifi网络
                [self sendOrder];
//                [self saveData];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // 无线网络
                [self sendOrder];
//                [self saveData];
                break;
            }
            default:
                
                break;
        }
    }];
    
}
#pragma mark - 发送订单
- (void)sendOrder
{
    // 网络正常，发送
    
    
    if (self.cusName.length < 1) {
        [self showErrorTips:@"请完善姓名"];
        return;
    }
    if (![self.cusPhone isPhoneNum]) {
        [self showErrorTips:@"号码有误"];
        return;
    }
    if (self.taoName.length < 1) {
        [self showErrorTips:@"请选择套系"];
        return;
    }
    if (self.taoPrice.length < 1) {
        [self showErrorTips:@"请完善套系价格"];
        return;
    }
    if (self.spotJson.length < 1) {
        [self showErrorTips:@"请选择景点"];
        return;
    }
    if (self.sourceStr.length < 1) {
        [self showErrorTips:@"请选择客户来源"];
        return;
    }
    if (self.categoryStr.length < 1) {
        [self showErrorTips:@"请选择套系类别"];
        return;
    }
    if (self.negativeNum.length < 1) {
        [self showErrorTips:@"请编辑入底"];
        return;
    }
    if (self.albumNum.length < 1) {
        [self showErrorTips:@"请编辑入册"];
        return;
    }
    
    
    NSString *beizhu;
    if ([self.orderDesc.text isEqualToString:OrderDescPlace]) {
        beizhu = @"无备注";
    }else{
        beizhu = self.orderDesc.text;
    }
    
    if (!isPush) {  // 选完套系直接提交
        for (TaoxiProductModel *model in self.productArray) {
            model.isUrgent = @"0";
            model.urgentTime = @"";
            if (model.number < 2) {
                model.number = 1;
            }
            model.section = (long)NULL;
        }
        NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
        
        self.jsonArray = [self toJsonStr:jsonArray];
    }else{
        // 进去过产品列表界面。需要设置默认不加急的时间
        for (TaoxiProductModel *model in self.productArray) {
            NSLog(@"isUrgent = %@,time = %@",model.isUrgent,model.urgentTime);
            if ([model.isUrgent intValue] != 1) {
                // 没有加急的设置默认值
                model.isUrgent = @"0";
                model.urgentTime = @" ";
            }
            NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
            
            self.jsonArray = [self toJsonStr:jsonArray];
        }
        
    }
    
    [self.sendBtn setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:OpenOrder_Url_New,account.userID,self.taoPrice,self.taoName,self.cusName,beizhu,self.cusPhone,self.jsonArray,self.spotJson,self.negativeNum,self.albumNum,self.categoryStr,self.sourceStr,self.CardNumber,self.cusName2,self.cusPhone2];
    KGLog(@"url = %@",url);
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.sendBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.indicatorV stopAnimating];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSString *orderID = [[responseObject objectForKey:@"trade_id"] description];
        if (status == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"开单成功" message:@"立即前往支付？取消则可在订单收款里查询订单再支付" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self clearData];

            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self clearData];
                // 立即前往支付
                PayMoneyViewController *payMoney = [PayMoneyViewController new];
                payMoney.orderID = orderID;
                payMoney.price = self.taoPrice;
                [self.navigationController pushViewController:payMoney animated:YES];
               
                
            }];
            
            [alertC addAction:action1];
            [alertC addAction:action2];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.sendBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.indicatorV stopAnimating];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}
#pragma mark - 网络不好，保存到本地
- (void)saveData
{
    // 网络不好，保存到本地
    
    if (self.cusName.length < 1) {
        [self showErrorTips:@"请完善姓名"];
        return;
    }
    if (![self.cusPhone isPhoneNum]) {
        [self showErrorTips:@"号码有误"];
        return;
    }
    if (self.taoName.length < 1) {
        [self showErrorTips:@"请选择套系"];
        return;
    }
    if (self.taoPrice.length < 1) {
        [self showErrorTips:@"请完善套系价格"];
        return;
    }
    if (self.spotStr.length < 1) {
        [self showErrorTips:@"请选择景点"];
        return;
    }
    if (self.sourceStr.length < 1) {
        [self showErrorTips:@"请选择客户来源"];
        return;
    }
    if (self.categoryStr.length < 1) {
        [self showErrorTips:@"请选择套系类别"];
        return;
    }
    if (self.negativeNum.length < 1) {
        [self showErrorTips:@"请编辑入底"];
        return;
    }
    if (self.albumNum.length < 1) {
        [self showErrorTips:@"请编辑入册"];
        return;
    }
    
    NSString *beizhu;
    if ([self.orderDesc.text isEqualToString:OrderDescPlace]) {
        beizhu = @"无备注";
    }else{
        beizhu = self.orderDesc.text;
    }
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前无网络，建议离线保存订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *beizhu;
        if ([self.orderDesc.text isEqualToString:OrderDescPlace]) {
            beizhu = @"无备注";
        }else{
            beizhu = self.orderDesc.text;
        }
        if (!isPush) {  // 选完套系直接提交
            for (TaoxiProductModel *model in self.productArray) {
                model.isUrgent = @"0";
                model.urgentTime = @" ";
                if (model.number < 2) {
                    model.number = 1;
                }
                model.section = (long)NULL;
            }
            NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
            
            self.jsonArray = [self toJsonStr:jsonArray];
        }else{
            // 进去过产品列表界面。需要设置默认不加急的时间
            for (TaoxiProductModel *model in self.productArray) {
                NSLog(@"isUrgent = %@,time = %@",model.isUrgent,model.urgentTime);
                if ([model.isUrgent intValue] != 1) {
                    // 没有加急的设置默认值
                    model.isUrgent = @"0";
                    model.urgentTime = @" ";
                }
                NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
                
                self.jsonArray = [self toJsonStr:jsonArray];
            }
            
        }
        ZCAccount *account = [ZCAccountTool account];
        NSString *allUrl = [NSString stringWithFormat:OpenOrder_Url_New,account.userID,self.taoPrice,self.taoName,self.cusName,beizhu,self.cusPhone,self.jsonArray,self.spotJson,self.negativeNum,self.albumNum,self.categoryStr,self.sourceStr,self.CardNumber,self.cusName2,self.cusPhone2];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"allUrl"] = allUrl; // ⚠️长度限制，暂用未UTF8的字符串
        dict[@"productlist"] = self.jsonArray;
        dict[@"guest"] = self.cusName;
        dict[@"spot"] = self.spotJson;
        dict[@"mobile"] = self.cusPhone;
        dict[@"set"] = self.taoName;
        dict[@"price"] = self.taoPrice;
        dict[@"msg"] = beizhu;
        
        [OfflineDataManager saveToSandBox:dict];
        
        
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_sendBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.sendBtn.mas_centerX);
            make.centerY.equalTo(self.sendBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicatorV;
}
#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

#pragma mark - 保存成功后的提示
- (void)saveAlert:(NSNotification *)noti
{
    BOOL isSuccess = [noti.object boolValue];
    if (isSuccess) {
        // 保存成功
        
        [self setupRightBar];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存成功，您可在右上角查看，网络连接后提交订单。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 把数据清空
            [self clearData];
            
        }];
        
        [alertC addAction:action1];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }else{
        // 保存失败
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存失败，可能是您提交的信息有误，建议修改。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alertC addAction:action1];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }
    
}

- (void)clearData
{
    // 把数据清空
    self.taoName = @"";
    [self.productArray removeAllObjects];
    self.cusName = @"";
    self.cusPhone = @"";
    self.taoPrice = @"";
    self.jsonArray = @"";
    self.spotStr = nil;
    self.spotJson = nil;
    self.sourceStr = @"";
    self.categoryStr = @"";
    self.negativeNum = @"";
    self.albumNum = @"";
    self.cusPhone2 = @"";
    self.cusName2 = @"";
    self.CardNumber = @"";
    
    self.array = @[@[@"客户姓名*",@"客户电话*",@"客户来源*",@"客户姓名2",@"客户电话2"],@[@"套系类别*",@"套系名称*",@"套系金额*"],@[@"选择风景*",@"入     底*",@"入     册*",@"会员卡号"],@[@"订单说明",@"提交订单"]];
    [self.tableView reloadData];
}

@end
