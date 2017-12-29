//
//  OrderFooterView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIButton * payBtn = [UIButton new];
    [self addSubview:payBtn];
    payBtn.sd_layout
    .topSpaceToView(self,k6PAdaptedHeight(94/3))
    .centerXEqualToView(self)
    .heightIs(k6PAdaptedHeight(115/3))
    .widthIs(k6PAdaptedWidth(734/3));
    payBtn.sd_cornerRadius = @5;
    payBtn.backgroundColor = kWord_BrightPink_COLOR;
    [payBtn setTitle:@"提交并支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)payBtnClick{
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

@end
