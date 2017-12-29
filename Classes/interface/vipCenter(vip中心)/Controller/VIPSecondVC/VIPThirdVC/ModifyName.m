//
//  ModifyName.m
//  客邦
//
//  Created by SZR on 16/4/8.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "ModifyName.h"
#import "RCDataBaseManager.h"
@interface ModifyName ()

//昵称
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,strong)UITextField * textFiled;

@end

@implementation ModifyName

-(instancetype)initWithNickName:(NSString *)nickName{
    if (self = [super init]) {
        self.nickName = nickName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"修改昵称"}];
    //创建UI
    [self createUI];
}
-(void)createUI{
    
    self.textFiled = [SZRFunction VDCreateTextFieldFrame:CGRectMake(10, 20, SZRScreenWidth-20, 40) color:[UIColor blackColor] font:[UIFont systemFontOfSize:13] placeholder:@"请输入昵称"];
    //左边占位view
    self.textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    //右边清除按钮
    self.textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFiled.clearsOnBeginEditing = YES;
    
    self.textFiled.text = self.nickName;
    self.textFiled.layer.borderColor = SZRAPPCOLOR.CGColor;
    self.textFiled.layer.borderWidth = 1.0f;
    self.textFiled.layer.cornerRadius = 5.0f;
    self.textFiled.layer.masksToBounds = YES;
    
    [self.view addSubview:self.textFiled];
    
    //创建提示label
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.textFiled.frame)+5, SZRScreenWidth - 20, 15) color:[UIColor grayColor] font:[UIFont systemFontOfSize:12] text:@"2-16字符，可由中英文、数字、“_”组成"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    //创建保存btn
    UIButton * saveBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+30, SZRScreenWidth-20, 40) withTitle:@"保存" withImageStr:nil withBackImageStr:nil];
    saveBtn.backgroundColor = SZRAPPCOLOR;
    saveBtn.layer.cornerRadius = 5.0f;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)even
{
    [self.view endEditing:YES];
}

-(void)saveBtnClick
{
   
    if (![SZRFunction VD_CheckNickName:self.textFiled.text]) {
        
        [MBProgressHUD showTextOnly:@"昵称格式不对"];
       
    }else{
        if ([self.textFiled.text isEqualToString:self.nickName]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self modifyNameRequest];
        }
    }
    
}

-(void)modifyNameRequest{
    
    [VDNetRequest HH_UpdateNickNameRequest:@{@"nickname":self.textFiled.text} success:^(NSDictionary *dic) {
        [DEFAULTS setObject:self.textFiled.text forKey:CLIENTNAME];
        RCUserInfo * userInfo = [RCIM sharedRCIM].currentUserInfo;
        userInfo.name = self.textFiled.text;
        [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userInfo.userId];
        [[RCDataBaseManager shareInstance]insertUserToDB:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateUserInfoNofiName object:self];
        if (self.returnTextBlock) {
            self.returnTextBlock(self.textFiled.text);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } viewController:self];
}



-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
