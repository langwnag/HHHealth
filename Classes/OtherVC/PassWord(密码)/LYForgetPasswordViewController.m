//
//  LYForgetPasswordViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYForgetPasswordViewController.h"
#import "LYCountTime.h"

@interface LYForgetPasswordViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordRepeatTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView   *backView;

@property (nonatomic, strong) NSString * phoneNum;

@end

@implementation LYForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVTITLE:@"忘记密码", NAVLEFTIMAGE:kBackBtnName}];
    self.phoneNumTF.delegate = self;
    self.verifyNumTF.delegate = self;
    self.passwordNewTF.delegate = self;
    self.passwordRepeatTF.delegate = self;
    
    //键盘将要出现的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyBoradWillAppear:(NSNotification *)notification{
    CGFloat keyboardHeight = [self getKeyboardHeightWithNotification:notification];
    [self changeOriginY:(-keyboardHeight / 4)];
}

- (void)keyBoardWillHide:(NSNotification *)notification{
    [self changeOriginY:64];
}

- (void)changeOriginY:(CGFloat)originY{
    [UIView animateWithDuration: 0.5
                          delay: 0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         if (self.view.bounds.size.width > 320) {
                             return;
                         }
                         if (([self.verifyNumTF isFirstResponder] || [self.phoneNumTF isFirstResponder]) && originY < 0) {
                             return;
                         }
                         CGRect rect = self.view.frame;
                         rect.origin.y = originY;
                         self.view.frame = rect;
                     } completion: nil];
}

- (CGFloat)getKeyboardHeightWithNotification:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    return keyboardRect.size.width;
}

- (IBAction)clickCommitBtn:(UIButton *)sender {
    [self textFieldResignFirstResponder];
    
    if (self.verifyNumTF.text.length == 0) {
        [MBProgressHUD showTextOnly:@"请输入验证码"];
        return;
    }
    if (self.verifyNumTF.text.length != 4) {
        [MBProgressHUD showTextOnly:@"请输入4位验证码"];
        return;
    }
    //密码判断
    if (self.passwordNewTF.text.length == 0 || self.passwordRepeatTF.text.length == 0) {
        [MBProgressHUD showTextOnly:@"请输入密码"];
        return;
    }
    if (![SZRFunction VD_CheckPassword:self.passwordNewTF.text]) {
        [MBProgressHUD showTextOnly:@"请输入6-18位正确格式密码"];
        return;
    }
    //两次密码是否一致
    if (![self.passwordNewTF.text isEqualToString:self.passwordRepeatTF.text]) {
        [MBProgressHUD showTextOnly:@"两次密码输入不一致，请重新输入"];
        return;
    }
    //需要判断用户在获取验证码之后是否修改了手机号码
    self.phoneNum = self.phoneNum.length > 0 ? self.phoneNum : self.phoneNumTF.text;
    if (![self.phoneNum isEqualToString:self.phoneNumTF.text]) {
        [self showAlertViewWithTextWithTitle:@"当前手机号与获取验证码手机号不一致，请确认是否发送到当前手机号码"];
        return;
    }
    [self requestRevisePassword];
}

- (IBAction)clickGetVerifyBtn:(UIButton *)sender {
    [self textFieldResignFirstResponder];
    //验证手机号码是否正确
    NSString * resultStr = [SZRFunction verifyPhoneNum:self.phoneNumTF.text];
    if (![resultStr isEqualToString:@"YES"]) {
        [MBProgressHUD showTextOnly:resultStr];
        return;
    }
    [self requestVarifyNum];
    
}
#pragma mark - request data from server
//获取验证码
- (void)requestVarifyNum{
    NSDictionary* dataDic = @{@"phone":self.phoneNumTF.text};
    self.phoneNum = self.phoneNumTF.text;
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDRequirePwdCode_Url
                      arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}}
                          finish:^(NSURLSessionDataTask *task,id responseObject, NSError *error) {
                              if (!error) {
                                  if (![responseObject[RESULT] boolValue]) {
                                      VD_ShowBGBackError(NO);
                                  }else{
                                      [[LYCountTime shareCountTime] countTimeWithBtn:self.getVerifyNumBtn];;
                                  }
                              }else{
                                  VD_SHowNetError(NO);
                              }
                          }
                       noNetwork:^{
                              VD_SHowNetError(NO);
                          }];
}
//修改密码
- (void)requestRevisePassword{

    NSDictionary* dataDic = @{@"phone":self.phoneNumTF.text,
                              @"code":self.verifyNumTF.text,
                              @"password":[MD5Encryption md5by32:self.passwordNewTF.text]};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDVerificationModifyPwd_Url
                      arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}}
                          finish:^(NSURLSessionDataTask *task,id responseObject, NSError *error) {
                              if (!error) {
                                  if (![responseObject[RESULT] boolValue]) {
                                      VD_ShowBGBackError(NO);
                                  }else{
                                      VD_ShowBGBackError(NO);
                                      for (UIViewController * VC in self.navigationController.viewControllers) {
                                          if ([VC isKindOfClass:NSClassFromString(@"HHLoginVC")]) {
                                              [self.navigationController popToViewController:VC animated:YES];
                                          }
                                      }
                                  }

                              }else{
                                  VD_SHowNetError(NO);
                              }
                          } noNetwork:^{
                              VD_SHowNetError(NO);
                          }];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (textField.tag) {
        case 1001:{
            return ((textField.text.length + string.length) > 11) ? NO : YES;
        }break;
        case 1002:{
            return ((textField.text.length + string.length) > 4) ? NO : YES;
        }break;
        case 1003:{
            return ((textField.text.length + string.length) > 20) ? NO : YES;
        }break;
        case 1004:{
            return ((textField.text.length + string.length) > 20) ? NO : YES;
        }break;
            
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1003) {
        [self.passwordNewTF resignFirstResponder];
        [self.passwordRepeatTF becomeFirstResponder];
    }else if (textField.tag == 1004){
        [self.passwordRepeatTF resignFirstResponder];
    }
    return YES;
}

//所有的textField退出第一响应者
- (void)textFieldResignFirstResponder{
    for (UIView * view in self.backView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField * tf = (UITextField *)view;
            [tf resignFirstResponder];
        }
    }
}

#pragma mark - UITouchDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self textFieldResignFirstResponder];
    }
}
#pragma mark - UINavigation
//导航栏左侧按钮点击事件
- (void)leftBtnClick{
    [super leftBtnClick];
    [self textFieldResignFirstResponder];
}
#pragma mark - UIAlertView & UIAlertViewDelegate
- (void)showAlertViewWithTextWithTitle:(NSString *)title{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        [self requestRevisePassword];
    }
}
@end
