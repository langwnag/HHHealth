//
//  OrderThirdCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderThirdCell.h"
#import "ServiceOrderModel.h"
@implementation OrderThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * contentView = self.contentView;
    
    _leftTitleLabel.sd_layout
    .leftSpaceToView(contentView,k6PAdaptedWidth(43/3))
    .heightIs(21)
    .widthIs(k6PAdaptedWidth(60))
    .centerYEqualToView(contentView);
    
    _contentLabel.sd_layout
    .rightSpaceToView(contentView,k6PAdaptedWidth(43/3))
    .heightIs(21)
    .centerYEqualToView(contentView);
    [_contentLabel setSingleLineAutoResizeWithMaxWidth:SZRScreenWidth/1.5];
    
    UIView * bottomLine = [SZRFunction createView:kSeperatrLine_Color];
    [contentView addSubview:bottomLine];
    bottomLine.sd_layout
    .leftEqualToView(_leftTitleLabel)
    .rightEqualToView(_contentLabel)
    .heightIs(1)
    .bottomEqualToView(contentView);
}

-(void)loadData:(ServiceOrderModel *)model indexPathRow:(NSUInteger)indexPathRow{
    
    switch (indexPathRow) {
        case 5:
        {
          _contentLabel.text = [NSString stringWithFormat:@"￥%.2lf",model.servicePrice];
        }
            
            break;
        case 6:
        {
            _leftTitleLabel.text = @"优惠券";
            _contentLabel.font = [UIFont systemFontOfSize:13];
            _contentLabel.textColor = HEXCOLOR(0x05cfaa);
            _contentLabel.text = model.coupon;
        }
            break;
        case 7:
        {
            _leftTitleLabel.text = @"还需支付";
            _contentLabel.font = [UIFont boldSystemFontOfSize:k6PAdaptedWidth(23)];
            _contentLabel.text = [NSString stringWithFormat:@"￥%.2lf", model.otherNeedPay];
        }
            
            break;
        default:
            break;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
