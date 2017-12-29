//
//  OrderSecondCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderSecondCell.h"

@implementation OrderSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * contenView = self.contentView;
    
    _linkeManLabel.sd_layout
    .leftSpaceToView(contenView,k6PAdaptedWidth(43/3))
    .heightIs(21)
    .centerYEqualToView(contenView)
    .widthIs(k6PAdaptedWidth(60));
    
    _linkMan.sd_layout
    .leftSpaceToView(_linkeManLabel,k6PAdaptedWidth(46/3))
    .heightIs(21)
    .centerYEqualToView(contenView);
    
    [_linkMan setSingleLineAutoResizeWithMaxWidth:k6PAdaptedWidth(105)];
    
    _phoneLabel.sd_layout
    .centerXEqualToView(contenView).offset(k6PAdaptedWidth(20))
    .widthIs(k6PAdaptedWidth(50))
    .heightIs(21)
    .centerYEqualToView(contenView);
    
    _phone.sd_layout
    .leftSpaceToView(_phoneLabel,k6PAdaptedWidth(46/3))
    .heightIs(21)
    .rightSpaceToView(contenView,k6PAdaptedWidth(43/3))
    .centerYEqualToView(contenView);
    
    UIView * bottomLine = [SZRFunction createView:kSeperatrLine_Color];
    [contenView addSubview:bottomLine];
    bottomLine.sd_layout
    .leftEqualToView(_linkeManLabel)
    .rightEqualToView(_phone)
    .heightIs(1)
    .bottomEqualToView(contenView);
    
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
