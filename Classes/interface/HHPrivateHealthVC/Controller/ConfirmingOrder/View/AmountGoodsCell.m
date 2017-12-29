//
//  AmountGoodsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AmountGoodsCell.h"

@implementation AmountGoodsCell
{
    UIView* _lastView;
    UILabel* _amountGoodsLa;
    UILabel* _pricrLa;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lastView = [UIView new];
        _lastView.backgroundColor = HEXCOLOR(0xefeff4);
        
        _amountGoodsLa = [UILabel new];
        _amountGoodsLa.text = @"商品金额";
        kLabelThinLightColor(_amountGoodsLa, kAdaptedWidth_2(30), HEXCOLOR(0x444444));

        _pricrLa = [UILabel new];
        _pricrLa.textAlignment = NSTextAlignmentRight;
        kLabelThinLightColor(_pricrLa, kAdaptedWidth_2(30), HEXCOLOR(0xff6666));
        
        [self.contentView sd_addSubviews:@[_lastView,_amountGoodsLa,_pricrLa]];
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .heightIs(kAdaptedHeight_2(26));
        
        _amountGoodsLa.sd_layout
        .leftSpaceToView(self.contentView,kAdaptedWidth_2(33))
        .topSpaceToView(_lastView,kAdaptedHeight_2(35.5))
        .widthIs(kAdaptedWidth_2(300))
        .heightIs(kAdaptedHeight_2(29));
        
        _pricrLa.sd_layout
        .rightSpaceToView(self.contentView,kAdaptedWidth_2(25))
        .topSpaceToView(_lastView,kAdaptedHeight_2(38))
        .widthIs(kAdaptedWidth_2(300))
        .heightIs(kAdaptedHeight_2(23));
        
    }
    return self;
}

- (void)setGoodsPrice:(CGFloat)goodsPrice{
    _goodsPrice = goodsPrice;
    _pricrLa.text = [NSString stringWithFormat:@"￥ %.2f",goodsPrice];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
