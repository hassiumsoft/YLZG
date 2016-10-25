//
//  AllMembersController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AllMembersController.h"
#import "GroupMemberCollectionCell.h"
#import "IviteGroupersCollectionCell.h"
#import "IviteMemberViewController.h"


static NSInteger const cols = 4;
static CGFloat const margin = 2;

@interface AllMembersController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation AllMembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部成员";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memberArr.count + 2;
}


#pragma mark 每个UICollectionViewCell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item <= self.memberArr.count - 1) {
        GroupMemberCollectionCell *cell = [GroupMemberCollectionCell sharedGroupMemberCell:collectionView IndexPath:indexPath];
        ContactersModel  *model = self.memberArr[indexPath.item];
        cell.model = model;
        return cell;
    } else if(indexPath.item <= self.memberArr.count){ // add_members、delete_members
        IviteGroupersCollectionCell *cell = [IviteGroupersCollectionCell sharedIvitGroupMemCell:collectionView IndexPath:indexPath];
        [cell.imageV setImage:[UIImage imageNamed:@"add_members"]];
        return cell;
    }else{
        // 踢出
        IviteGroupersCollectionCell *cell = [IviteGroupersCollectionCell sharedIvitGroupMemCell:collectionView IndexPath:indexPath];
        [cell.imageV setImage:[UIImage imageNamed:@"delete_members"]];
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item <= self.memberArr.count - 1) {
        if (_DidSelectBlock) {
            _DidSelectBlock(indexPath);
        }
    }else if (indexPath.item <= self.memberArr.count){
        [self ivitMembers];
    }else{
        [self deleteOneMembers];
    }
    
    
}

#pragma mark - 踢出某个成员
- (void)deleteOneMembers
{
    IviteMemberViewController *ivite = [IviteMemberViewController new];
    ivite.AddMembersBlock = ^(NSArray *memberArr){
        
    };
    ivite.groupArr = self.memberArr;
    ivite.type = DeleteMemberType;
    ivite.title = @"踢除出人";
    ivite.groupModel = self.groupModel;
    [self.navigationController pushViewController:ivite animated:YES];
}
#pragma mark - 邀请成员
- (void)ivitMembers
{
    IviteMemberViewController *ivite = [IviteMemberViewController new];
    ivite.groupArr = self.memberArr;
    ivite.type = AddMemberType;
    ivite.title = @"邀请入群";
    ivite.groupModel = self.groupModel;
    [self.navigationController pushViewController:ivite animated:YES];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView{
    CGFloat cellW = (SCREEN_WIDTH - 3 * margin)/cols;
    CGFloat cellH = cellW;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(cellW,cellH);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //让collectionView滚动
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[GroupMemberCollectionCell class] forCellWithReuseIdentifier:@"GroupMemberCollectionCell"];
        [_collectionView registerClass:[IviteGroupersCollectionCell class] forCellWithReuseIdentifier:@"IviteGroupersCollectionCell"];
    }
    
    return _collectionView;
    
}



@end
