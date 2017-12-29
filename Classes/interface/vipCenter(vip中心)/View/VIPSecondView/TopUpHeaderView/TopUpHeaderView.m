//
//  TopUpHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TopUpHeaderView.h"
@interface TopUpHeaderView()
// 支付宝
@property (weak, nonatomic) IBOutlet UIButton *payTreasureBtn;
// 微信
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (assign, nonatomic) BOOL selectType;//支付方式，0表示支付宝，1表示微信

@end
@implementation TopUpHeaderView
- (IBAction)selectBtn:(UIButton *)sender {
    [self.payTreasureBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
  
}
- (IBAction)weChatBtn:(UIButton *)sender {
    [self.weChatBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)checkboxClick:(UIButton *)btn
{
    if (btn.selected == NO) {
        btn.selected = !btn.selected;
        if (btn == self.payTreasureBtn) {
            self.weChatBtn.selected = NO;
        }else{
            self.payTreasureBtn.selected = NO;
        }
        self.selectType = !self.selectType;
    }

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.payTreasureBtn.selected = YES;
}


@end
