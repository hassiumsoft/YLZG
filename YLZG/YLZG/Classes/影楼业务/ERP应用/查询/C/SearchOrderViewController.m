//
//  SearchOrderViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "SearchTableViewCell.h"
#import "SearchDetailViewController.h"
#import "NSString+StrCategory.h"
#import "HTTPManager.h"
#import "NormalIconView.h"
#import <Masonry.h>
#import <MJExtension/MJExtension.h>
#import "ZCAccountTool.h"
#import "SearchDBManager.h"




// 最大存储的搜索历史 条数
#define MAX_COUNT 5

@interface SearchOrderViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>


@property (nonatomic, strong) UITableView * searchTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UISearchBar * searchBar;

@property (strong,nonatomic) NormalIconView *emptyView;

//历史记录数组
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)UITableView * recordTableView;


@end


@implementation SearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    // 初始化
    [self selfInitSearchViewControllerVC];
    // 搭建UI
    [self createSearchBar];
    [self searchBarTextDidBeginEditing:self.searchBar ];
    
}

#pragma mark - 初始化
- (void)selfInitSearchViewControllerVC{
    //    detailVC = [[SearchDetailViewController alloc] init];
    self.navigationItem.title = @"查询";
    self.dataSource = [NSMutableArray array];
    self.dataArray = [[NSMutableArray alloc] init];
    self.dataArray = [[SearchDBManager shareSearchDBManager] selectAllSearchModel];
}







#pragma mark - 请求数据
- (void)loadSearchViewControllerData{
    
    // 取出登录成功的uid
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:SEARCH_URL,self.searchBar.text,account.userID];
    [MBProgressHUD showMessage:@"查询中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [MBProgressHUD hideHUD];
        if (code == 1) {
            // 如果multi是1,返回列表成功;0表示显示详情页面,3表示失败
            int multi = [[[responseObject objectForKey:@"multi"] description] intValue];
            if (multi == 1) {
                // 多个订单
                NSArray * arr = responseObject[@"result"];
                self.dataSource.array = [SearchViewModel mj_objectArrayWithKeyValuesArray:arr];
                // 刷新表格
                [self.view addSubview:self.searchTableView];
                [self.searchTableView reloadData];
                
            }else if (multi == 0) {
                // 一个订单
                SearchViewModel *model = [[SearchViewModel alloc]init];
                model.tradeID = [[responseObject objectForKey:@"tradeid"]description];
                model.guestname = [[responseObject objectForKey:@"baby"]description];
                model.phone = [[responseObject objectForKey:@"maphone"]description];
                model.store = [[responseObject objectForKey:@"store"]description];
                model.set = [[responseObject objectForKey:@"packages"]description];
                model.price = [[responseObject objectForKey:@"balance"]description];
                [self.dataSource addObject:model];
                [self.searchTableView reloadData];
                
            }else{
                [self.searchTableView removeFromSuperview];
                [self loadEmptyView:message];
            }
        }else {
            [self.searchTableView removeFromSuperview];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            [self loadEmptyView:message];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
    
}

#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    
    self.emptyView.label.text = message;
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}

- (void)babyClicked:(NSNotification *)notice {
    if ([self.searchBar.text isEqualToString:notice.object]) {
        //[self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark -创建UISearchBar相关
- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"客户名字或号码，支持模糊查询";
    [self.view addSubview:_searchBar];
}



- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
        _recordTableView.showsVerticalScrollIndicator = NO;
        _recordTableView.backgroundColor = self.view.backgroundColor;
        _recordTableView.tag = 11;
        _recordTableView.rowHeight = 55;

        [self.view  addSubview:_recordTableView];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104)];
        UIButton *clearButton = [[UIButton alloc] init];

       [clearButton setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];

        [clearButton setTitle:@"  清空历史记录" forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchDown];
        clearButton.backgroundColor = [UIColor whiteColor];
        clearButton.layer.cornerRadius = 5;


        [footView addSubview:clearButton];
        
        [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footView.mas_centerX);
            make.top.equalTo (footView.mas_top).mas_offset(@20);
            make.height.equalTo(@44);
            make.width.equalTo(@180);
        }];
        self.recordTableView.tableFooterView = footView;
    }
    
    return _recordTableView;
    
}


- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
        _searchTableView.rowHeight = 120;
        _searchTableView.tag = 12;
        _searchTableView.backgroundColor = self.view.backgroundColor;
        [self.view  addSubview:_searchTableView];
    }
    return _searchTableView;
}

- (NormalIconView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [NormalIconView sharedHomeIconView];
        _emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
        _emptyView.label.numberOfLines = 0;
        _emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
        _emptyView.backgroundColor = [UIColor clearColor];
    }
    return _emptyView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag ==11){
        return 1;
    }
    return _dataSource.count;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 11) {
        if (self.dataArray.count == 0) {
            self.recordTableView.tableFooterView.hidden = YES; // 没有历史数据时隐藏
        }
        else{
            self.recordTableView.tableFooterView.hidden = NO; // 有历史数据时显示
        }
        return self.dataArray.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag ==12){
        SearchTableViewCell * cell = [SearchTableViewCell sharedSearchTableViewCell:tableView];
        SearchViewModel * searchModel = _dataSource[indexPath.section];
        cell.model = searchModel;
        return cell;
        
    }else {
        static NSString *identify = @"identify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        
        SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"btn_ico_chaxun"];
        cell.textLabel.text = model.keyWord;
        //cell.detailTextLabel.textColor = [UIColor greenColor];
        cell.detailTextLabel.text = model.currentTime;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  历史搜索记录";
    label.backgroundColor = ToolBarColor;
    label.font = [UIFont systemFontOfSize:15];
    return label;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 11) {
        if (_dataArray.count > 0) {
            return @"  历史搜索记录";
        }
        return @"";
    }
    return @"";
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = NorMalBackGroudColor;
    return foot;
    
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 12) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"📱" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // 打电话
            SearchViewModel * searchModel = self.dataSource[indexPath.section];
            NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",searchModel.phone]];
            UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
            [self.view addSubview:phoneWebView];
        }];
        deleteAction.backgroundColor = [UIColor lightGrayColor];
        
        return @[deleteAction];
        
    }else {
        
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
            [[SearchDBManager shareSearchDBManager] deleteSearchModelByKeyword:model.keyWord];
            //删除数据模型
            _dataArray = [[SearchDBManager shareSearchDBManager] selectAllSearchModel];
            [self.recordTableView reloadData];
            
        }];
        delete.backgroundColor = [UIColor redColor];
        
        return @[delete];
    }
}



//将键盘退下
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}


#pragma mark - UISearchBarDelegate相关



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.userInteractionEnabled = NO;
    [self.dataSource removeAllObjects];
    [self.searchTableView reloadData];
    
    [self.recordTableView removeFromSuperview];
    [self insterDBData:searchBar.text]; // 插入数据库
    [searchBar resignFirstResponder];
    
    self.searchTableView.hidden = NO;
    self.searchTableView.delegate =self;
    self.searchTableView.dataSource= self;
    [self.view addSubview:self.searchTableView];
    [self.view endEditing:YES];
    //[_recordView removeFromSuperview];
    [self loadSearchViewControllerData];
    
    self.searchBar.userInteractionEnabled = YES;
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
    [_dataSource removeAllObjects];
    [_searchTableView reloadData];
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    self.recordTableView.hidden = NO ;
    self.recordTableView.delegate =self;
    self.recordTableView.dataSource= self;
    [self.view  addSubview:_recordTableView];
    
}

#pragma mark -在文字改变的时候去掉tableview

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 12) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SearchDetailViewController *detailVC = [SearchDetailViewController new];
        SearchViewModel * model = _dataSource[indexPath.section];
        detailVC.detailTradeID = model.tradeID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
        self.searchBar.text = model.keyWord;
        [self searchBarSearchButtonClicked:self.searchBar];
    }
    
}



- (void)clearButtonClick{
    
    [[SearchDBManager shareSearchDBManager] deleteAllSearchModel];
    [self.dataArray removeAllObjects];
    
    [self.recordTableView reloadData];
    
}



/**
 *  获取当前时间
 *  @return 当前时间
 */
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/**
 *  去除数据库中已有的相同的关键词
 *
 *  @param keyword 关键词
 */
- (void)removeSameData:(NSString *)keyword{
    NSMutableArray *array = [[SearchDBManager shareSearchDBManager] selectAllSearchModel];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchModel *model = (SearchModel *)obj;
        if ([model.keyWord isEqualToString:keyword]) {
            [[SearchDBManager shareSearchDBManager] deleteSearchModelByKeyword:keyword];
        }
    }];
}


/**
 *  数组左移
 *  @param array   需要左移的数组
 *  @param keyword 搜索关键字
 *  @return 返回新的数组
 */
- (NSMutableArray *)moveArrayToLeft:(NSMutableArray *)array keyword:(NSString *)keyword{
    [array addObject:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    [array removeObjectAtIndex:0];
    return array;
}

/**
 *  数组逆序
 *  @param array 需要逆序的数组
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array{
    NSInteger num = array.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[array objectAtIndex:i]];
        
    }
    return temp;
}

/**
 *  多余20条数据就把第0条去除
 *  @param keyword 插入数据库的模型需要的关键字
 */
- (void)moreThan20Data:(NSString *)keyword{
    // 读取数据库里面的数据
    NSMutableArray *array = [[SearchDBManager shareSearchDBManager] selectAllSearchModel];
    
    if (array.count > MAX_COUNT - 1) {
        NSMutableArray *temp = [self moveArrayToLeft:array keyword:keyword]; // 数组左移
        [[SearchDBManager shareSearchDBManager] deleteAllSearchModel]; //清空数据库
        [self.dataArray removeAllObjects];
        [self.recordTableView reloadData];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel *model = (SearchModel *)obj; // 取出 数组里面的搜索模型
            [[SearchDBManager shareSearchDBManager] insterSearchModel:model]; // 插入数据库
        }];
    }
    else if (array.count <= MAX_COUNT - 1){ // 小于等于19 就把第20条插入数据库
        [[SearchDBManager shareSearchDBManager] insterSearchModel:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    }
}

/**
 *  关键词插入数据库
 *
 *  @param keyword 关键词
 */
- (BOOL)insterDBData:(NSString *)keyword{
    if (keyword.length == 0) {
        return NO;
    }
    else{//搜索历史插入数据库
        //先删除数据库中相同的数据
        [self removeSameData:keyword];
        //再插入数据库
        [self moreThan20Data:keyword];
        // 读取数据库里面的数据
        self.dataArray = [[SearchDBManager shareSearchDBManager] selectAllSearchModel];
        [self.recordTableView reloadData];
        return YES;
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

@end
