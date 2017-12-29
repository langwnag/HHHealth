//
//  PersonalData.m
//  YiJiaYi
//
//  Created by mac on 2017/3/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PersonalDataCell.h"

@implementation PersonalDataCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.keyLabel.textColor = HEXCOLOR(0x05cfaa);
    self.valueLabel.textColor = HEXCOLOR(0xfffaba);
    self.dividerV.backgroundColor = HEXCOLOR(0x05cfaa);
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue{
    self.keyLabel.text = curkey;
    self.valueLabel.text = curvalue;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
