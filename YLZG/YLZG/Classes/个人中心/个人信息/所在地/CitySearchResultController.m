//
//  CitySearchResultController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/26.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "CitySearchResultController.h"
#import "FCityGroup.h"
#import "FCityModel.h"
#import "UserInfoManager.h"
#import "FMetaTool.h"
#import <Masonry.h>


@interface CitySearchResultController ()
/** 搜索结果数组 */
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation CitySearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NorMalBackGroudColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    searchText = searchText.lowercaseString;
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.resultCities = [[FMetaTool cities] filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
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
    FCityModel *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%lu个搜索结果",(unsigned long)self.resultCities.count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCityModel *city = self.resultCities[indexPath.row];
    [YLNotificationCenter postNotificationName:YLCityDidChangeNotification object:nil userInfo:@{YLSelectCityName:city.name}];
    [[UserInfoManager sharedManager] updateWithKey:UUlocation Value:city.name];
    if (_DidSelectCity) {
        _DidSelectCity();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


@end
