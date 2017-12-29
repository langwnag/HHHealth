//
//  OtherNeedFooterView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OtherNeedFooterView.h"
#import "SZRTextview.h"
@implementation OtherNeedFooterView


- (void)drawRect:(CGRect)rect {
    
    UILabel * otherNeedLabel = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_4 font:kLightFont(k6PFontAdaptedWidth(14)) text:@"其他需求"];
    otherNeedLabel.textAlignment = NSTextAlignmentRight;
    
    SZRTextview * otherNeedTextView = [[SZRTextview alloc]initWithText:@"" PlaceHolder:@"" maxNum:100];
    [otherNeedTextView resetTextViewBGColor:kBG_LightGray_Color];
    self.otherNeedTextView = otherNeedTextView;
    
    UIView * lineView = [SZRFunction createView:kBG_LightGray_Color];
    
    UIButton * sendServiceBtn = [SZRFunction createBtn:@"发起服务" titleColor:[UIColor whiteColor] titleFont:kLightFont(k6PAdaptedWidth(16))];
    sendServiceBtn.backgroundColor = kWord_BrightPink_COLOR;
    [sendServiceBtn addTarget:self action:@selector(sendServiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sendServiceBtn = sendServiceBtn;
    
    [self sd_addSubviews:@[otherNeedLabel,otherNeedTextView,lineView,sendServiceBtn]];
    
    UIView * contentView = self;
    
    otherNeedLabel.sd_layout
    .leftSpaceToView(contentView,k6PAdaptedWidth(82.0/3))
    .widthIs(k6PAdaptedWidth(175.0/3))
    .topSpaceToView(contentView,k6P_3AdaptedHeight(28))
    .heightIs(k6PAdaptedHeight(55.0/3));
    
    otherNeedTextView.sd_layout
    .leftSpaceToView(otherNeedLabel,k6P_3AdaptedWidth(24))
    .topEqualToView(otherNeedLabel)
    .rightSpaceToView(contentView,k6P_3AdaptedWidth(83))
    .heightIs(k6P_3AdaptedHeight(300));
    
    lineView.sd_layout
    .leftEqualToView(otherNeedLabel)
    .rightEqualToView(otherNeedTextView)
    .heightIs(1)
    .topSpaceToView(otherNeedTextView,k6P_3AdaptedHeight(84));
    
    sendServiceBtn.sd_layout
    .topSpaceToView(lineView,k6P_3AdaptedHeight(69))
    .leftSpaceToView(contentView,k6P_3AdaptedWidth(243))
    .rightSpaceToView(contentView,k6P_3AdaptedWidth(243))
    .heightIs(k6P_3AdaptedHeight(102));
    
    sendServiceBtn.sd_cornerRadius = @(k6P_3AdaptedHeight(8));
    
}

-(void)sendServiceBtnClick:(UIButton *)btn{
    if (self.sendServiceBlock) {
        self.sendServiceBlock();
    }
}



@end
