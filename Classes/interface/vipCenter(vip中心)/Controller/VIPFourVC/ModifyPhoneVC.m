//
//  ModifyPhoneVC.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ModifyPhoneVC.h"
#import "PCData.h"
@interface ModifyPhoneVC ()
//背景视图
@property (nonatomic,strong) UIView* bgView;
//手机号textField
@property(nonatomic,strong)UITextField * phoneTF;
//密码textField
@property(nonatomic,strong)UITextField * passwordTF;
//登录按钮
@property(nonatomic,strong)UIButton * loginBtn;
//获取验证码
@property(nonatomic,strong)UIButton * verifyCodeBtn;
//验证码剩余时间
@property (assign,nonatomic) NSInteger timeCount;
//定时器
@property (nonatomic,strong) NSTimer* timer;
@end

@implementation ModifyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTTITLE:@"取消",NAVTITLE:@"修改手机号"}];
    [self setupUI];
}
- (void)setupUI{
    // 设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    UILabel* intrLa = [SZRFunction createLabelWithFrame:CGRectMake(0, 10, SZRScreenWidth, 21) color:[UIColor whiteColor] font:SYSTEMFONT(15) text:@"  绑定常用手机，可用新手机号登录"];
    [self.view addSubview:intrLa];
    
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(intrLa.frame)+10, SZRScreenWidth, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    //手机号textField
    self.phoneTF = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, 10, SZRScreenWidth-60, 30) color:nil font:[UIFont systemFontOfSize:14] placeholder:@"请输入手机号"];
    self.phoneTF.textColor = [UIColor blackColor];
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [_bgView addSubview:self.phoneTF];
    
    //中间线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, SZRScreenWidth - 40, 1)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    
    //获取验证码btn
    self.verifyCodeBtn = [SZRFunction createButtonWithFrame:CGRectMake(SZRScreenWidth-100, CGRectGetMaxY(lineView.frame)+8, 80, 30) withTitle:@"获取验证码" withImageStr:nil withBackImageStr:nil];
    self.verifyCodeBtn.backgroundColor = [UIColor orangeColor];
    self.verifyCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.verifyCodeBtn.layer.cornerRadius = 5.0f;
    self.verifyCodeBtn.layer.masksToBounds = YES;
    [self.verifyCodeBtn addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgView addSubview:self.verifyCodeBtn];
    
    //密码textField
    self.passwordTF = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame) , SZRScreenWidth - 100, 45) color:nil font:[UIFont systemFontOfSize:14] placeholder:@"请输入密码"];
    self.passwordTF.textColor = [UIColor blackColor];
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.keyboardType = UIKeyboardTypeDefault;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    [_bgView addSubview:self.passwordTF];
    
    
    //登录按钮
    UIButton* loginBtn = [SZRFunction createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(_bgView.frame)+20, SZRScreenWidth - 20*2, 40) withTitle:@"确定" withImageStr:nil withBackImageStr:nil];
    loginBtn.backgroundColor = [SZRFunction SZRstringTOColor:@"04cbaa"];
    loginBtn.layer.cornerRadius = 2.0f;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];

}
#pragma mark 登录点击事件
- (void)loginBtn:(UIButton* )btn
{
    [self.navigationController pushViewController:[PCData new] animated:NO];
    
}
//获取验证码点击事件
- (void)getValidCode:(UIButton* )btn
{
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];

}
//设置验证码剩余有效时间
- (void)reduceTime:(NSTimer* )timer
{
    self.timeCount--;
    if (self.timeCount == 0) {
        [self.verifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.verifyCodeBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
    }else{
        [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%zds",self.timeCount] forState:UIControlStateNormal];
    }
    
}
- (void)leftBtnClick{
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
