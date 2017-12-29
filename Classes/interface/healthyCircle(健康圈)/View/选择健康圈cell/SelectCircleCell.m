//
//  SelectCircleCell.m
//  YiJiaYi
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelectCircleCell.h"

@implementation SelectCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftLa.font = kLightFont(kFontAdaptedWidth(26/2));
    
    UIView* contentView = self.contentView;

    self.leftLa.sd_layout
    .leftSpaceToView(contentView,kAdaptedWidth_2(20))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth(120))
    .heightIs(kAdaptedHeight(21));

    self.selectBtn.sd_layout
    .rightSpaceToView(contentView,kAdaptedWidth_2(20))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth_2(24))
    .heightIs(kAdaptedHeight_2(18));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
