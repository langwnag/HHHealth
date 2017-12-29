//
//  CompationHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayFooterViews.h"

@implementation PayFooterViews
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.payBtn.layer.cornerRadius = 5.0f;
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.backgroundColor = HEXCOLOR(0xff6666);

    self.motifyBtn.layer.cornerRadius = 5.0f;
    self.motifyBtn.layer.masksToBounds = YES;
    self.motifyBtn.layer.borderWidth = 1.0f;
    self.motifyBtn.layer.borderColor = kWord_Gray_6.CGColor;
    
    self.cancelBtn.layer.cornerRadius = 5.0f;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderWidth = 1.0f;
    self.cancelBtn.layer.borderColor = kWord_Gray_6.CGColor;

}
// 取消
- (IBAction)cancelBtn:(UIButton *)sender {
    if (self.cancel) {
        self.cancel();
    }
}
// 修改
- (IBAction)motify:(UIButton *)sender {
    if (self.motify) {
        self.motify();
    }
}
// 支付
- (IBAction)payBtn:(UIButton *)sender {
    if (self.pay) {
        self.pay();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
