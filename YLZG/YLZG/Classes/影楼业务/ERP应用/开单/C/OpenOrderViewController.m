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


#define OrderDescPlace @"您可写上开单人的名字或者其他可备注情况(非必填)"

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
/** 客人姓名 */
@property (copy,nonatomic) NSString *cusName;
/** 客人电话 */
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
    self.array = @[@[@"客人姓名：",@"客人电话："],@[@"选择风景：",@"套系名称：",@"套系金额："],@[@"订单说明："],@[@"提交订单"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(9 * CKproportion, 0, 0, 0);
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
        } else {
            // 客户电话
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.cusPhone;
            return cell;
        }
    } else if(indexPath.section == 1){
        // 套系名称 && 套系金额 || 套系产品
        NSArray *tempArr = self.array[1];
        if (tempArr.count == 3) {
            // 初始阶段
            if (indexPath.row == 0) {
                // 选择风景
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.spotStr;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else if (indexPath.row == 1) {
                // 套系名称
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoName;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else{
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoPrice;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }
        }else{
            // 添加一行之后
            if (indexPath.row == 0) {
                // 选择风景
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.spotStr;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else if(indexPath.row == 1) {
                // 套系名称
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoName;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            } else if(indexPath.row == 2){
                // ⚠️套系产品
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.someProduct;
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }else{
                // 套系价格
                NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
                cell.contentLabel.text = self.taoPrice;
                cell.contentLabel.textColor = RGBACOLOR(232, 19, 28, 1);
                cell.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
                cell.textLabel.text = self.array[indexPath.section][indexPath.row];
                return cell;
            }
        }
        
    }else if (indexPath.section == 2){
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
        self.orderDesc.textColor = RGBACOLOR(67, 67, 67, 1);
        [cell addSubview:self.orderDesc];
        [self.orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleL.mas_right);
            make.right.equalTo(cell.mas_right).offset(-17);
            make.top.equalTo(cell.mas_top).offset(1);
            make.height.equalTo(@63);
        }];
        
        return cell;
    }else{
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
        }else{
            // 客户电话
            OrderPhoneController *phone = [[OrderPhoneController alloc]init];
            phone.delegate = self;
            [self.navigationController pushViewController:phone animated:YES];
        }
    }else if (indexPath.section == 1){
        NSArray *tempArr = self.array[1];
        if (tempArr.count == 3) {
            if (indexPath.row == 0) {
                SpotViewController *spotVC = [SpotViewController new];
                spotVC.delegate = self;
                [self.navigationController pushViewController:spotVC animated:YES];
            }else{
                // 初始状态
                ChangeTaoxiController *changeTaoxi = [[ChangeTaoxiController alloc]init];
                changeTaoxi.delegate = self;
                [self.navigationController pushViewController:changeTaoxi animated:YES];
            }
        }else{
            // 添加一行之后
            if (indexPath.row == 0) {
                // 选择风景
                SpotViewController *spotVC = [SpotViewController new];
                spotVC.delegate = self;
                [self.navigationController pushViewController:spotVC animated:YES];
            }else if (indexPath.row == 1) {
                // 改变套系self.taoPrice
                ChangeTaoxiController *changeTaoxi = [[ChangeTaoxiController alloc]init];
                changeTaoxi.delegate = self;
                [self.navigationController pushViewController:changeTaoxi animated:YES];
            } else if(indexPath.row == 2){
                // 编辑套系产品
                
                EditProductController *product = [[EditProductController alloc]init];
                isPush = YES;
                product.taoName = self.taoName;
                product.delegate = self;
                product.array = self.productArray;
                [self.navigationController pushViewController:product animated:YES];
            }else{
                // 改变价格
                ChangeOrderPriceController *changePrice = [ChangeOrderPriceController new];
                changePrice.price = self.taoPrice;
                changePrice.delegate = self;
                [self.navigationController pushViewController:changePrice animated:YES];
            }
            
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
    self.array = @[@[@"客人姓名：",@"客人电话："],@[@"选择风景：",@"套系名称：",@"套系产品",@"套系金额："],@[@"订单说明："],@[@"提交订单"]];
    
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
        return 66;
    }else{
        CGFloat tabHeight;
        NSArray *tempArr = self.array[1];
        if (tempArr.count == 3) {
            // 初始状态
            tabHeight = 48*6 + 66 + 36*CKproportion;
            
        }else{
            tabHeight = 48*(6 + 1) + 66 + 36*CKproportion;
            
        }
        return self.view.height - tabHeight + 64;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }else if(section == 3){
        return 0.1;
    }else{
        return 9 * CKproportion;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
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

/**
 
 http://zsylou.wxwkf.com/index.php/home/newtrade/new?uid=2&
 price=3999&
 set=999婚纱照&
 guest=姓名&
 msg=备注&
 mobile=18753607722&
 productlist=
 [
 {
 "category":"1",
 "isUrgent":0,
 "number":1,
 "pro_name":"999婚纱套系",
 "pro_price":"100",
 "urgentTime":""
 },
 {
 "category":"2",
 "isUrgent":0,
 "number":1,
 "pro_name":"5288儿童满月套系",
 "pro_price":"200",
 "urgentTime":""
 },
 
 {
 "category":"3",
 "isUrgent":0,
 "number":1,
 "pro_name":"7288水晶套系",
 "pro_price":"300",
 "urgentTime":""
 },
 {
 "category":"1",
 "isUrgent":0,
 "number":1,
 "pro_name":"105全家福套系",
 "pro_price":"400",
 "urgentTime":""
 }
 ]
 
 */
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
    
    //        @"http://zsylou.wxwkf.com/index.php/home/newtrade/new?uid=%@&price=%@&set=%@&guest=%@&msg=%@&mobile=%@&productlist=%@"
    
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
    
    NSString *beizhu;
    if ([self.orderDesc.text isEqualToString:OrderDescPlace]) {
        beizhu = @"无备注";
    }else{
        beizhu = self.orderDesc.text;
    }
    
    if (!isPush) {  // 选完套系直接提交
        //        TaoxiProductModel && self.productArray;
        for (TaoxiProductModel *model in self.productArray) {
            model.isJiaji = NO;
            model.jiajiTime = @"";
            model.section = (long)NULL;
        }
        NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
        
        self.jsonArray = [self toJsonStr:jsonArray];
        
    }
    
    [self.sendBtn setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *str = [NSString stringWithFormat:OpenOrder_Url,account.userID,self.taoPrice,self.taoName,self.cusName,beizhu,self.cusPhone,self.jsonArray,self.spotJson];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        NSString *message = [[json objectForKey:@"message"] description];
        [self.sendBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.indicatorV stopAnimating];
        if (error) {
            [self sendErrorWarning:@"解析失败"];
        }else{
            int status = [[[json objectForKey:@"code"] description] intValue];
            NSString *orderID = [[json objectForKey:@"trade_id"] description];
            if (status == 1) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"开单成功" message:@"立即前往支付？取消则可在订单收款里查询订单再支付" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
        if (!self->isPush) {  // 选完套系直接提交
            //        TaoxiProductModel && self.productArray;
            for (TaoxiProductModel *model in self.productArray) {
                model.isJiaji = NO;
                model.jiajiTime = @"";
                model.section = (long)NULL;
            }
            NSArray *jsonArray = [TaoxiProductModel mj_keyValuesArrayWithObjectArray:self.productArray];
            
            self.jsonArray = [self toJsonStr:jsonArray];
            
        }
        ZCAccount *account = [ZCAccountTool account];
        NSString *allUrl = [NSString stringWithFormat:OpenOrder_Url,account.userID,self.taoPrice,self.taoName,self.cusName,beizhu,self.cusPhone,self.jsonArray,self.spotJson];
        
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
        [OfflineDataManager registerLocalNotification:[OfflineDataManager getAllOffLineOrderFromSandBox].count];
        
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
            self.taoName = @"";
            [self.productArray removeAllObjects];
            self.cusName = @"";
            self.cusPhone = @"";
            self.taoPrice = @"";
            self.jsonArray = @"";
            self.spotStr = nil;
            self.spotJson = nil;
            self.array = @[@[@"客人姓名：",@"客人电话："],@[@"选择风景",@"套系名称：",@"套系金额："],@[@"订单说明："],@[@"提交订单"]];
            [self.tableView reloadData];
            
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



@end
