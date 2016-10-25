//
//  CityViewController.m
//  佛友圈
//
//  Created by Chan_Sir on 16/3/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CityViewController.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "FCityGroup.h"
#import "FCityModel.h"
#import "UIView+AutoLayout.h"
#import "CitySearchResultController.h"
#import "UserInfoManager.h"

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

/** UITableView */
@property (strong,nonatomic) UITableView *tableView;
/** 热门城市 */
@property (strong,nonatomic) NSArray *hotCityArr;
/** 其他城市 */
@property (strong,nonatomic) NSMutableArray *otherCityArr;
/** SearchBar */
@property (strong,nonatomic) UISearchBar *searchBar;
/** 遮盖按钮 */
@property (strong,nonatomic) UIButton *coverBtn;
/** 城市数组 */
@property (nonatomic, strong) NSMutableArray *cityGroups;
/** 结果城市VC */
@property (weak,nonatomic) CitySearchResultController *citySearchResult;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    [self loadData];
    [self setupTableView];
}
- (CitySearchResultController *)citySearchResult
{
    if (!_citySearchResult) {
        CitySearchResultController *citySearchResult = [[CitySearchResultController alloc] init];
        [self addChildViewController:citySearchResult];
        self.citySearchResult = citySearchResult;
        [self.view addSubview:self.citySearchResult.view];
        
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:0];
    }
    return _citySearchResult;
}
#pragma mark - UI界面和数据相关
- (void)loadData
{
    
    self.city = [UserInfoManager getUserInfo].location;
    // 在转模型之前修改plist文件里值
    
    self.cityGroups = [FCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
    
}

- (NSMutableArray *)cityGroups
{
    if (!_cityGroups) {
        _cityGroups = [[NSMutableArray alloc]init];
    }
    return _cityGroups;
}
- (NSMutableArray *)otherCityArr
{
    if (!_otherCityArr) {
        _otherCityArr = [NSMutableArray array];
    }
    return _otherCityArr;
}
- (void)setupTableView
{
    self.view.backgroundColor = NorMalBackGroudColor;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    self.searchBar.placeholder = @"关键字或字母";
    self.searchBar.delegate = self;
    
    self.searchBar.tintColor = NavColor;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, SCREEN_HEIGHT - 106)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexColor = WeChatColor;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
#pragma mark - searchBar相关
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverBtn.backgroundColor = self.view.backgroundColor;
    self.coverBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42*350);
    [self.coverBtn addTarget:self action:@selector(closeCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.coverBtn];
    
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitleColor:WeChatColor forState:UIControlStateNormal];
        }
    }
    
    // 2.修改搜索框的背景图片
//    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.coverBtn.alpha = 0.8;
    }];
}


- (void)closeCoverBtn:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.searchBar endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitleColor:WeChatColor forState:UIControlStateNormal];
        }
    }
    
    // 1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2.修改搜索框的背景图片
//    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4.隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.coverBtn.alpha = 0.0;
    }];
    
    // 5.移除搜索结果
    self.citySearchResult.view.hidden = YES;
    searchBar.text = nil;
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    } else {
        self.citySearchResult.view.hidden = YES;
    }
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(17);
        make.centerY.equalTo(cell.mas_centerY);
    }];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.city;
    }else{
        FCityGroup *group = self.cityGroups[indexPath.section];
        cell.textLabel.text = group.cities[indexPath.row];
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    FCityGroup *group = self.cityGroups[section];
    return group.title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *tempArr = [self.cityGroups valueForKeyPath:@"title"];
    NSMutableArray *sectionArr = [NSMutableArray array];
    [sectionArr addObject:@"GPS"];
    for (int i = 0; i < tempArr.count; i++) {
        if (i > 0) {
            [sectionArr addObject:tempArr[i]];
        }
    }
    return sectionArr;
}

#pragma mark - 选择城市、更新数据库
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FCityGroup *group = self.cityGroups[indexPath.section];
    // 修改城市
    NSString *selectCity;
    if (indexPath.section > 0) {
//        [YLNotificationCenter postNotificationName:YLCityDidChangeNotification object:nil userInfo:@{YLSelectCityName:group.cities[indexPath.row]}];
        selectCity = group.cities[indexPath.row];
    }else{
//        [YLNotificationCenter postNotificationName:YLCityDidChangeNotification object:nil userInfo:@{YLSelectCityName:self.city}];
        selectCity = self.city;
    }
    
    BOOL isSave = [UserInfoManager updataUserInfoWithKey:@"location" Value:selectCity];
    if (isSave) {
        if (_CityBlock) {
            _CityBlock(selectCity);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self showErrorTips:@"修改失败"];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)backClick
{
    [self.searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)more
{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.searchBar endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
