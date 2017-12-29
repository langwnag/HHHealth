//
//  OrderHeaderView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIImageView * leftImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReceiveOrder_RedHeart"]];
    UILabel * orderLabel = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_3 font:[UIFont boldSystemFontOfSize:k6PAdaptedWidth(55/3)] text:@"服务订单"];
    UIView * lineView = [UIView new];
    lineView.backgroundColor = kSeperatrLine_Color;
    [self sd_addSubviews:@[leftImageV,orderLabel,lineView]];
    
    leftImageV.sd_layout
    .leftSpaceToView(self,k6PAdaptedWidth(375.0/3))
    .topSpaceToView(self,k6PAdaptedHeight(53.0/3))
    .widthIs(k6PAdaptedWidth(93/3))
    .heightIs(76/3);
    
    orderLabel.sd_layout
    .leftSpaceToView(leftImageV,k6PAdaptedWidth(26/3))
    .topEqualToView(leftImageV)
    .rightEqualToView(self)
    .heightRatioToView(leftImageV,1);
    
    lineView.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self,k6PAdaptedWidth(43/3))
    .rightSpaceToView(self,k6PAdaptedWidth(43/3))
    .heightIs(1);
    
}




@end
