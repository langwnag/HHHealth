//
//  PayGoldCoinsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/2/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayGoldCoinsCell.h"
@interface PayGoldCoinsCell()


@end
@implementation PayGoldCoinsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.amountBtn.layer.cornerRadius = 10.0f;
    self.amountBtn.layer.masksToBounds = YES;
    self.amountBtn.layer.borderWidth = 1.0f;
    self.amountBtn.layer.borderColor = RGBCOLOR(53, 162, 157).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    _selectBtn.selected = !selected;
}


@end
