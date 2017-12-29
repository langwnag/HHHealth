//
//  PleaseWaitVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PleaseWaitVC.h"
#import "SZRRipple.h"
#import "SelecterDoctorVC.h"
@interface PleaseWaitVC ()
@property (nonatomic,strong) UILabel* grabLabel;//抢单
@property (nonatomic,strong) UIButton* overBtn;//结束抢单按钮

@property(nonatomic,strong)SZRRipple * dd;

@end

@implementation PleaseWaitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVTITLE:@"请稍等",NAVRIGTHTITLE:@"取消"}];
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    //设置导航栏的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nagvation_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 10, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self waitUI];
}
- (void)waitUI
{
    
//    UIView* topLine = [[UIView alloc]initWithFrame:CGRectMake(0, -64, SZRScreenWidth, 1)];
//    topLine.backgroundColor = SZRNAVIGATION;
//    [self.view addSubview:topLine];
    self.dd=[[SZRRipple alloc]init];
    __weak PleaseWaitVC * tempSelf = self;
    self.dd.skipVCBlock = ^(NSTimer * timer,NSTimer * circleTimer){
        [timer invalidate];
        [circleTimer invalidate];
        timer = nil;
        circleTimer = nil;
        [tempSelf skipToSelecterDoctorVC];
    };
    self.dd.frame=CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64);
    [self.view addSubview:self.dd];
    self.grabLabel = [SZRFunction createLabelWithFrame:CGRectMake(20, SZRScreenHeight/2+100, SZRScreenWidth - 20*2, 25) color:[UIColor whiteColor] font:nil text:nil];
    self.grabLabel.textAlignment = NSTextAlignmentCenter;
    self.grabLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:@"正在为您匹配健康师..." withSubStr:@"3" withColor:[UIColor orangeColor] withFont:[UIFont systemFontOfSize:30]];

    [self.view addSubview:self.grabLabel];

    self.overBtn = [SZRFunction createButtonWithFrame:CGRectMake((SZRScreenWidth - 100)/2, CGRectGetMaxY(self.grabLabel.frame)+10, 100, 25) withTitle:@"结束抢单" withImageStr:nil withBackImageStr:nil];
    [self.overBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.overBtn addTarget:self action:@selector(overBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overBtn];
}

-(void)requestDoctorData{
    if (![VDNetRequest haveNet]) {
        [MBProgressHUD showTextOnly:@"网络连接错误!"];
        return;
    }
    NSDictionary* dic = @{@"page":@"1",@"id":self.doctorID};
    [VDNetRequest VD_PostWithURL:VDDoctorSelectList_URL arrtribute:@{VDHTTPPARAMETERS:@{@"data":[RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dic]],@"token":[VDUserTools VD_GetToken]}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
                NSArray* dataArr = (NSArray* )[RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
                self.grabLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"已有 %zd 位健康师抢单，还在继续抢单中...",dataArr.count] withSubStr:[NSString stringWithFormat:@"%zd",dataArr.count] withColor:[UIColor orangeColor] withFont:[UIFont systemFontOfSize:30]];
            }
            
        }else{
            VD_ShowBGBackError(NO);
            SZRLog(@"error %@",error);
        }
    }];
}


//结束抢单点击事件
- (void)overBtnClick:(UIButton* )btn
{
    
    if ([self.dd respondsToSelector:@selector(releaseTimer)]) {
        [self.dd performSelector:@selector(releaseTimer)];
    }
    
    [self skipToSelecterDoctorVC];
}


-(void)skipToSelecterDoctorVC{
    SelecterDoctorVC * selecterDoctorVC = [[SelecterDoctorVC alloc]init];
    selecterDoctorVC.doctorID = self.doctorID;
    [self.navigationController pushViewController:selecterDoctorVC animated:YES];
}


- (void)rightBtnClick{
    
    if ([self.dd respondsToSelector:@selector(releaseTimer)]) {
        [self.dd performSelector:@selector(releaseTimer)];
    }
    
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
