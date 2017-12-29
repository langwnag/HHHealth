//
//  SaleGoodsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SaleGoodsCell.h"

@implementation SaleGoodsCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    
    UIView* contentView = self.contentView;
    
    self.boderImageView = [UIImageView new];
    self.boderImageView.image = IMG(@"gray_boder");
    
    self.goodsImageView = [UIImageView new];
    
    self.desLa = [UILabel new];
    self.desLa.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(self.desLa, kAdaptedWidth(20/2), HEXCOLOR(0x333333));
    
    self.preferentialPriceLa = [UILabel new];
    kLabelThinLightColor(self.preferentialPriceLa, kAdaptedWidth(20/2), HEXCOLOR(0xff6666));
    
    self.originalPriceLa = [UILabel new];
    kLabelThinLightColor(self.originalPriceLa, kAdaptedWidth(14/2), HEXCOLOR(999999));
    [contentView sd_addSubviews:@[self.boderImageView,self.goodsImageView,self.desLa,self.preferentialPriceLa,self.originalPriceLa]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.boderImageView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .widthIs(kAdaptedWidth_2(220))
    .heightIs(kAdaptedHeight_2(300));

    
    self.goodsImageView.sd_layout
    .topEqualToView(self.boderImageView)
    .leftEqualToView(self.boderImageView)
    .widthIs(kAdaptedWidth_2(218))
    .heightIs(kAdaptedHeight_2(200));
 
    self.desLa.sd_layout
    .topSpaceToView(self.goodsImageView,kAdaptedHeight_2(26))
    .leftSpaceToView(self.contentView,kAdaptedWidth_2(10))
    .rightSpaceToView(self.contentView,kAdaptedWidth_2(10))
    .heightIs(kAdaptedHeight_2(21));

    self.preferentialPriceLa.sd_layout
    .topSpaceToView(self.desLa,kAdaptedHeight_2(9))
    .leftSpaceToView(self.contentView,kAdaptedWidth_2(25))
    .widthIs(kAdaptedWidth_2(100))
    .heightRatioToView(self.desLa,1);
    
    self.originalPriceLa.sd_layout
    .leftSpaceToView(self.preferentialPriceLa,kAdaptedWidth_2(6))
    .centerYEqualToView(self.preferentialPriceLa)
    .rightSpaceToView(self.contentView,kAdaptedWidth_2(25))
    .heightRatioToView(self.desLa,1);

}
-(void)setModel:(SaleGoodsModel *)model{
    _model = model;
    [VDNetRequest VD_OSSImageView:self.goodsImageView fullURLStr:model.pictureUrl placeHolderrImage:kDefaultLoading];
    self.desLa.text = model.name;
    self.preferentialPriceLa.text = [NSString stringWithFormat:@"￥%.2lf", model.discountPrice];
    self.originalPriceLa.text = [NSString stringWithFormat:@"￥%.2lf", model.basicPrice];

}

@end
