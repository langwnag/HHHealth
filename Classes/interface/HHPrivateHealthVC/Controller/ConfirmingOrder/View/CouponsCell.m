//
//  CouponsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CouponsCell.h"

@implementation CouponsCell
{
    UIView* _lastView;
    UILabel* _couponsLa;
    UILabel* _priceCouponsLa;
    UIImageView* _rightImg;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _lastView = [UIView new];
        _lastView.backgroundColor = HEXCOLOR(0xefeff4);
        
        _couponsLa = [UILabel new];
        _couponsLa.text = @"优惠券";
        kLabelThinLightColor(_couponsLa, kAdaptedWidth_2(30), HEXCOLOR(0x444444));
        
        _priceCouponsLa = [UILabel new];
        _priceCouponsLa.textAlignment = NSTextAlignmentRight;
        kLabelThinLightColor(_priceCouponsLa, kAdaptedWidth_2(32), HEXCOLOR(0x05cfaa));
        
        _rightImg = [UIImageView new];
        _rightImg.image = IMG(@"grayArrow");
        
        
        [self.contentView sd_addSubviews:@[_lastView,_couponsLa,_priceCouponsLa,_rightImg]];
        
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .heightIs(.8);

        _couponsLa.sd_layout
        .leftSpaceToView(self.contentView,kAdaptedWidth_2(32))
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(136))
        .heightIs(kAdaptedHeight_2(30));
        
        _rightImg.sd_layout
        .rightSpaceToView(self.contentView,kAdaptedWidth_2(27))
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(15))
        .heightIs(kAdaptedHeight_2(24));
        
        _priceCouponsLa.sd_layout
        .rightSpaceToView(_rightImg,kAdaptedWidth_2(15))
        .widthIs(200)
        .centerYEqualToView(self.contentView)
        .heightIs(kAdaptedHeight_2(35));
        
        }
    return self;
}

- (void)setCouponsPrice:(CGFloat)couponsPrice{
    _couponsPrice = couponsPrice;
    _priceCouponsLa.text = [NSString stringWithFormat:@"合合通用券%lf元",couponsPrice];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
