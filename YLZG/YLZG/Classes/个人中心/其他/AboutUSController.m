//
//  AboutUSController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/2/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AboutUSController.h"
#import "NormalTableCell.h"
#import "AboutZhichengController.h"
#import <LCActionSheet.h>
#import "NewFutherViewController.h"
#import <Masonry.h>


const CGFloat TopViewH = 300;

@interface AboutUSController ()<UIScrollViewDelegate,LCActionSheetDelegate>
@property (strong,nonatomic) UIImageView *topView;
@end

@implementation AboutUSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = NorMalBackGroudColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self setupSubViews];
    
}
- (void)setupSubViews
{
    // 让内边距往下移动一段距离
    self.tableView.contentInset = UIEdgeInsetsMake(TopViewH * 0.4, 0, 0, 0);
    UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reg-fb-bg"]];
    topView.frame = CGRectMake(0, -TopViewH, SCREEN_WIDTH, TopViewH);
    topView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView insertSubview:topView atIndex:0];
    self.topView = topView;
    self.topView.userInteractionEnabled = YES;
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"智诚科技(北京实验室)";
    label2.font = [UIFont fontWithName:@"Iowan Old Style" size:12];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.tableView.mas_bottom).offset(468*CKproportion);
        make.height.equalTo(@18);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"Copyright © 2016";
    label1.font = [UIFont fontWithName:@"Iowan Old Style" size:12];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(label2.mas_top);
        make.height.equalTo(@18);
    }];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"欢迎页",@"客服电话",@"关于智诚"];
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    cell.label.text = array[indexPath.row];
    cell.label.textColor = RGBACOLOR(52, 52, 52, 1);
    [cell.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            NewFutherViewController *welcome = [NewFutherViewController new];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.5;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionFade;
            animation.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self presentViewController:welcome animated:NO completion:^{
                
            }];
            
            break;
        }
        case 1:
        {
            [self callPhone];
            break;
        }
        case 2:
        {
            AboutZhichengController *zhichengVC = [[AboutZhichengController alloc]init];
            zhichengVC.isLogin = YES;
            [self.navigationController pushViewController:zhichengVC animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)callPhone
{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"免费咨询客服" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"18515530245(北京号,捆绑微信号)",@"0371-60929793", nil];
    
    [actionSheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:18515530245"]];
            UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
            [self.view addSubview:phoneWebView];
            break;
        }
        case 2:
        {
            NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:0371-60929793"]];
            UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
            [self.view addSubview:phoneWebView];
            break;
        }
        default:
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat contentY = scrollView.contentOffset.y * (-1);
//    KGLog(@"scrool = %g",contentY);
    if (contentY > 250) {
        return;
    }
        // 向下拽了多少距离
    CGFloat down = -(TopViewH * 0.8) - scrollView.contentOffset.y;
    if (down < 0) return;
    
    CGRect frame = self.topView.frame;
    // 5决定图片变大的速度,值越大,速度越快
    frame.size.height = TopViewH + down * 3;
    self.topView.frame = frame;
    
}



- (UIImage *)imageWithBgColor:(UIColor *)color {
                                                                 
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
