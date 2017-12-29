

//
//  NewPassWordViewController.m
//  yingke
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "ModifyPassWordVC.h"
#import "HomeVC.h"
#import "HHLoginVC.h"
@interface ModifyPassWordVC ()
{
    UIView *_bgView;
    UIView *_rebgView;
    UITextField * _originalPass; //原始密码
    UITextField *_newPassward;  //设置的新密码
    UITextField *_rePassward; //重复密码
}
@end

@implementation ModifyPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"修改密码"}];
    [self createTextFields];
}


//设置新密码
- (void)createTextFields
{
    
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectMake(10, 5, SZRScreenWidth-90, 30) color:[UIColor grayColor] font:[UIFont systemFontOfSize:13] text:@"请设置新密码"];
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+5, SZRScreenWidth-20, 140)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 3.0;
    [self.view addSubview:_bgView];
    //原来密码
    _originalPass = [self createTextField:CGRectMake(20, 0, SZRScreenWidth-60, 40) leftLabelStr:@"当前密码:" placeHolder:@"请输入当前密码"];
    _originalPass.secureTextEntry = YES;
    _originalPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_originalPass];
    
    //第一条分界线
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, SZRScreenWidth-60, 1)];
    label1.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:label1];
    
    //新密码
    _newPassward = [self createTextField:CGRectMake(20, 50, SZRScreenWidth-60, 40) leftLabelStr:@"设置密码:" placeHolder:@"6-20位字母或数字"];
    _newPassward.secureTextEntry=YES;
    _newPassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_newPassward];
    
    //第二条分界线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, SZRScreenWidth- 60, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineLabel];
    
    //重复密码
    _rePassward = [self createTextField:CGRectMake(20, 100, SZRScreenWidth-60, 40) leftLabelStr:@"重复密码:" placeHolder:@"6-20位字母或数字"];
    _rePassward.secureTextEntry=YES;
    _rePassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_rePassward];
    
    //提交
    UIButton * landBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, CGRectGetMaxY(_bgView.frame)+30,SZRScreenWidth-20, 37) withTitle:@"提交" withImageStr:nil withBackImageStr:nil];
    landBtn.backgroundColor=SZRAPPCOLOR;
    landBtn.layer.cornerRadius=5.0f;
    [landBtn addTarget:self action:@selector(landClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];
}
//提交点击事件
- (void)landClick
{
    if ([_newPassward.text isEqualToString:_rePassward.text]) {
        
        if (![SZRFunction VD_CheckPassword:_originalPass.text]) {
            [MBProgressHUD showTextOnly:@"原始密码格式错误"];
        }else if (![SZRFunction VD_CheckPassword:_newPassward.text]){
            [MBProgressHUD showTextOnly:@"新设置密码格式错误"];
            
        }else{
            //修改密码请求
            [self modifyPwdRequest];
        }
    }else{
        [MBProgressHUD showTextOnly:@"两次密码设置不一致"];
    }
    
}
- (void)modifyPwdRequest{
    [MBProgressHUD showMessage:@"加载中..."];
    NSDictionary* dataDic = @{@"password":[MD5Encryption md5by32:_originalPass.text],@"newPassword":[MD5Encryption md5by32:_newPassward.text]};
    [VDNetRequest VD_PostWithURL:VDModifyPwd_Url arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:dataDic token:YES]}finish:^(NSURLSessionDataTask *task,id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:self];
                }
            }else{
                [MBProgressHUD hideHUD];
                VD_ShowBGBackError(YES);
                [VDUserTools TokenExpire:self];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    DDMenuController  * ddMenu = [DDMenuController shareDDMenuVC];
                    SZRTabBarVC * tabBarVC = (SZRTabBarVC *)ddMenu.rootViewController;
                    tabBarVC.selectedIndex = 0;
                });
            }
        }else{
            SZRLog(@"error %@",error);
            VD_SHowNetError(YES);
        }
    } noNetwork:^{
        VD_SHowNetError(YES);
    }];

}



- (void)leftBtnClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITextField *)createTextField:(CGRect)frame leftLabelStr:(NSString *)str placeHolder:(NSString *)placeHolder{
    
    UITextField * textField = [SZRFunction VDCreateTextFieldFrame:frame color:nil font:[UIFont systemFontOfSize:15] placeholder:placeHolder];
    _newPassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置密码
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, 65, 30) color:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:14] text:str];
    if (SYSTEMVERSION >= 10.0) {
        label.adjustsFontForContentSizeCategory = YES;
    }
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = label;
    return textField;
}



#pragma mark 点击的时候取消响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
