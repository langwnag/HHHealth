//
//  RadarView.m
//  雷达旋转扫描demo
//
//  Created by SZR on 16/8/31.
//  Copyright © 2016年 VDChina. All rights reserved.
//

#import "RadarView.h"

@implementation RadarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selfWidth = frame.size.width;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //背景图片
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.selfWidth - 8, self.selfWidth - 8)];
    imageV.center = self.center;
    imageV.image = [UIImage imageNamed:@"yuanquan"];
    [self addSubview:imageV];

    //扫描图片
    self.radarImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.selfWidth, self.selfWidth)];
//    self.radarImageV.backgroundColor = [UIColor cyanColor];
    self.radarImageV.center = self.center;
    self.radarImageV.image = [UIImage imageNamed:@"saomiao"];
    [self addSubview:self.radarImageV];

    //请稍等
    UILabel *waitLa = [SZRFunction createLabelWithFrame:CGRectMake((self.selfWidth - 100) / 2, 0, 100, 21) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:13] text:@"请稍等"];
    waitLa.textAlignment = NSTextAlignmentCenter;
    waitLa.center = self.center;
    [self addSubview:waitLa];

    //描述
    self.descrpLa = [SZRFunction createLabelWithFrame:CGRectMake(50, CGRectGetMaxY(waitLa.frame) + 43, SZRScreenWidth - 50 * 2, 21) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:15] text:@"我们正在为您匹配专业的医师"];
    self.descrpLa.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.descrpLa];

    [self beginAnimation];
}

- (void)beginAnimation {
    //创建动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0.0f;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.speed = 1;
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = 3;

    [self.radarImageV.layer addAnimation:rotationAnimation forKey:@"radarAnimation"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isSkipVC) {
            self.descrpLa.text = @"已经为您匹配到300位专业医师!";
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isSkipVC) {
            //要执行的操作
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if ([delegate respondsToSelector:@selector(rootVCWithTabBarVC)]) {
//                [delegate performSelector:@selector(rootVCWithTabBarVC)];
//            }
            [UIApplication sharedApplication].keyWindow.rootViewController = [DDMenuController shareDDMenuVC];
        }
    });
}


@end
