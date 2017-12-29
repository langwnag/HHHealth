//
//  MessageCell.m
//  YiJiaYi
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isHidenMessageLa.layer.cornerRadius = 10.0f;
    self.isHidenMessageLa.layer.masksToBounds = YES;

    self.iconUrl.layer.cornerRadius = 30.0f;
    self.iconUrl.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
