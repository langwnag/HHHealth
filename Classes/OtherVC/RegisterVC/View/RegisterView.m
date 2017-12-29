//
//  RegisterView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


-(void)configUI{

    NSArray * phoneNumArr = [self createTextField:@"请输入手机号" haveRightBtn:NO topView:self haveBottomLine:YES];
    self.phoneNumTF = phoneNumArr[1];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    NSArray * verifyCodeArr = [self createTextField:@"验证码" haveRightBtn:YES topView:phoneNumArr[0] haveBottomLine:YES];
    UIView * verifyCodeBGView = verifyCodeArr[0];
    self.verifyCodeTF = verifyCodeArr[1];
    UIButton * sendVerifyCodeBtn = [self createBtnTitle:@"发送验证码" BGColor:kWord_BrightPink_COLOR selector:@selector(sendVerifyCodeBtnClick:)];
    self.sendVerifyCodeBtn = sendVerifyCodeBtn;
    [verifyCodeBGView addSubview:sendVerifyCodeBtn];
    sendVerifyCodeBtn.sd_layout
    .leftSpaceToView(self.verifyCodeTF,kAdaptedWidth_2(10))
    .topSpaceToView(verifyCodeBGView,kAdaptedHeight_2(15))
    .bottomSpaceToView(verifyCodeBGView,kAdaptedHeight_2(15))
    .rightSpaceToView(verifyCodeBGView,kAdaptedWidth_2(32));
    sendVerifyCodeBtn.sd_cornerRadius = @(kAdaptedWidth(5));
    
    
    NSArray * passwordArr = [self createTextField:@"设置密码(6-18位字母、数字或下划线)" haveRightBtn:NO topView:verifyCodeBGView haveBottomLine:NO];
    UIView * passwordBGView = passwordArr[0];
    self.passwordTF = passwordArr[1];
    self.passwordTF.secureTextEntry = YES;
    
    NSArray * vipInviteCodeArr = [self createTextField:@"输入已有邀请码(可不填)" haveRightBtn:YES topView:passwordBGView haveBottomLine:NO];
    UIView * inviteCodeBGView = vipInviteCodeArr[0];
    self.vipInviteCodeTF = vipInviteCodeArr[1];
    inviteCodeBGView.sd_layout
    .topSpaceToView(passwordBGView,kAdaptedHeight_2(27));
    
    UIButton * getInviteCodeBtn = [self createBtnTitle:@"获取邀请码" BGColor:HEXCOLOR(0x57999c) selector:@selector(getInviteCodeBtnClick:)];
    
    [inviteCodeBGView addSubview:getInviteCodeBtn];
    getInviteCodeBtn.sd_layout
    .leftSpaceToView(self.vipInviteCodeTF,kAdaptedWidth_2(10))
    .topSpaceToView(inviteCodeBGView,kAdaptedHeight_2(15))
    .bottomSpaceToView(inviteCodeBGView,kAdaptedHeight_2(15))
    .rightSpaceToView(inviteCodeBGView,kAdaptedWidth_2(32));
    getInviteCodeBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    UIButton * registerBtn = [self createBtnTitle:@"注  册" BGColor:HEXCOLOR(0x05cfaa) selector:@selector(registerBtnClick)];
    registerBtn.titleLabel.font = kLightFont(kFontAdaptedWidth(16));
    [self addSubview:registerBtn];
    registerBtn.sd_layout
    .leftSpaceToView(self,kAdaptedWidth_2(32))
    .rightSpaceToView(self,kAdaptedWidth_2(32))
    .topSpaceToView(inviteCodeBGView,kAdaptedHeight_2(53))
    .heightIs(kAdaptedHeight(45));
    registerBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    UILabel * protocolLabel = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor whiteColor] font:kLightFont(kFontAdaptedWidth(11)) text:@""];
    protocolLabel.numberOfLines = 2;
    [self addSubview:protocolLabel];
    protocolLabel.textAlignment = NSTextAlignmentCenter;
    NSString * str = @"点击注册表示你已阅读并同意\n合合健康会员服务协议";
    NSMutableAttributedString * mAttriStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mAttriStr addAttribute:NSForegroundColorAttributeName value:kWord_Transparent_Green range:[str rangeOfString:@"合合健康会员服务协议"]];
    protocolLabel.attributedText = mAttriStr;
    protocolLabel.sd_layout
    .leftSpaceToView(self,kAdaptedWidth_2(233))
    .rightSpaceToView(self,kAdaptedWidth_2(233))
    .heightIs(kAdaptedHeight(45))
    .bottomSpaceToView(self,kAdaptedHeight(8));
    
    
   
}

-(void)sendVerifyCodeBtnClick:(UIButton *)btn{
    
    if (![SZRFunction VD_CheckPhoneNum:self.phoneNumTF.text]) {
        [MBProgressHUD showTextOnly:@"请输入11位有效的手机号码" hideBeforeShow:YES];
        return;
    }
    
    if (self.sendVerifyCodeBlock) {
        self.sendVerifyCodeBlock(self.phoneNumTF.text);
    }
    
}

-(void)getInviteCodeBtnClick:(UIButton *)btn{
    
}

-(void)registerBtnClick{
    
    if (![SZRFunction VD_CheckPhoneNum:self.phoneNumTF.text]) {
        [MBProgressHUD showTextOnly:@"请输入正确的11位手机号码"];
    }else if(![SZRFunction VD_CheckVerifyCode:self.verifyCodeTF.text]){
        [MBProgressHUD showTextOnly:@"验证码格式不正确"];
    }else if(![SZRFunction VD_CheckPassword:self.passwordTF.text]){
        [MBProgressHUD showTextOnly:@"密码格式错误，请重新设置"];
    }
//    else if([self.vipInviteCodeTF.text length] == 0){
//        [MBProgressHUD showTextOnly:@"请输入邀请码"];
//    }
    else{
        if (self.registerBlock) {
            self.registerBlock(@{@"phone":self.phoneNumTF.text,@"code":self.verifyCodeTF.text,@"password":self.passwordTF.text,@"inviteCode":@""});
        }
        
    }
    
}



// index0 背景父视图  index1 UITextField
-(NSArray *)createTextField:(NSString *)placeHolder haveRightBtn:(BOOL)haveRightBtn topView:(UIView *)topView haveBottomLine:(BOOL)haveBottomLine{
    
    UIView * bgWhiteView = [SZRFunction createView:[UIColor whiteColor]];
    [self addSubview:bgWhiteView];
    
    UITextField * textField = [SZRFunction VDCreateTextFieldFrame:CGRectNull color:kWord_Gray_9 font:kLightFont(kFontAdaptedWidth(14)) placeholder:placeHolder];
    [bgWhiteView addSubview:textField];

    bgWhiteView.sd_layout
    .topSpaceToView(topView,0)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(kAdaptedHeight_2(90));
    
    textField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(kAdaptedHeight_2(30),kAdaptedWidth_2(32),kAdaptedHeight_2(30),haveRightBtn ? kAdaptedWidth_2(210):kAdaptedWidth_2(32)));
    if (haveBottomLine) {
        UIView * lineView = [SZRFunction createView:HEXCOLOR(0xa5c3c7)];
        [bgWhiteView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(bgWhiteView,kAdaptedWidth_2(32))
        .rightSpaceToView(bgWhiteView,kAdaptedWidth_2(32))
        .heightIs(1)
        .bottomEqualToView(bgWhiteView);
        
    }
    
    return @[bgWhiteView,textField];
}

-(UIButton *)createBtnTitle:(NSString *)title BGColor:(UIColor *)BGColor selector:(SEL)selector{
    UIButton * btn = [SZRFunction createBtn:title titleColor:[UIColor whiteColor] titleFont:kLightFont(kFontAdaptedWidth(14))];
    btn.backgroundColor = BGColor;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}




@end
