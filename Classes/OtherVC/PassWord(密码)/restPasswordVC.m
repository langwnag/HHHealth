
//
//  restPasswordVC.m
//  客邦
//
//  Created by 莱昂纳德 on 16/5/18.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "restPasswordVC.h"
#import "HHLoginVC.h"
@interface restPasswordVC ()
@property (nonatomic,strong) UIView* bgView;//背景图片
@property (nonatomic,strong) UITextField* passward;//设置密码
@property (nonatomic,strong) UITextField* rePassward;//重复密码
@end

@implementation restPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"重置登录密码"}];
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];

    [self createTextField];
}
#pragma mark 创建TextField
- (void)createTextField
{
    UILabel* label = [SZRFunction createLabelWithFrame:CGRectMake(10, 0, SZRScreenWidth - 90, 30) color:[UIColor grayColor] font:[UIFont systemFontOfSize:13] text:nil];
    label.text = @"设置新密码";
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
    //背景图片
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+5, SZRScreenWidth - 20, 100)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 3.0;
    self.bgView.layer.masksToBounds = YES;
    
     //设置密码TextField
    self.passward = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, 10, SZRScreenWidth - 70, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    self.passward.secureTextEntry = YES;
    self.passward.clearButtonMode =     UITextFieldViewModeWhileEditing;
    self.passward.keyboardType = UIKeyboardTypeASCIICapable;

    //设置密码
    UILabel* setLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, 70, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:nil];
    setLabel.text = @"设置密码:";
    self.passward.leftViewMode = UITextFieldViewModeAlways;
    self.passward.leftView = setLabel;
    //中间线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, self.bgView.frame.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1];
    [self.bgView addSubview:lineView];

    
    //重复密码TextField
    self.rePassward = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame)+5, SZRScreenWidth - 70, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    self.rePassward.secureTextEntry = YES;
    self.rePassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.rePassward.keyboardType = UIKeyboardTypeASCIICapable;
    //重复密码
    UILabel* rePasswardLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, 70, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:nil];
    rePasswardLabel.text = @"重复密码";
    self.rePassward.leftViewMode = UITextFieldViewModeAlways;
    self.rePassward.leftView = rePasswardLabel;
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.passward];
    [self.bgView addSubview:self.rePassward];

    UIButton* submitBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, CGRectGetMaxY(self.bgView.frame)+30, SZRScreenWidth - 20, 37) withTitle:@"提交" withImageStr:nil withBackImageStr:nil];
    submitBtn.backgroundColor = SZRAPPCOLOR;
    submitBtn.layer.cornerRadius = 5.0f;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
}
//提交点击事件
- (void)submitClick
{
    if ([self.passward.text isEqualToString:self.rePassward.text]) {
        
        if (![SZRFunction VD_CheckPassword:self.passward.text]) {
            [MBProgressHUD showTextOnly:@"密码格式错误"];
        }else{
            [self forgetPwdRequest];
        }
    }else{
        // 两次密码不一致
        [MBProgressHUD showTextOnly:@"两次密码不一致"];
    }
}
#pragma mark - 忘记密码
- (void)forgetPwdRequest{
    NSDictionary* dataDic = @{@"phone":self.userPhone,@"code":self.code,@"password":[MD5Encryption md5by32:self.passward.text]};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDVerificationModifyPwd_Url arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}}finish:^(NSURLSessionDataTask *task,id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(NO);
            }else{
                VD_ShowBGBackError(NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray* VCArr = self.navigationController.viewControllers;
                for (UIViewController * VC in VCArr) {
                    if ([VC isKindOfClass:NSClassFromString(@"HHLoginVC")]) {
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                }
            });
        }
    }else{
            VD_SHowNetError(NO);
        }
    } noNetwork:^{
        VD_SHowNetError(NO);
    }];
}



//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      [self.view endEditing:YES];

}



- (void)leftBtnClick
{
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
