//
//  ConfirmOrderFooterView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ConfirmOrderFooterView.h"

@implementation ConfirmOrderFooterView
{
    UIView* _lastView;
    UILabel* _noteLa;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        _lastView = [UIView new];
        _lastView.backgroundColor = HEXCOLOR(0xefeff4);
       
        _noteLa = [UILabel new];
        kLabelThinLightColor(_noteLa, kAdaptedWidth_2(30), HEXCOLOR(0x444444));
        _noteLa.text = @"备注";

        [self sd_addSubviews:@[_lastView,_noteLa]];
        
        _lastView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(.8);
        
        _noteLa.sd_layout
        .leftSpaceToView(self,kAdaptedWidth_2(33))
        .topSpaceToView(_lastView,kAdaptedHeight_2(22))
        .widthIs(kAdaptedWidth_2(118))
        .heightIs(kAdaptedHeight_2(28));
        
        self.TF = [[LYTextView alloc] initWithFrame:CGRectMake(kAdaptedWidth_2(21), CGRectGetMaxY(_noteLa.frame)+22, SZRScreenWidth - kAdaptedWidth_2(21*2), kAdaptedHeight_2(196)) placeHolder:@"输入您的留言" maxNum:0];
        self.TF.leadingSpace = 5;
        self.TF.showPromptLab = NO;
        self.TF.hasBorder = NO;
        [self addSubview:self.TF];

    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
