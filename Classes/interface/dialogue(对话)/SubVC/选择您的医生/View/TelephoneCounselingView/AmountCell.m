//
//  AmountCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AmountCell.h"

@implementation AmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
