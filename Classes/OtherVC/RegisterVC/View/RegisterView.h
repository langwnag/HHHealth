//
//  RegisterView.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendVerifyCodeBlock)(NSString *);
typedef void(^GetInviteCodeBlcok)(void);
typedef void(^RegisterBlock)(NSDictionary *);


@interface RegisterView : UIView

@property(nonatomic,strong)UITextField * phoneNumTF;
@property(nonatomic,strong)UITextField * verifyCodeTF;
@property(nonatomic,strong)UITextField * passwordTF;

@property(nonatomic,strong)UIButton * sendVerifyCodeBtn;

@property(nonatomic,strong)UITextField * vipInviteCodeTF;

@property(nonatomic,copy)SendVerifyCodeBlock sendVerifyCodeBlock;
@property(nonatomic,copy)GetInviteCodeBlcok getInviteCodeBlcok;
@property(nonatomic,copy)RegisterBlock registerBlock;

@end
