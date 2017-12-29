//
//  PayFooterView.m
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayFooterView.h"

@implementation PayFooterView
- (void)dealloc{

}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.immediatePaymentPriceBtn.sd_cornerRadius=@(kAdaptedWidth(5));
    
    self.immediatePaymentPriceBtn.sd_layout
    .leftSpaceToView(self,kAdaptedWidth_2(117.5))
    .centerYEqualToView(self)
    .widthIs(kAdaptedWidth(260))
    .heightIs(kAdaptedWidth_2(85));
    
    [self addSubview:self.immediatePaymentPriceBtn];
}
- (IBAction)payBtnClick:(UIButton *)sender {
    if (self.payBtnClick) {
        self.payBtnClick();
    }

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

@end
