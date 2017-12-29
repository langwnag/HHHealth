//
//  HealthDiaryCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HealthDiaryCell.h"

@implementation HealthDiaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.healthLa.textColor = HEXCOLOR(0xfffaba);
    self.dataLa.textColor = HEXCOLOR(0xfffaba);
    self.bottomV.backgroundColor = HEXCOLOR(0x125765);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
