//
//  FamilyDetailsHeaderV.m
//  YiJiaYi
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FamilyDetailsHeaderV.h"

@implementation FamilyDetailsHeaderV
- (void)drawRect:(CGRect)rect {
    self.nameLa.textColor = HEXCOLOR(0xfffaba);
    self.nameLa.font = [UIFont boldSystemFontOfSize:15];
    self.nameLa.adjustsFontSizeToFitWidth = YES;
    self.percentageLa.textColor = HEXCOLOR(0xfffaba);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
