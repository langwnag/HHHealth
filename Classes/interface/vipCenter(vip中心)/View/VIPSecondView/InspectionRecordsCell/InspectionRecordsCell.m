//
//  InspectionRecordsCell.m
//  YiJiaYi
//
//  Created by mac on 2016/12/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "InspectionRecordsCell.h"

@implementation InspectionRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 43/2.0f;
    self.iconView.layer.masksToBounds = YES;
//    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
