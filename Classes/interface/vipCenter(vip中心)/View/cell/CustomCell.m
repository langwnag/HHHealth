//
//  CustomCell.m
//  YiJiaYi
//
//  Created by SZR on 16/9/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CustomCell.h"
@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end





