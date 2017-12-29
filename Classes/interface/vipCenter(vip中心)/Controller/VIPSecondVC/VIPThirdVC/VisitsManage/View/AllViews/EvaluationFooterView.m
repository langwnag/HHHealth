//
//  EvaluationFooterView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "EvaluationFooterView.h"

@implementation EvaluationFooterView
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{};

- (void)awakeFromNib{
    [super awakeFromNib];

    self.serviceAmouLa.text = @"服务内容";
//    kWord_Gray_3
    self.serviceAmouLa.textColor = [UIColor greenColor];
    self.serviceAmouLa.font = SYSTEMFONT(36/3);
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.backgroundView = view;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
