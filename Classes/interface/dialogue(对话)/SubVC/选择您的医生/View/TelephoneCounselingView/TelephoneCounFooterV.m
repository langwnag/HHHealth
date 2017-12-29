//
//  TelephoneCounFooterV.m
//  YiJiaYi
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TelephoneCounFooterV.h"

@implementation TelephoneCounFooterV
- (void)drawRect:(CGRect)rect {
    self.selectBtn.selected = YES;
    self.counseingBtn.layer.cornerRadius = 5.0f;
    self.counseingBtn.layer.masksToBounds = YES;
    self.counseingBtn.backgroundColor = HEXCOLOR(0xff6666);

}

- (IBAction)counseingBtn:(UIButton *)sender {
    if (self.selectBtn.selected) {
        if (self.counseingClickBtnBlock) {
            self.counseingClickBtnBlock();
        }
    }else{
        [MBProgressHUD showTextOnly:@"请选择已阅读《合合健康电话咨询说明》"];
    }
}
- (IBAction)selectBtn:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
