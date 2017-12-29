//
//  NoCommunityCell.m
//  YiJiaYi
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoCommunityCell.h"
NSString * const kNoCommunityCell = @"NoCommunityCell";

@implementation NoCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
+ (CGFloat)noCommunityCellHeight{
    return 70;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
