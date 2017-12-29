//
//  SystemHeaderFooterView.m
//  HeheHealthManager
//
//  Created by mac on 2017/3/30.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "SystemHeaderFooterView.h"

@implementation SystemHeaderFooterView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.topLineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
