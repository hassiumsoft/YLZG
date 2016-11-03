//
//  GroupListViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupListViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "YLGroup.h"
#import <MJExtension.h>
#import "NormalconButton.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "GroupTableViewCell.h"
#import "CreateGroupsController.h"
#import "GroupListManager.h"
#import "YLChatGroupDetailController.h"




@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSMutableArray *groupArray;

@end



@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影楼社区";
    
    [self setupSubViews];
    [YLNotificationCenter addObserver:self selector:@selector(UpdataGroupInfo) name:HXUpdataGroupInfo object:nil];
    
    NSArray *dataArray = [GroupListManager getAllGroupInfo];
    if (dataArray.count >= 1) {
        self.groupArray = [NSMutableArray arrayWithArray:dataArray];
        [self.tableView reloadData];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData:NO];
        }];
        
    }else{
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSArray *dataArray = [GroupListManager getAllGroupInfo];
            if (dataArray.count >= 1) {
                // 非第一次
                [self getData:NO];
            }else{
                // 第一次
                [self getData:YES];
            }
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
    }
}
-(void)setupSubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
}
- (void)UpdataGroupInfo
{
    [self getData:NO];
}

- (void)getData:(BOOL)isFirst
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/my_groups_list?uid=%@",account.userID];
    KGLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSArray *dictArray = responseObject[@"grouplist"];
        if (code == 1) {
            
            if (!isFirst) {
                // 删除旧数据
                [self.groupArray removeAllObjects];
                [GroupListManager deleteAllGroupInfo];
            }
            
            self.groupArray = [YLGroup mj_objectArrayWithKeyValuesArray:dictArray];
            [self.tableView reloadData];
            for (int i = 0; i < _groupArray.count; i++) {
                YLGroup *model = _groupArray[i];
                [GroupListManager saveGroupInfo:model];
            }
            
            
        }else{
            [self showErrorTips:message];
        }
    }fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        KGLog(@"error = %@",error.localizedDescription);
    }];
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableViewCell:tableView];
    cell.model = self.groupArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor whiteColor];
    return foot;
}

-(UIView *)headView{
    if(!_headView){
        
        CGFloat margin = 10;
        CGFloat headH = 60;
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.width, headH)];
        _headView.userInteractionEnabled = YES;
        _headView.backgroundColor = self.view.backgroundColor;
        
        CGFloat imageH = 3*margin;
        CGFloat imageW = 3*margin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*margin, (headH - imageH)/2, imageW, imageH)];
        imageView.image = [UIImage imageNamed:@"group_add_icon"];
        [_headView addSubview:imageView];
        
        
        CGFloat newLabelX = CGRectGetMaxX(imageView.frame) + 20;
        CGFloat newLabelH = 4*margin;
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, (headH - newLabelH)/2, SCREEN_WIDTH -newLabelX, newLabelH) ];
        newLabel.text = @"新建群聊";
        newLabel.adjustsFontSizeToFitWidth = YES;
        newLabel.font = [UIFont systemFontOfSize:14];
        newLabel.textColor = RGBACOLOR(233, 80, 63, 1);
        [_headView addSubview:newLabel];
        
        UIImageView *addImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"group_add"]];
        [_headView addSubview:addImageV];
        [addImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView.mas_centerY);
            make.right.equalTo(_headView.mas_right).offset(-18);
            make.width.and.height.equalTo(@23);
        }];
        
        /**添加手势*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            [self gestureClick];
        }];
        [_headView addGestureRecognizer:tap];
        
    }
    
    return _headView;
    
}


-(void)gestureClick{
    
    CreateGroupsController *createChatroom = [[CreateGroupsController alloc] init];
    createChatroom.ReloadBlock = ^{
        [self getData:NO];
    };
    [self.navigationController pushViewController:createChatroom animated:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLChatGroupDetailController *group = [YLChatGroupDetailController new];
    YLGroup *model = self.groupArray[indexPath.section];
    group.groupModel = model;
    group.isRootPush = YES;
    [self.navigationController pushViewController:group animated:YES];
    
}

/** 懒加载 */

-(NSMutableArray *)groupArray{
    
    if (!_groupArray) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

@end
