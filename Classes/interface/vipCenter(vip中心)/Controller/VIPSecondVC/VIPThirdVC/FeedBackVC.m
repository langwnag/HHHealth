//
//  FeedBackVC.m
//  客邦
//
//  Created by SZR on 16/4/7.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "FeedBackVC.h"
#import "SZRTextview.h"


@interface FeedBackVC ()<UITextViewDelegate,UITextFieldDelegate>
//反馈意见
@property(nonatomic,strong)UITextView * textView;
//手机号
@property(nonatomic,strong)UITextField * phoneTF;
//QQ号
@property(nonatomic,strong)UITextField * QQNumTF;
//邮件
@property(nonatomic,strong)UITextField * emailTF;



@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}
//创建视图
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"意见反馈"}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建电话号textField
    self.phoneTF = [self createTextField:CGRectMake(10, 10, SZRScreenWidth-20, 45) placeHoder:@"手机号码:"];
    [self.view addSubview:self.phoneTF];
    
    //创建QQ号TF
    self.QQNumTF = [self createTextField:CGRectMake(10, CGRectGetMaxY(self.phoneTF.frame)+5, SZRScreenWidth-20, 45) placeHoder:@"QQ号(必填):"];
    [self.view addSubview:self.QQNumTF];
    
    //创建邮箱TF
    self.emailTF = [self createTextField:CGRectMake(10, CGRectGetMaxY(self.QQNumTF.frame)+5, SZRScreenWidth-20, 45) placeHoder:@"邮箱:"];
    [self.view addSubview:self.emailTF];
    
    SZRTextview * szrTextView = [[SZRTextview alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.emailTF.frame)+5, SZRScreenWidth-20, 80)];
    [szrTextView configWithText:nil PlaceHolder:@"请输入您的宝贵意见:" maxNum:200];
    [szrTextView resetTextViewBGColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:szrTextView];
    self.textView = szrTextView.textView;
    
    
    //提交btn
    UIButton * submitBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, CGRectGetMaxY(self.textView.superview.frame) + 30, SZRScreenWidth-20, 30) withTitle:@"提交" withImageStr:nil withBackImageStr:nil];
    submitBtn.backgroundColor = SZRAPPCOLOR;
    submitBtn.layer.cornerRadius = 5.0f;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}



#pragma mark 点击提交按钮响应事件
-(void)submitBtnClick:(UIButton *)btn{
    if (self.textView.text.length > 0) {
        //QQ号必填
        if (![SZRFunction VD_CheckQQNum:self.QQNumTF.text]) {
            [MBProgressHUD showTextOnly:@"QQ号码格式错误!"];
            return;
        }
        
        if (self.phoneTF.text.length != 0 && ![SZRFunction VD_CheckPhoneNum:self.phoneTF.text]) {
            [MBProgressHUD showTextOnly:@"手机号码格式错误!"];
            return;
        }
        
        if (self.emailTF.text.length != 0 && ![SZRFunction VD_CheckEmail:self.emailTF.text]) {
            [MBProgressHUD showTextOnly:@"邮箱格式错误!"];
            return;
        }
    
        //写入了内容，进行网络请求 返回界面
//        [self feedBackRequest];

        
    }else{
        [MBProgressHUD showTextOnly:@"请填写反馈意见"];
    }
    
}


-(UITextField *)createTextField:(CGRect)frame placeHoder:(NSString *)placeHoder{
    UITextField * textField = [SZRFunction VDCreateTextFieldFrame:frame color:nil font:[UIFont systemFontOfSize:15] placeholder:placeHoder ];
    textField.delegate = self;
    textField.background = [UIImage imageNamed:@"textfield"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

#pragma mark textField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.background = [UIImage imageNamed:@"textfield_hl"];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.background = [UIImage imageNamed:@"textfield"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
