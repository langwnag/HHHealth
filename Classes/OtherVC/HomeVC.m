//
//  HomeVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//
#define LOGINW SZRScreenWidth - 80
#define REGISTERW LOGINW
#define LOGINH 40

#import "HomeVC.h"
#import "RegisterVC.h"
#import "RootLoginVC.h"
@interface HomeVC ()

@end

@implementation HomeVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHomeVC_UI];
}

#pragma mark 创建登录、注册首页
- (void)createHomeVC_UI{
    UIImage *image = [UIImage imageNamed:@"backGround"];
    self.view.layer.contents = (id) image.CGImage;
    
    //login图片
    UIImageView* backGroundImageV = [SZRFunction createImageViewFrame:CGRectMake((SZRScreenWidth-kAdaptedWidth(253/2))/2, kAdaptedHeight(50), kAdaptedWidth(253/2),kAdaptedHeight(308/2)) imageName:@"logo" color:nil];
    [self.view addSubview:backGroundImageV];
    
    //标题
    UILabel* appTitleLa = [SZRFunction createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(backGroundImageV.frame)+8, 280, 21) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] text:@"欢 迎 来 到 您 的 私 属 健 康 管 理"];
    appTitleLa.center = CGPointMake(self.view.center.x, appTitleLa.center.y);
    appTitleLa.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appTitleLa];
    
    
    //登录按钮
    UIButton* loginBtn = [SZRFunction createButtonWithFrame:CGRectMake(40, SZRScreenHeight - kAdaptedHeight(150), LOGINW, LOGINH) withTitle:@"登录" withImageStr:nil withBackImageStr:nil];
    loginBtn.layer.borderColor = kWord_Transparent_Green.CGColor;
    loginBtn.layer.borderWidth = 2.0f;
    loginBtn.layer.cornerRadius = 2.0f;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

   //注册按钮
    /*
    UIButton* registerBtn = [SZRFunction createButtonWithFrame:CGRectMake(CGRectGetMinX(loginBtn.frame)
     , CGRectGetMaxY(loginBtn.frame)+15, REGISTERW, LOGINH) withTitle:@"注册" withImageStr:nil withBackImageStr:nil];
    registerBtn.backgroundColor = [SZRFunction SZRstringTOColor:@"04cbaa"];
    registerBtn.layer.cornerRadius = 2.0f;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
*/
    
}


#pragma mark 登录点击事件
- (void)loginBtn:(UIButton* )btn
{
    [self.navigationController pushViewController:[[RootLoginVC alloc]init] animated:NO];
    
}
#pragma mark 注册点击事件
- (void)registerBtn:(UIButton* )btn
{
    [self.navigationController pushViewController:[[RegisterVC alloc]init] animated:NO];
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
