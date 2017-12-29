//
//  LocationCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.selectionStyle                = UITableViewCellSelectionStyleNone;
        self.textLabel.font                = [UIFont systemFontOfSize:16];
        self.detailTextLabel.font          = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor     = [UIColor grayColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
