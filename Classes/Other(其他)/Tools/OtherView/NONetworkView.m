//
//  NONetworkView.m
//  客邦
//
//  Created by SZR on 16/5/25.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "NONetworkView.h"

@implementation NONetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)refreshBtnClick:(UIButton *)sender {
    self.refreshBtnBlock();
}
@end
