//
//  ConfirmOrderBottomView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ConfirmOrderBottomView.h"

@implementation ConfirmOrderBottomView
{
    UIView* _bottomV;
    UILabel* _priceLa;
    UIButton* _commitBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        _bottomV = [UIView new];
        [self addSubview:_bottomV];
        
        _priceLa = [UILabel new];
        kLabelThinLightColor(_priceLa, kAdaptedWidth_2(36), HEXCOLOR(0xff6666));
        [_bottomV addSubview:_priceLa];
        
        _commitBtn = [UIButton new];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:kAdaptedWidth_2(30)];
        _commitBtn.backgroundColor = HEXCOLOR(0xff6666);
        _commitBtn.sd_cornerRadiusFromHeightRatio = @0.2;
        [_commitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomV addSubview:_commitBtn];
        
        _bottomV.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(kAdaptedHeight_2(120))
        .bottomEqualToView(self);
        
        _priceLa.sd_layout
        .leftSpaceToView(_bottomV,kAdaptedWidth_2(24))
        .centerYEqualToView(_bottomV)
        .widthIs(kAdaptedWidth_2(300))
        .heightIs(kAdaptedHeight_2(33));
        
        _commitBtn.sd_layout
        .rightSpaceToView(_bottomV,kAdaptedWidth_2(24))
        .centerYEqualToView(_bottomV)
        .widthIs(kAdaptedWidth_2(273))
        .heightIs(kAdaptedHeight_2(80));
    
    }
    return self;
}


- (void)setPrice:(CGFloat)price{
    _price = price;
    _priceLa.text = [NSString stringWithFormat:@"支付：%.2f",price];
}

- (void)commitBtn:(UIButton* )commitbtn{
    !self.commitBtnBlock ? : self.commitBtnBlock();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
