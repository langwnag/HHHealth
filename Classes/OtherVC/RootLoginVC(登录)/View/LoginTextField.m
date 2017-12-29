//
//  LoginTextField.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

-(NSArray *)imageVWithTFSequence:(NSUInteger)TFSequence LeftImageV:(NSString *)leftImageStr placeHolder:(NSString *)placeHolder{
    UIImageView * outsideImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_TF_BG"]];
    outsideImageV.userInteractionEnabled = YES;
    
    UIImageView * leftImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:leftImageStr]];
    UIView * lineView = [SZRFunction createView:[UIColor whiteColor]];
    
    UITextField * texfField = [SZRFunction VDCreateTextFieldFrame:CGRectNull color:[UIColor whiteColor] font:[UIFont systemFontOfSize:kAdaptedWidth(13)] placeholder:@""];
    texfField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    texfField.tintColor = [UIColor whiteColor];
    texfField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [outsideImageV sd_addSubviews:@[leftImageV,lineView,texfField]];
    
    leftImageV.sd_layout
    .topSpaceToView(outsideImageV,kAdaptedHeight(33.0/2))
    .leftSpaceToView(outsideImageV,kAdaptedWidth(40/2))
    .widthIs(kAdaptedWidth(23/2))
    .heightIs(kAdaptedHeight(27/2));
    
    lineView.sd_layout
    .topEqualToView(leftImageV)
    .leftSpaceToView(leftImageV,kAdaptedWidth(8))
    .widthIs(1)
    .heightRatioToView(leftImageV,1);
    
    texfField.sd_layout
    .centerYEqualToView(outsideImageV)
    .heightRatioToView(leftImageV,3)
    .leftSpaceToView(lineView,kAdaptedWidth(6))
    .rightSpaceToView(outsideImageV,TFSequence == 1 ? kAdaptedWidth(10) : kAdaptedWidth(130/2 + 8));
    
    if (TFSequence == 2) {
        UIButton * forgetPasswordBtn = [UIButton new];
        [forgetPasswordBtn setImage:[UIImage imageNamed:@"Login_Btn_ForgetPassword"] forState:UIControlStateNormal];
        [forgetPasswordBtn addTarget:self action:@selector(forgetPasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [outsideImageV addSubview:forgetPasswordBtn];
        
        forgetPasswordBtn.sd_layout
        .rightSpaceToView(outsideImageV,kAdaptedHeight(8))
        .heightIs(kAdaptedHeight(51/2))
        .widthIs(kAdaptedWidth(130/2))
        .centerYEqualToView(outsideImageV);
    }

    return @[outsideImageV,texfField];
}


-(void)forgetPasswordBtnClick{
    if (self.forgetPasswordBtnBlock) {
        self.forgetPasswordBtnBlock();
    }
}

@end
