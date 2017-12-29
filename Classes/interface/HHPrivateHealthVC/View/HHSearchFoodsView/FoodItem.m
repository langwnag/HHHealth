//
//  FoodItem.m
//  YiJiaYi
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FoodItem.h"

@implementation FoodItem
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.contentView.layer.cornerRadius = 10.f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    self.foodLa = [UILabel new];
    self.foodLa.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(self.foodLa, kAdaptedWidth(12), [UIColor orangeColor]);
    [self.contentView addSubview:self.foodLa];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.foodLa.sd_layout
    .leftSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    .heightIs(25)
    .centerYEqualToView(self.contentView);
    
}
//-(void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
// 
//    self.foodLa.textColor = selected ? [UIColor whiteColor] : [UIColor orangeColor];
//    self.backgroundColor = selected ? [UIColor orangeColor] : [UIColor whiteColor];
//}


@end
