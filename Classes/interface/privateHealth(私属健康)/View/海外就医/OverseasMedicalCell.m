//
//  OverseasMedicalCell.m
//  YiJiaYi
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OverseasMedicalCell.h"

@implementation OverseasMedicalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLa.userInteractionEnabled = YES;
    self.typeLa.textColor = [UIColor lightGrayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapClick:)];
    [self.typeLa addGestureRecognizer:tap];
}
- (void)labelTapClick:(UITapGestureRecognizer* )tap{
    if (self.labelTapBlock) {
        self.labelTapBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
