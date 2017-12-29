//
//  RootLoginVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RootLoginVC.h"
#import "privateHealthVC.h"
#import "SZRTabBarVC.h"
#import "ForgetPassWordVC.h"
#import "RegisterVC.h"
#import "PerfectInformationVC.h"
#import "HHUserToken.h"
#import "HomeVC.h"
@interface RootLoginVC ()<RCIMConnectionStatusDelegate>
//背景视图
@property (nonatomic,strong) UIView* bgView;

//手机号textField
@property(nonatomic,strong)UITextField * phoneTF;
//密码textField
@property(nonatomic,strong)UITextField * passwordTF;
//登录按钮
@property(nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong) NSString * loginUserName;
@property (nonatomic,strong) NSString * loginToken;
@property (nonatomic,strong) NSString * loginPortraits;
@property (nonatomic,assign) int loginFailureTimes;

@end

@implementation RootLoginVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 让光标成为第一响应者
    [_phoneTF becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationController.viewControllers[0] isKindOfClass:self.class]) {
        [self createNavItems:@{NAVTITLE:@"用户登录"}];
    }else{
        [self createNavItems:@{NAVLEFTTITLE:@"取消",NAVTITLE:@"用户登录"}];
    }
    [self LoginUI];
}
#pragma mark 登录
- (void)LoginUI{
    //设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SZRScreenWidth, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    //手机号textField
    self.phoneTF = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, 10, SZRScreenWidth-60, 30) color:nil font:[UIFont systemFontOfSize:14] placeholder:@"请输入手机号"];
    self.phoneTF.textColor = [UIColor blackColor];
    // 赋值
    self.phoneTF.text = [self getDefaultUserName];
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:self.phoneTF];
    //中间线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, SZRScreenWidth - 40, 1)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    
    //密码textField
    self.passwordTF = [SZRFunction VDCreateTextFieldFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame) , SZRScreenWidth - 100, 45) color:nil font:[UIFont systemFontOfSize:14] placeholder:@"请输入密码"];
    self.passwordTF.textColor = [UIColor blackColor];
    self.passwordTF.keyboardType = UIReturnKeyDone;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    // 赋值
    self.passwordTF.text = [self getDefaultUserPwd];
    [_bgView addSubview:self.passwordTF];
    
    
    //登录按钮
    UIButton* loginBtn = [SZRFunction createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(_bgView.frame)+20, SZRScreenWidth - 20*2, 40) withTitle:@"登录" withImageStr:nil withBackImageStr:nil];
    loginBtn.backgroundColor = [SZRFunction SZRstringTOColor:@"04cbaa"];
    loginBtn.layer.cornerRadius = 2.0f;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
//    //新用户注册
//    UIButton* newPersonRegister = [SZRFunction createButtonWithFrame:CGRectMake(5, CGRectGetMaxY(loginBtn.frame)+20, 110, 21) withTitle:@"新用户注册" withImageStr:nil withBackImageStr:nil];
//    newPersonRegister.titleLabel.font = [UIFont systemFontOfSize:15];
//    [newPersonRegister addTarget:self action:@selector(newPersonRegisterClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:newPersonRegister];
//    
//    //忘记密码
//    UIButton* forgotPassword = [SZRFunction createButtonWithFrame:CGRectMake(SZRScreenWidth-90, CGRectGetMaxY(loginBtn.frame)+20, 80, 21) withTitle:@"忘记密码？" withImageStr:nil withBackImageStr:nil];
//    forgotPassword.titleLabel.font = [UIFont systemFontOfSize:15];
//    [forgotPassword addTarget:self action:@selector(forgotPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forgotPassword];
    
    
    
}

- (void)loginBtn:(UIButton* )btn
{
    
    if (![SZRFunction VD_CheckPhoneNum:self.phoneTF.text]) {
        [MBProgressHUD showTextOnly:@"请输入11位有效的手机号码"];
    }
    else if(![SZRFunction VD_CheckPassword:self.passwordTF.text]){
        [MBProgressHUD showTextOnly:@"请输入至少6位密码"];
    }else{
        
        self.loginBtn.userInteractionEnabled = YES;
        //登录
        [self requestLogin];
    }
    
}

#pragma mark 登录请求
-(void)requestLogin{
    RCNetworkStatus stauts =
    [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (stauts == RC_NotReachable) {
        [MBProgressHUD showTextOnly:@"当前网络不可用，请检查!"];
        return;
    }
    [MBProgressHUD showMessage:@"正在登录..."];

    NSDictionary* dataDic = @{@"phone":self.phoneTF.text,@"password":[MD5Encryption md5by32:self.passwordTF.text]};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    
    [VDNetRequest VD_PostWithURL:VDLogin_Url arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
            
                NSDictionary* userDic = [SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
//                SZRLog(@"haha %@",kBGDataStr);
         
                [VDUserTools VDSaveLoginMessege:userDic];
                [VDUserTools VD_ATLAESTONCELOGIN:YES];
                [VDUserTools VD_SaveToken:userDic[@"userToken"][@"token"]];
                [VDUserTools VD_SaveUserPrivateDoctorArr:userDic[@"userPrivateDoctor"]];
                
                [MBProgressHUD hideHUD];
                _loginToken = [DEFAULTS objectForKey:CLIENTTOKEN];
                _loginUserName = [DEFAULTS objectForKey:CLIENTNAME];
                _loginPortraits = [DEFAULTS objectForKey:CLIENTHEADPORTRATION];
                [self requestRongCloudToken];

                }else{
                VD_ShowBGBackError(YES);
                self.loginBtn.userInteractionEnabled = YES;
            }
        }else{
            VD_SHowNetError(YES);
            self.loginBtn.userInteractionEnabled = YES;
        }
    }];
    
}
-(void)requestRongCloudToken{
    
    [VDNetRequest VD_GetRongCloudToken:^(NSDictionary *dic) {
        [DEFAULTS setObject:dic[@"token"] forKey:RCDTOKEN];
        [DEFAULTS setObject:dic[@"id"] forKey:RCDCLIENTID];
        [DEFAULTS synchronize];
        
        [self loginRongCloud];
    } BGError:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VD_ShowBGBackError(YES);
        });
    } Error:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            VD_SHowNetError(YES);
        });
    }];
}
-(void)loginRongCloud{
    [[RCIM sharedRCIM]connectWithToken:[DEFAULTS objectForKey:RCDTOKEN] success:^(NSString *userId) {
        
        [self loginRongCloudSucceed];
        
    } error:^(RCConnectErrorCode status) {
        SZRLog(@"RCConnectErrorCode is %ld", (long)status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showTextOnly:@"登录失败" hideBeforeShow:YES];
            [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
        });
        
        
    } tokenIncorrect:^{
        if (_loginFailureTimes < 1) {
            _loginFailureTimes++;
            [self requestRongCloudToken];
        }
    }];
}
-(void)loginRongCloudSucceed{
    NSString * RCID = [DEFAULTS objectForKey:RCDCLIENTID];
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:RCID
                                                     name:_loginUserName
                                                 portrait:_loginPortraits];
    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:RCID];
    [RCIM sharedRCIM].currentUserInfo = user;

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([VDUserTools VDGetLoginModel].userInformation) {
            // 跳转TabBar控制VC
            [VDUserTools skipToMainVC:self];
        }else{
            PerfectInformationVC* perfectVc = [[PerfectInformationVC alloc]init];
            [self.navigationController pushViewController:perfectVc animated:YES];
        
        }
    });
    
}



-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
            [self loginRongCloudSucceed];
        }else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            [MBProgressHUD showTextOnly:@"当前网络不可用，请检查！"];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            [MBProgressHUD showTextOnly:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            [self requestRongCloudToken];
        }
    });
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

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark 忘记密码点击事件
- (void)forgotPasswordClick:(UIButton* )forgetBtn{
    ForgetPassWordVC* forgetPassVC = [[ForgetPassWordVC alloc]init];
    [self.navigationController pushViewController:forgetPassVC animated:NO];
    
}

#pragma mark 新用户注册
- (void)newPersonRegisterClick{
    RegisterVC* registerVC = [[RegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:NO];
}
- (void)leftBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
