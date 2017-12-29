//
//  OrderListCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell
{
    UIView* _lastView;
    UILabel* _desLa;
    UILabel* _priceLa;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _lastView = [UIView new];
        _lastView.backgroundColor = HEXCOLOR(0xefeff4);
        
        self.imgUrl = [UIImageView new];
        
        _desLa = [UILabel new];
        kLabelThinLightColor(_desLa, kAdaptedWidth_2(24), HEXCOLOR(0x444444));
        
        _priceLa = [UILabel new];
        kLabelThinLightColor(_priceLa, kAdaptedWidth_2(30), HEXCOLOR(0xff6666));
        
        [self.contentView sd_addSubviews:@[_lastView,self.imgUrl,_desLa,_priceLa]];
        
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .heightIs(kAdaptedHeight_2(26));
        
        _imgUrl.sd_layout
        .leftSpaceToView(self.contentView,kAdaptedWidth_2(36))
        .topSpaceToView(_lastView,kAdaptedHeight_2(45))
        .widthIs(kAdaptedWidth_2(301))
        .heightIs(kAdaptedHeight_2(119));
        
        _desLa.sd_layout
        .leftSpaceToView(self.imgUrl,kAdaptedWidth_2(39))
        .topSpaceToView(_lastView,kAdaptedHeight_2(73))
        .rightSpaceToView(self.contentView,kAdaptedWidth_2(197))
        .heightIs(kAdaptedHeight_2(24));
        
        _priceLa.sd_layout
        .leftEqualToView(_desLa)
        .topSpaceToView(_desLa,kAdaptedHeight_2(18))
        .rightSpaceToView(self.contentView,kAdaptedWidth_2(197))
        .heightIs(21);
        
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _desLa.text = titleStr;
}
- (void)setPriceStr:(NSString *)priceStr{
    _priceStr = priceStr;
    _priceLa.text = priceStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
