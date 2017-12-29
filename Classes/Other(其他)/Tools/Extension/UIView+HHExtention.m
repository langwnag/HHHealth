//
//  UIView+HHExtention.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIView+HHExtention.h"

@implementation UIView (HHExtention)

-(void)assignRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [self.backgroundColor CGColor];
    backLayer.strokeColor  = self.layer.borderColor;
    backLayer.lineWidth = self.layer.borderWidth;
    backLayer.path = [maskPath CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
}

@end
