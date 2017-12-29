//
//  SystemSetVC.m
//  YiJiaYi
//
//  Created by SZR on 2016/11/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SystemSetVC.h"
#import "SetCell.h"
#import "NSString+ClearCaches.h"

#define CellTitleArr @[@[@"意见反馈"],@[@"关于我们"],@[@"清除缓存"]]
#define CellImageARR @[@[@"SysSet_FeedBack"],@[@"SysSet_AboutUs"],@[@"SysSet_ClearCache"]]
#define SkipVCARR @[@[@"FeedBackVC"],@[@"AboutUs"]]


@interface SystemSetVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)SZRTableView * tableView;

@end

@implementation SystemSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}
-(void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"系统设置"}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //创建表尾
    [self createFooterView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];

    
}
-(void)createFooterView{
    //判断是否登录，如果登录 显示退出btn 否则表尾为空
    
    if ( [[VDUserTools VD_GetToken] isEqualToString:@""]) {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }else{
       
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 50)];
        UIButton * quitBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, 10, SZRScreenWidth-20, 40) withTitle:@"退出登录" withImageStr:nil withBackImageStr:nil];
        quitBtn.backgroundColor = SZRAPPCOLOR;
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        quitBtn.layer.cornerRadius = 10.0f;
        quitBtn.layer.masksToBounds = YES;
        [quitBtn addTarget:self action:@selector(quitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitBtn];
        self.tableView.tableFooterView = view;
    }
    
}
// 设置分割线的颜色
- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 8)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [CellTitleArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [CellTitleArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    NSString * imageStr = CellImageARR[indexPath.section][indexPath.row];
    cell.setImageV.image = [UIImage imageNamed:imageStr];
    cell.setTitle.text = CellTitleArr[indexPath.section][indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 2) {
        BaseVC * vc = [[NSClassFromString(SkipVCARR[indexPath.section][indexPath.row]) alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        [SZRFunction createAlertViewTextTitle:@"清除缓存" withTextMessage:@"确定清除所有缓存?" WithButtonMessages:@[@"取消",@"确定"] Action:^(NSInteger indexPath) {
//            if (indexPath == 1) {
//                [self clearCache];
//            }
//        } viewVC:self style:UIAlertControllerStyleAlert];
        [SZRFunction createAlertViewTextTitle:@"" withTextMessage:@"" WithButtonMessages:@[@"",@""] Action:^(NSInteger indexPath) {
            
        } viewVC:self style:UIAlertControllerStyleAlert];
    }
}

-(void)clearCache{
    NSString * cachePath = [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()];
//    CGFloat size = [NSString sizeCaches:cachePath];
//    SZRLog(@"缓存大小 size = %.2lf",size);
    [NSString clearCaches:cachePath];
}

-(void)quitBtnClick:(UIButton *)btn{
    
    [SZRFunction createAlertViewTextTitle:@"您确定要退出吗?" withTextMessage:nil WithButtonMessages:@[@"取消",@"确定"] Action:^(NSInteger indexPath) {
        if (indexPath == 1) {
            // 退出登录
            [VDUserTools TokenExpire:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                DDMenuController  * ddMenu = [DDMenuController shareDDMenuVC];
                SZRTabBarVC * tabBarVC = (SZRTabBarVC *)ddMenu.rootViewController;
                tabBarVC.selectedIndex = 0;
            });
            
        }

    } viewVC:self style:UIAlertControllerStyleAlert];
}
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
