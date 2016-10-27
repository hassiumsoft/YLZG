//
//  PushNotificationViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PushNotificationViewController.h"
#import "NormalTableCell.h"
#import "YLAlertView.h"

@interface PushNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    EMPushDisplayStyle _pushDisplayStyle;
    EMPushNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
    NSString *_nickName;
    
}


@property (strong, nonatomic) UISwitch *pushDisplaySwitch;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation PushNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推送设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePushOptions)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSFontAttributeName:[UIFont systemFontOfSize:13]    ,NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self setupSubViews];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadPushOptions];
    self.tableView.backgroundColor = NorMalBackGroudColor;
    [self.tableView reloadData];

    
}

-(void)setupSubViews{
    
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        self.tableView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:self.tableView];
    
}


#pragma mark - getter

- (UISwitch *)pushDisplaySwitch
{
    if (_pushDisplaySwitch == nil) {
        _pushDisplaySwitch = [[UISwitch alloc] init];
        [_pushDisplaySwitch addTarget:self action:@selector(pushDisplayChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pushDisplaySwitch;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"更多设置";
    }else{
        return @"显示设置";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"通知显示消息详情";
            self.pushDisplaySwitch.frame = CGRectMake(SCREEN_WIDTH - 65, 5, 40, 33);
            [cell.contentView addSubview:self.pushDisplaySwitch];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关闭推送";
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusDay ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"只在夜间开启 (22:00 - 7:00)";
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"开启推送";
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusClose ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL needReload = YES;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                needReload = NO;
                
                [YLAlertView showAlertWithTitle:@"温馨提示"
                                        message:@"这个设置会导致全天开启免打扰模式,将不再接收推送消息。是否继续?"
                                completionBlock:^(NSUInteger buttonIndex, YLAlertView *alertView) {
                                    switch (buttonIndex) {
                                        case 0: {
                                        } break;
                                        default: {
                                            self->_noDisturbingStart = 0;
                                            self->_noDisturbingEnd = 24;
                                            self->_noDisturbingStatus = EMPushNoDisturbStatusDay;
                                            [tableView reloadData];
                                        } break;
                                    }
                                    
                                } cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
                
            } break;
            case 1:
            {
                _noDisturbingStart = 22;
                _noDisturbingEnd = 7;
                _noDisturbingStatus = EMPushNoDisturbStatusCustom;
            }
                break;
            case 2:
            {
                _noDisturbingStart = -1;
                _noDisturbingEnd = -1;
                _noDisturbingStatus = EMPushNoDisturbStatusClose;
            }
                break;
                
            default:
                break;
        }
        
        if (needReload) {
            [tableView reloadData];
        }
    }

}

#pragma mark - action

- (void)savePushOptions
{
    BOOL isUpdate = NO;
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    if (_pushDisplayStyle != options.displayStyle) {
        options.displayStyle = _pushDisplayStyle;
        isUpdate = YES;
    }
    
    if (_nickName && _nickName.length > 0 && ![_nickName isEqualToString:options.displayName])
    {
        options.displayName = _nickName;
        isUpdate = YES;
    }
    if (options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        isUpdate = YES;
        options.noDisturbStatus = _noDisturbingStatus;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        if (isUpdate) {
            error = [[EMClient sharedClient] updatePushOptionsToServer];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakself.navigationController popViewControllerAnimated:YES];
            } else {
                [weakself showHint:[NSString stringWithFormat:@"保存失败-error:%@",error.errorDescription]];
            }
        });
    });
}

- (void)pushDisplayChanged:(UISwitch *)pushDisplaySwitch
{
    if (pushDisplaySwitch.isOn) {
        //  #warning 此处设置详情显示时的昵称，比如_nickName = @"环信";
        _pushDisplayStyle = EMPushDisplayStyleMessageSummary;
        _nickName = @"影楼掌柜";
    }else{
        _pushDisplayStyle = EMPushDisplayStyleSimpleBanner;
    }
}

- (void)loadPushOptions
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        //EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [weakself refreshPushOptions];
            } else {
                
            }
        });
    });
}

- (void)refreshPushOptions
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    _nickName = options.displayName;
    _pushDisplayStyle = options.displayStyle;
    _noDisturbingStatus = options.noDisturbStatus;
    if (_noDisturbingStatus != EMPushNoDisturbStatusClose) {
        _noDisturbingStart = options.noDisturbingStartH;
        _noDisturbingEnd = options.noDisturbingEndH;
    }
    
    BOOL isDisplayOn = _pushDisplayStyle == EMPushDisplayStyleSimpleBanner ? NO : YES;
    [self.pushDisplaySwitch setOn:isDisplayOn animated:YES];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

@end
