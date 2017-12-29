//
//  HealthCircleFooterView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HealthCircleFooterView.h"

@implementation HealthCircleFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if (self.confirmBtnClickBlock) {
        self.confirmBtnClickBlock();
    }
}
@end
