//
//  GiftCell.m
//  YiJiaYi
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GiftCell.h"

@implementation GiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _selectedImage.hidden = !selected;
//    SZRLog(@"cell %@ selected %zd",self.selected);

}


@end
