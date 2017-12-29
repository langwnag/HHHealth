//
//  ConfirmOrderHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ConfirmOrderHeaderView.h"

@implementation ConfirmOrderHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* iconImg = [UIImageView new];
        iconImg.image = IMG(@"shouhuodizhi_icon");
        
        UILabel* desLa = [UILabel new];
        desLa.text = @"请添加收货地址";
        kLabelThinLightColor(desLa, kAdaptedWidth_2(24), HEXCOLOR(0x666666));
        
        [self sd_addSubviews:@[iconImg,desLa]];
    
        iconImg.sd_layout
        .leftSpaceToView(self,kAdaptedWidth_2(278))
        .topSpaceToView(self,kAdaptedHeight_2(89))
        .widthIs(kAdaptedWidth_2(27))
        .heightEqualToWidth();
        
        desLa.sd_layout
        .leftSpaceToView(iconImg,kAdaptedWidth_2(10))
        .topEqualToView(iconImg)
        .rightSpaceToView(self,kAdaptedWidth_2(100))
        .heightIs(kAdaptedHeight_2(24));
        
        
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
