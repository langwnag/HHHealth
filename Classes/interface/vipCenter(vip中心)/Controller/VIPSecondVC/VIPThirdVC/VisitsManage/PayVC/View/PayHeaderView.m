//
//  PayHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayHeaderView.h"
@interface PayHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *desLa;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation PayHeaderView
- (void)dealloc{

}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.desLa.font =kLightFont(kAdaptedWidth_2(32));
    self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.desLa.sd_layout
    .leftSpaceToView(self,kAdaptedWidth_2(32))
    .centerYEqualToView(self)
    .widthIs(kAdaptedWidth(220))
    .heightIs(kAdaptedHeight(21));
    
    self.lineView.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self,k6PAdaptedWidth(16))
    .rightSpaceToView(self,k6PAdaptedWidth(0))
    .heightIs(.8);
    
    [self sd_addSubviews:@[self.desLa,self.lineView]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

@end
