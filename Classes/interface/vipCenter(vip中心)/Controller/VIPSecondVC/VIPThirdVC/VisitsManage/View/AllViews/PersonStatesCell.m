//
//  PersonStatesCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PersonStatesCell.h"
@implementation PersonStatesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLa.textColor = kWord_Gray_3;
    self.leftLa.font = SYSTEMFONT(36/3);
    self.contentLa.textColor = kWord_Gray_6;
    self.contentLa.font = SYSTEMFONT(36/3);
    self.lineV.backgroundColor = HEXCOLOR(0xe9e9e9);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
