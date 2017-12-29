//
//  AgreementView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AgreementView.h"

@implementation AgreementView

-(instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIView * leftLine = [SZRFunction createView:HEXCOLOR(0x144f61)];
    UILabel * agreementLabel = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor whiteColor] font:[UIFont systemFontOfSize:kAdaptedHeight(11)] text:@"" ];
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    agreementLabel.isAttributedContent = YES;
    agreementLabel.attributedText = [self labelAttri];
    
    UIView * rightLine = [SZRFunction createView:HEXCOLOR(0x144f61)];
    
    [self sd_addSubviews:@[leftLine,agreementLabel,rightLine]];
    
    leftLine.sd_layout
    .leftEqualToView(self)
    .widthIs(kAdaptedWidth(300/2))
    .heightIs(1)
    .centerYEqualToView(self);
    
    rightLine.sd_layout
    .rightEqualToView(self)
    .widthRatioToView(leftLine,1)
    .heightIs(1)
    .centerYEqualToView(self);
    
    agreementLabel.sd_layout
    .centerYEqualToView(self)
    .heightIs(kAdaptedWidth(12))
    .leftSpaceToView(leftLine,kAdaptedWidth(2))
    .rightSpaceToView(rightLine,kAdaptedWidth(2));
    
  
}

-(NSAttributedString *)labelAttri{
    NSMutableAttributedString * mattri = [[NSMutableAttributedString alloc]initWithString:@"会员协议"];
    NSTextAttachment * attch = [[NSTextAttachment alloc]init];
    attch.image = [UIImage imageNamed:@"Login_Protocol_Bulb"];
    attch.bounds = CGRectMake(0, 0, kAdaptedWidth(12), kAdaptedWidth(12));
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    [mattri insertAttributedString:imageStr atIndex:0];
    return mattri;
}


@end
