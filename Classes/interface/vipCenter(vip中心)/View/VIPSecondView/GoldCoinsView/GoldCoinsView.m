//
//  GoldCoinsView.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GoldCoinsView.h"
@implementation GoldCoinsView

- (void)awakeFromNib{
    [super awakeFromNib];
    // 赚取金币
    self.getGoldCoinsBtn.layer.cornerRadius = 5.0f;
    self.getGoldCoinsBtn.layer.masksToBounds = YES;
    self.getGoldCoinsBtn.layer.borderWidth = 1.0f;
    self.getGoldCoinsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}
// 充值金币
- (IBAction)payCoins:(id)sender {
    if (self.skipPayBlock) {
        self.skipPayBlock();
    }
}





@end
