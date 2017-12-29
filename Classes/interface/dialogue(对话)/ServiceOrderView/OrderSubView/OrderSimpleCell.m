//
//  OrderSimpleCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderSimpleCell.h"

@implementation OrderSimpleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * contentView = self.contentView;
    
    _leftTitleLabel.sd_layout
    .leftSpaceToView(contentView,k6PAdaptedWidth(43/3))
    .heightIs(21)
    .widthIs(k6PAdaptedWidth(60))
    .centerYEqualToView(contentView);
    
    _contentLabel.sd_layout
    .leftSpaceToView(_leftTitleLabel,k6PAdaptedWidth(46/3))
    .rightSpaceToView(contentView,k6PAdaptedWidth(43/3))
    .heightIs(21)
    .centerYEqualToView(contentView);
   
    UIView * bottomLine = [SZRFunction createView:kSeperatrLine_Color];
    [contentView addSubview:bottomLine];
    bottomLine.sd_layout
    .leftEqualToView(_leftTitleLabel)
    .rightEqualToView(_contentLabel)
    .heightIs(1)
    .bottomEqualToView(contentView);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
