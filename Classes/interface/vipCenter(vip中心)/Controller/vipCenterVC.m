 //
//  vipCenterVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "vipCenterVC.h"
#import "PhysicianVisitVC.h"

//view
#import "VIPCellView.h"
#import "CustomCell.h"
#import "VIPTVHeaderView.h"
#import "VIPHeaderView.h"
//VC
#import "PersonSetVC.h"
#import "SystemSetVC.h"
#import "MessageVC.h"
#import "GoldCoinsVC.h"
#import "VisitsManageVC.h"
#import "MyVipVC.h"
#import "MyAffectionCodeVC.h"
#import "VIPModel.h"

#define CellNameArr @[@[@"亲情邀请码",@"个人设置"],@[@"系统设置"]]

@interface vipCenterVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)SZRTableView * tableView;


@end

@implementation vipCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(void)createUI{
    [self createNavItems:@{NAVRIGHTIMAGE:@"vip_chat"}];
    self.navigationItem.titleView = [UIView new];
    [self createTableView];
}

-(void)loadData{
    [self.tableView reloadData];
}


-(void)createTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-44) style:UITableViewStylePlain controller:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SZRFunction SZRSetLayerImage:self.tableView imageStr:@"dl-bj"];
    //表头
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 187+111)];
    header.backgroundColor = [UIColor clearColor];
    VIPHeaderView * topView = [[[NSBundle mainBundle]loadNibNamed:@"VIPHeaderView" owner:nil options:nil] firstObject];
    topView.frame = CGRectMake(0, 0, SZRScreenWidth, kAdaptedWidth_2(349));
    
    [header addSubview:topView];
    [topView loadData];
    VIPCellView * vipCellView = [[VIPCellView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+10, SZRScreenWidth, 111)];
    __weakSelf;
    vipCellView.tagClickBlock = ^(NSInteger tag){
        switch (tag) {
            case 201:
            {
                [MBProgressHUD showTextOnly:@"该功能还未开放！"];
//                GoldCoinsVC* goldVC = [GoldCoinsVC new];
//                goldVC.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:goldVC animated:YES];
            }
                break;
             case 202:
            {
                MyVipVC * myVipVC = [MyVipVC new];
                myVipVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myVipVC animated:YES];

            }
                break;
                case 203:
            {
                VisitsManageVC* visitVC = [VisitsManageVC new];
                visitVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:visitVC animated:YES];
//                [MBProgressHUD showTextOnly:@"该功能还未开放"];

            }
                break;
            default:
                break;
        }
    };
    [header addSubview:vipCellView];
    self.tableView.tableHeaderView = header;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:NULL] forCellReuseIdentifier:@"CustomCell"];
    //区头
    [self.tableView registerNib:[UINib nibWithNibName:@"VIPTVHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"VIPTVHeaderView"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return CellNameArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [CellNameArr[section] count];
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 25 : 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    VIPTVHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VIPTVHeaderView"];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    cell.nameLabel.text = CellNameArr[indexPath.section][indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyAffectionCodeVC * affectionCodeVC = [[MyAffectionCodeVC alloc]init];
            VIPModel * model = [[VIPModel alloc]init];
            model.VIPName = @"黄金会员";
            model.affectionCodeArr = @[@"亲情邀请码1",@"亲情邀请码2",@"亲情邀请码3",@"亲情邀请码4",@"亲情邀请码5",@"亲情邀请码6"];
            affectionCodeVC.vipModel = model;
            affectionCodeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:affectionCodeVC animated:YES];
//            [MBProgressHUD showTextOnly:@"该功能还未开放"];

        }
        if (indexPath.row == 1) {
            PersonSetVC * personSetVC = [[PersonSetVC alloc]init];
            personSetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personSetVC animated:YES];
        }
    }else{
        SystemSetVC * systemSetVC = [[SystemSetVC alloc]init];
        systemSetVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemSetVC animated:YES];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏阴影线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
- (void)rightBtnClick{
    MessageVC* mesVC = [[MessageVC alloc] init];
    mesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mesVC animated:YES];
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
