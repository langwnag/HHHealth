//
//  CancelOrderFooterView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CancelOrderFooterView.h"
#import "SelectFamilyVisitModel.h"
@implementation CancelOrderFooterView
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.statesBtn.layer.cornerRadius = 5.0f;
    self.statesBtn.layer.masksToBounds = YES;
    self.statesBtn.layer.borderWidth = 1.0f;
    self.statesBtn.layer.borderColor = kWord_Gray_6.CGColor;
    self.statesBtn.tintColor = kWord_Gray_6;
}
- (void)setSelectFamilyVisitModel:(SelectFamilyVisitModel *)selectFamilyVisitModel{
    _selectFamilyVisitModel = selectFamilyVisitModel;
    if ([selectFamilyVisitModel.serviceOrderState isEqualToString:@"1"] ) {
        [self.statesBtn setTitle:@"已确认" forState:UIControlStateNormal];
    }else if ([selectFamilyVisitModel.serviceOrderState isEqualToString:@"2"] ){
        [self.statesBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
    }else if ([selectFamilyVisitModel.serviceOrderState isEqualToString:@"3"]){
        [self.statesBtn setTitle:@"已过期" forState:UIControlStateNormal];
    }else{
        [self.statesBtn setTitle:@"已完成" forState:UIControlStateNormal];
    }

}


- (IBAction)statesBtn:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }else if ([sender.titleLabel.text isEqualToString:@"已完成"]){
        if (self.completeBlock) {
            self.completeBlock();
        }
    }else{
        if (self.evaluationBlock) {
            self.evaluationBlock();
        }
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
