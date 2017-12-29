//
//  LeftVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LeftVC.h"
#import "SZRTableView.h"
#import "LeftCell.h"
#import "DDMenuController.h"
#import "MedicationToRemindVC.h"
#import "HealthRecordsVC.h"
#import "PCData.h"

#define imageArr @[@"icon_dietitians",@"icon_healthy",@"icon_private_doctors",@"icon_related"]
#define nameArr @[@"个人资料",@"健康档案",@"健康提醒",@"我的客服"]

@interface LeftVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray* dataArr;

@end

@implementation LeftVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];

}

#pragma mark 创建TableView
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV = [[SZRTableView alloc]initWithFrame:CGRectMake(0,0, 180, SZRScreenHeight) style:UITableViewStylePlain controller:self];
    self.tableV.backgroundColor = [UIColor clearColor];
    self.tableV.separatorColor = SZRSLIDERCOLOR;
    self.tableV.bounces = NO;

    [self.tableV registerNib:[UINib nibWithNibName:@"LeftCell" bundle:nil] forCellReuseIdentifier:@"LEFTCELL"];
    self.tableV.tableFooterView = [[UIView alloc]init];
    
}
#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return imageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SZRScreenHeight/4;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftCell* leftCell = [tableView dequeueReusableCellWithIdentifier:@"LEFTCELL" forIndexPath:indexPath];
    leftCell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    leftCell.titleLabel.text = nameArr[indexPath.row];
    leftCell.titleLabel.textColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            leftCell.backgroundColor = RGBCOLOR(22,47,48);
            break;
            case 1:
            leftCell.backgroundColor = RGBCOLOR(22,58,85);
            break;
            case 2:
            leftCell.backgroundColor = RGBCOLOR(49,161,145);
            break;
            case 3:
            leftCell.backgroundColor = RGBCOLOR(64,202,168);
            break;
            default:
            break;
    }
    return leftCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self chooseSkipCellVC:indexPath];
    if (indexPath.row == 3) {
        UIAlertView* alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要拨打合合健康管理客服电话吗 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerV show];
        
    }
}


- (void)chooseSkipCellVC:(NSIndexPath *)indexPath{
    AppDelegate* app = (AppDelegate* )[UIApplication sharedApplication].delegate;
    // 通过window获取ddmenuVC的根视图
    DDMenuController * ddmenuVC = (DDMenuController *)app.window.rootViewController;
    // 显示跟视图
    [ddmenuVC showRootController:YES];
    UINavigationController * nav = (UINavigationController *)[(SZRTabBarVC *)ddmenuVC.rootViewController selectedViewController];
    UIViewController* vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[PCData alloc] init];
            break;
        case 1:
            vc = [[HealthRecordsVC alloc] init];
            break;
        case 2:
            [MBProgressHUD showTextOnly:@"该功能还未开放！"];
            //            vc = [[MedicationToRemindVC alloc] init];
            break;
            
        default:
            break;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [alertView removeFromSuperview];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://010-89029276"]];
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
