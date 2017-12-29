//
//  RegisterVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RegisterVC.h"
#import "personalDataVC.h"
#import "PerfectInformationVC.h"
#import "HHLoginVC.h"
#import "RegisterView.h"

@interface RegisterVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton * sendVerifyCodeBtn;
//倒计时
@property (nonatomic,strong) NSTimer * timer;
//验证码剩余时间
@property (nonatomic,assign) NSInteger timeCount;

//@property(nonatomic,strong)UITextField *


@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cofigUI];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


-(void)cofigUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVLEFTTITLE:@"登录",NAVTITLE:@"新用户注册"}];
    [SZRFunction SZRSetLayerImage:self.view imageStr:kBG_CommonBG];
    
    RegisterView * registerView = [[RegisterView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64)];
    self.sendVerifyCodeBtn = registerView.sendVerifyCodeBtn;
    registerView.sendVerifyCodeBlock = ^(NSString * phoneNum){
        [self getMessageCodeRequest:phoneNum];
    };
    
    registerView.registerBlock = ^(NSDictionary * paramdic){
        [self registerRequest:paramdic ];
    };
    
    [self.view addSubview:registerView];
    
}

-(void)getMessageCodeRequest:(NSString *)phoneNum{
    self.sendVerifyCodeBtn.userInteractionEnabled = NO;
    NSDictionary* dataDic = @{@"phone":phoneNum};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDCode_Url arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        SZRLog(@"responseObject %@",responseObject);
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
                self.sendVerifyCodeBtn.userInteractionEnabled = NO;
                [MBProgressHUD showTextOnly:@"验证码正在发送中..."];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
                self.timeCount = 60;
            }else{
                SZRLog(@"error %@",error);
                [MBProgressHUD showTextOnly:responseObject[MESSAGE]];
                self.sendVerifyCodeBtn.userInteractionEnabled = YES;
            }
        }else{
            VD_SHowNetError(NO);
            self.sendVerifyCodeBtn.userInteractionEnabled = YES;
        }
    }];
    
}

-(void)registerRequest:(NSDictionary *)paramDic{
    [Request postRequest:LARegister parameters:paramDic success:^(id json) {
        [DEFAULTS setObject:paramDic[@"phone"] forKey:@"phone"];
        [DEFAULTS setObject:paramDic[@"password"] forKey:@"userPwd"];
        [DEFAULTS synchronize];
        ShowTextHUDCompletion(@"注册成功", self.view, ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    } failure:^(NSError *error) {}];
}

- (void)reduceTime{
    self.timeCount -- ;
    if (self.timeCount == 0) {
        [self.sendVerifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        self.sendVerifyCodeBtn.userInteractionEnabled = YES;
    }else{
        [self.sendVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%zds",self.timeCount] forState:UIControlStateNormal];
    }
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
