//
//  CustomerCircleCell.m
//  YiJiaYi
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CustomerCircleCell.h"

@implementation CustomerCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* contentView = self.contentView;
   
    UIImageView* iconImage = self.icon;
    iconImage.sd_layout
    .leftSpaceToView(contentView,kAdaptedWidth_2(21))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth_2(25))
    .heightEqualToWidth(YES);

    UILabel* desLa = self.desLa;
    desLa.font = [UIFont systemFontOfSize:kFontAdaptedWidth(16)];
    desLa.sd_layout
    .leftSpaceToView(iconImage,kAdaptedWidth_2(17))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth(90))
    .heightIs(kAdaptedHeight(21));
    
    
    UIImageView* rightImageV = self.rightIcon;
    rightImageV.sd_layout
    .rightSpaceToView(contentView,kAdaptedWidth_2(20))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth_2(15))
    .heightIs(kAdaptedHeight_2(24));
    
    UILabel* diseasela = self.DiseaseDesLa;
    diseasela.font = [UIFont systemFontOfSize:kFontAdaptedWidth(14)];
    diseasela.sd_layout
    .rightSpaceToView(rightImageV,kAdaptedWidth_2(24))
    .leftSpaceToView(desLa,kAdaptedWidth(20))
    .centerYEqualToView(contentView)
    .heightRatioToView(desLa,kAdaptedHeight(21));

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
