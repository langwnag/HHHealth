
//
//  ForgetPassWordVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ForgetPassWordVC.h"
#import "HHLoginVC.h"
#import "restPasswordVC.h"
@interface ForgetPassWordVC ()<UITextFieldDelegate>
//背景视图
@property (nonatomic,strong) UIView* bgView;
//手机号textField
@property (nonatomic,strong) UITextField* phoneTF;
//验证码textField
@property (nonatomic,strong) UITextField* codeTF;
//验证码剩余时间
@property (assign,nonatomic) NSInteger timeCount;
//定时器
@property (nonatomic,strong) NSTimer* timer;
//获取验证码
@property(nonatomic,strong)UIButton * verifyCodeBtn;

@end

@implementation ForgetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"找回密码1/2"}];
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    [self createTextFields];

}

//忘记密码
- (void)createTextFields
{
    //请输入手机号
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SZRScreenWidth-90, 30)];
    label.text = @"请输入您的手机号";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+5, SZRScreenWidth-20, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 3.0;
    //手机号码textField
    self.phoneTF = [self createTextFielfFrame:CGRectMake(20, 10, SZRScreenWidth-60, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
    self.phoneTF.delegate = self;
    self.phoneTF.tag = 1001;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    //创建验证码textField
    self.codeTF = [self createTextFielfFrame:CGRectMake(20, 60, SZRScreenWidth-30-120, 30) font:[UIFont systemFontOfSize:15] placeholder:@"6位数字"];
    self.codeTF.tag = 1002;
    self.codeTF.delegate = self;
    self.codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    //手机号Label
    UILabel * phoneLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, 50, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:nil];
    phoneLabel.text = @"手机号:";
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTF.leftView = phoneLabel;
    //验证码Label
    UILabel * codeLabel = [SZRFunction createLabelWithFrame:CGRectMake(20, 62, 50, 25) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:nil];
    codeLabel.text = @"验证码:";
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftView = codeLabel;
    //添加两个textField
    [_bgView addSubview:self.phoneTF];
    [_bgView addSubview:self.codeTF];
    
    //获取验证码btn
    self.verifyCodeBtn = [self createButtonFrame:CGRectMake(SZRScreenWidth-100-20, 62, 80, 30) backImageName:nil title:@"获取验证码" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(getValidCode:)];
    self.verifyCodeBtn.backgroundColor = [UIColor orangeColor];
    self.verifyCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.verifyCodeBtn.layer.cornerRadius = 5.0f;
    self.verifyCodeBtn.layer.masksToBounds = YES;
    
    [_bgView addSubview:self.verifyCodeBtn];
    
    
    UIImageView* line1 = [self createImageViewFrame:CGRectMake(20, 50, _bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1]];
    [_bgView addSubview:line1];
    
    [self.view addSubview:_bgView];
    //下一步btn
    UIButton * nextBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, CGRectGetMaxY(_bgView.frame)+30, SZRScreenWidth-20, 37) withTitle:@"下一步" withImageStr:nil withBackImageStr:nil];
    nextBtn.backgroundColor = RGBCOLOR(47, 123, 220);
    nextBtn.layer.cornerRadius=5.0f;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = SZRAPPCOLOR;
    [self.view addSubview:nextBtn];
}


//获取验证码点击事件
- (void)getValidCode:(UIButton* )btn
{
    if (![SZRFunction VD_CheckPhoneNum:self.phoneTF.text]){
        
        [MBProgressHUD showTextOnly:@"请输入11位有效的手机号码" hideBeforeShow:YES];
     
        return;
    }
    [self pwdCodeRequest];
}
#pragma mark - 发送修改密码的验证码
- (void)pwdCodeRequest{

    NSDictionary* dataDic = @{@"phone":self.phoneTF.text};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDRequirePwdCode_Url arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}}finish:^(NSURLSessionDataTask *task,id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(NO);
                self.verifyCodeBtn.userInteractionEnabled = YES;
            }else{
                self.verifyCodeBtn.userInteractionEnabled = NO;
                [MBProgressHUD showTextOnly:@"验证码正在发送中..."];
                self.timeCount = 60;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
          }
        }else{
            VD_SHowNetError(NO);
            self.verifyCodeBtn.userInteractionEnabled = YES;
        }
    } noNetwork:^{
        VD_SHowNetError(NO);
        self.verifyCodeBtn.userInteractionEnabled = YES;
    }];
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

// 下一步的点击事件
- (void)nextBtnClick{

    if (![[SZRFunction verifyPhoneNum:self.phoneTF.text] isEqualToString:@"YES"]) {
        [MBProgressHUD showTextOnly:[SZRFunction verifyPhoneNum:self.phoneTF.text]];
    } else if (![[SZRFunction verifyCode:self.codeTF.text] isEqualToString:@"YES"]){
        [MBProgressHUD showTextOnly:[SZRFunction verifyCode:self.codeTF.text]];
    }
    else{
        restPasswordVC* passWordVC = [[restPasswordVC alloc]init];
        passWordVC.userPhone = self.phoneTF.text;
        passWordVC.code = self.codeTF.text;
        [self.navigationController  pushViewController:passWordVC animated: YES];
        //销毁定时
        [self.timer invalidate];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1001 && (textField.text.length + string.length > 11)) {
        return NO;
    }else if (textField.tag == 1002 && (textField.text.length + string.length > 6)){
        return NO;
    }
    return YES;
}
//键盘响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
}
//返回按钮
- (void)leftBtnClick{
    HHLoginVC* rootLoginVC = [[HHLoginVC alloc]init];
    [self.navigationController pushViewController:rootLoginVC animated:NO];
}



- (UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

- (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

- (UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
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
