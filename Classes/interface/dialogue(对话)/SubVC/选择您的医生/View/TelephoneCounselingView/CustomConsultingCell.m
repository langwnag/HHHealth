//
//  CustomConsultingCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CustomConsultingCell.h"

@implementation CustomConsultingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.descriptionLa.textColor = kWord_Gray_6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
