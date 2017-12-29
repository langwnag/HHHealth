//
//  ServiceAmountView.m
//  HeheHealthManager
//
//  Created by mac on 2017/5/22.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "ServiceAmountView.h"

@implementation ServiceAmountView
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    self.serviceAmountLa.font = kLightFont(k6PAdaptedWidth(14));

    
    self.serviceAmountLa.sd_layout
    .leftSpaceToView(self,k6PAdaptedWidth(82.0/3))
    .widthIs(k6PAdaptedWidth(175.0/3))
    .topSpaceToView(self,k6PAdaptedHeight(10))
    .heightIs(k6PAdaptedHeight(55.0/3));
    
//    self.contentLabel.sd_layout
//    .leftSpaceToView(_titleLabel,k6PAdaptedWidth(12))
//    .rightSpaceToView(contentView,k6PAdaptedWidth(82.0/3))
//    .heightIs(k6P_3AdaptedHeight(81))
//    .centerYEqualToView(contentView);
//    

    self.moneyLa.sd_layout
    .leftSpaceToView(self.serviceAmountLa,k6PAdaptedWidth(12))
    .widthIs(kAdaptedWidth(30))
    .topEqualToView(self.serviceAmountLa)
    .heightIs(k6PAdaptedHeight(20));
    

    self.pricesPromptLa.sd_layout
    .leftSpaceToView(self.moneyLa,k6PAdaptedWidth(5))
    .widthIs(k6PAdaptedWidth(220))
    .topEqualToView(self.serviceAmountLa)
    .heightRatioToView(self.serviceAmountLa,1);
    
    
    self.lineView.sd_layout
    .leftSpaceToView(self,k6PAdaptedWidth(20))
    .rightSpaceToView(self,k6PAdaptedWidth(20))
    .topSpaceToView(self.moneyLa,k6PAdaptedHeight(25))
    .heightIs(k6PAdaptedHeight(.8));
    

    self.sureServiceBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.lineView,k6PAdaptedHeight(20))
    .widthIs(kAdaptedWidth(200))
    .heightIs(k6PAdaptedHeight(40));

    self.sureServiceBtn.sd_cornerRadius = @(k6P_3AdaptedHeight(15));
 
    
}

- (IBAction)sureServiceBtn:(UIButton *)sender {
    if (self.serviceBtnBlock) {
        self.serviceBtnBlock([self.priceTF.text doubleValue]);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/


@end
