//
//  HHLoginVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHLoginVC.h"
#import "LoginTextField.h"
#import "PerfectInformationVC.h"
//#import "ForgetPassWordVC.h"
#import "AgreementView.h"
#import "RegisterVC.h"
#import "LYForgetPasswordViewController.h"
#import "LAUserInfo.h"

@interface HHLoginVC () <UITextFieldDelegate, RCIMConnectionStatusDelegate>

@property(nonatomic, strong) UITextField *phoneNumTF;
@property(nonatomic, strong) UITextField *passwordTF;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) NSString *loginUserName;
@property(nonatomic, strong) NSString *loginToken;
@property(nonatomic, strong) NSString *loginPortraits;
@property(nonatomic, assign) int loginFailureTimes;

@end

@implementation HHLoginVC {
    CGFloat _totalKeybordHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self keyboardNoti];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self removeKeyboardNoti];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];

}

- (void)configUI {
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"LoginVC_BG"];

    NSArray *numViews = [[LoginTextField new] imageVWithTFSequence:1 LeftImageV:@"Login_Image_Iphone" placeHolder:@"请输入您的会员手机号"];
    UIImageView *numView = [numViews objectAtIndex:0];
    _phoneNumTF = [numViews objectAtIndex:1];
    _phoneNumTF.text = [self getDefaultUserName];
    _phoneNumTF.returnKeyType = UIReturnKeyNext;
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTF.delegate = self;

    LoginTextField *loginTextField = [LoginTextField new];
    loginTextField.forgetPasswordBtnBlock = ^() {
        [self forgetPasswordBtnClick];
    };
    NSArray *passwordViews = [loginTextField imageVWithTFSequence:2 LeftImageV:@"Login_Image_Password" placeHolder:@"6-18位字母、数字或下划线"];

    UIImageView *passwordView = [passwordViews objectAtIndex:0];
    _passwordTF = [passwordViews objectAtIndex:1];
    _passwordTF.text = [self getDefaultUserPwd];
    _passwordTF.secureTextEntry = YES;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    _passwordTF.delegate = self;

    UIButton *registerBtn = [SZRFunction createBtn:@"用户注册" titleColor:kWord_Transparent_Green titleFont:[UIFont systemFontOfSize:kAdaptedHeight(12)]];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];


    UIButton *loginBtn = [SZRFunction createButtonWithFrame:CGRectNull withTitle:@"进入" withImageStr:nil withBackImageStr:nil];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = kBG_Green_Color;
    _loginBtn = loginBtn;

    AgreementView *agreementView = [[AgreementView alloc] init];


    [self.view sd_addSubviews:@[numView, passwordView, registerBtn, loginBtn, agreementView]];
    numView.sd_layout
            .topSpaceToView(self.view, kAdaptedHeight(555 / 2))
            .leftSpaceToView(self.view, kAdaptedWidth(37 / 2))
            .heightIs(kAdaptedHeight(90 / 2))
            .rightSpaceToView(self.view, kAdaptedWidth(37 / 2));

    passwordView.sd_layout
            .topSpaceToView(numView, kAdaptedHeight(35 / 2))
            .leftEqualToView(numView)
            .rightEqualToView(numView)
            .heightRatioToView(numView, 1);

    registerBtn.sd_layout
            .topSpaceToView(passwordView, kAdaptedHeight(12))
            .rightSpaceToView(self.view, kAdaptedWidth(32))
            .widthIs(kAdaptedWidth(70))
            .heightIs(kAdaptedHeight(18));

    loginBtn.sd_layout
            .topSpaceToView(passwordView, kAdaptedHeight(135 / 2))
            .heightIs(kAdaptedWidth(45))
            .leftEqualToView(numView)
            .rightEqualToView(numView);
    loginBtn.sd_cornerRadiusFromHeightRatio = @0.5;

    agreementView.sd_layout
            .bottomEqualToView(self.view).offset(kAdaptedHeight(-15))
            .leftEqualToView(self.view)
            .rightEqualToView(self.view)
            .heightIs(kAdaptedWidth(13));

}


- (void)forgetPasswordBtnClick {
    LYForgetPasswordViewController *forgetPassVC = [[LYForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPassVC animated:NO];
}

- (void)loginBtnClick {
    if (![SZRFunction VD_CheckPhoneNum:_phoneNumTF.text]) {
        ShowTextHUD(@"请输入11位有效的手机号码", nil);
    } else if (![SZRFunction VD_CheckPassword:_passwordTF.text]) {
        ShowTextHUD(@"请输入6-18位字母、数字或下划线", nil);
    } else {
        self.loginBtn.userInteractionEnabled = NO;
        [self requestLogin];
    }

}

- (void)registerBtnClick {
    RegisterVC *registerVC = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:NO];
}

#pragma mark 登录请求

- (void)requestLogin {
    RCNetworkStatus stauts =
            [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (stauts == RC_NotReachable) {
        [MBProgressHUD showTextOnly:@"当前网络不可用，请检查!"];
        return;
    }

    ShowLoadingHUD(@"正在登录", nil);
    NSDictionary *parameters = @{@"phone": self.phoneNumTF.text,
            @"password": self.passwordTF.text};
    [Request postRequest:LALogin parameters:parameters success:^(id json) {
        self.loginBtn.userInteractionEnabled = YES;
        LAUserInfo *userInfo = [LAUserInfo mj_objectWithKeyValues:json[@"result"]];
        userInfo.password = self.passwordTF.text;
        [userInfo save];
//        [VDUserTools VDSaveLoginMessege:parameters];
//        [VDUserTools VD_ATLAESTONCELOGIN:YES];
//        [VDUserTools VD_SaveToken:userDic[@"userToken"][@"token"]];
//        [VDUserTools VD_SaveUserPrivateDoctorArr:userDic[@"userPrivateDoctor"]];

        _loginToken = userInfo.token;
        _loginUserName = userInfo.nickname;
//        _loginPortraits = [DEFAULTS objectForKey:CLIENTHEADPORTRATION];
//        [self requestRongCloudToken];
        if (userInfo.information == 0) {
            // 跳转TabBar控制VC
            [VDUserTools skipToMainVC:self];
        } else {
            PerfectInformationVC *perfectVc = [[PerfectInformationVC alloc] init];
            [self.navigationController pushViewController:perfectVc animated:YES];
        }
    }       stateSuccess:^(id json) {
        self.loginBtn.userInteractionEnabled = YES;
    }            failure:^(NSError *error) {
        self.loginBtn.userInteractionEnabled = YES;
    }];
}

- (void)requestRongCloudToken {

    [VDNetRequest VD_GetRongCloudToken:^(NSDictionary *dic) {
        [DEFAULTS setObject:dic[@"token"] forKey:RCDTOKEN];
        [DEFAULTS setObject:dic[@"id"] forKey:RCDCLIENTID];
        [DEFAULTS synchronize];

        [self loginRongCloud];
    }                          BGError:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VD_ShowBGBackError(YES);
        });
    }                            Error:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            VD_SHowNetError(YES);
        });
    }];
}

- (void)loginRongCloud {
    [[RCIM sharedRCIM] logout];
    [[RCIM sharedRCIM] connectWithToken:[DEFAULTS objectForKey:RCDTOKEN] success:^(NSString *userId) {

        [self loginRongCloudSucceed];

    }                             error:^(RCConnectErrorCode status) {
        SZRLog(@"RCConnectErrorCode is %ld", (long) status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showTextOnly:@"登录失败" hideBeforeShow:YES];
            [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        });

    }                    tokenIncorrect:^{
        if (_loginFailureTimes < 1) {
            _loginFailureTimes++;
            [self requestRongCloudToken];
        }
    }];
}

- (void)loginRongCloudSucceed {
    NSString *RCID = [DEFAULTS objectForKey:RCDCLIENTID];
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:RCID
                                                     name:_loginUserName
                                                 portrait:_loginPortraits];
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:RCID];
    [RCIM sharedRCIM].currentUserInfo = user;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfoNofiName object:self];
        if ([VDUserTools VDGetLoginModel].userInformation) {
            // 跳转TabBar控制VC
            [VDUserTools skipToMainVC:self];
        } else {
            PerfectInformationVC *perfectVc = [[PerfectInformationVC alloc] init];
            [self.navigationController pushViewController:perfectVc animated:YES];
        }
    });

}


- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id <RCIMConnectionStatusDelegate>) [UIApplication sharedApplication].delegate;
            [self loginRongCloudSucceed];
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            [MBProgressHUD showTextOnly:@"当前网络不可用，请检查！"];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            [MBProgressHUD showTextOnly:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            [self requestRongCloudToken];
        }
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_phoneNumTF isFirstResponder]) {
        [_phoneNumTF resignFirstResponder];
        [_passwordTF becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

/*获取用户账号*/
- (NSString *)getDefaultUserName {
    NSString *defaultUser = [DEFAULTS objectForKey:@"phone"];
    return defaultUser;
}

/*获取用户密码*/
- (NSString *)getDefaultUserPwd {
    NSString *defaultUserPwd = [DEFAULTS objectForKey:@"userPwd"];
    return defaultUserPwd;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_phoneNumTF == textField) {
        if (_phoneNumTF.text.length + string.length > 11) {
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
