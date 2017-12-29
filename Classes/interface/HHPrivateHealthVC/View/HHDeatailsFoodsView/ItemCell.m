//
//  ItemCell.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.iconImg = [UIImageView new];
    self.desLa = [UILabel new];
    kLabelThinLightColor(self.desLa, kAdaptedWidth_2(21),[UIColor blackColor]);
    self.desLa.textAlignment = NSTextAlignmentCenter;
    [self.contentView sd_addSubviews:@[self.iconImg,self.desLa]];
}
- (void)layoutSubviews{
    [super layoutSubviews];

    self.iconImg.sd_layout
    .topSpaceToView(self.contentView,10)
    .centerXEqualToView(self.contentView)
    .heightIs(kAdaptedWidth_2(30))
    .widthEqualToHeight(YES);
    
    self.desLa.sd_layout
    .topSpaceToView(self.iconImg,-2)
    .heightIs(kAdaptedWidth(21))
    .centerXEqualToView(self.contentView)
    .widthIs(120);
}

@end
