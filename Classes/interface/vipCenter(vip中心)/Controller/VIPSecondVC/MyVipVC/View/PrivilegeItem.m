//
//  SubGrigCell.m
//  客邦
//
//  Created by SZR on 2016/12/7.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "PrivilegeItem.h"

@implementation PrivilegeItem

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.imageV = [UIImageView new];
    [self.contentView addSubview:self.imageV];
    self.label = [UILabel new];
    self.label.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(self.label, kAdaptedWidth(11), kWord_Gray_6);
    [self.contentView addSubview:self.label];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageV.sd_layout
    .topEqualToView(self.contentView)
    .centerXEqualToView(self.contentView)
    .heightIs(kAdaptedWidth(40))
    .widthEqualToHeight(YES);
   
    self.label.sd_layout
    .bottomEqualToView(self.contentView)
    .heightIs(kAdaptedWidth(21))
    .centerXEqualToView(self.contentView)
    .widthRatioToView(self.contentView,1);
    
}

@end
