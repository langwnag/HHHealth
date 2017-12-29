//
//  LeftCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LeftCell.h"
@interface LeftCell ()
@end


@implementation LeftCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
