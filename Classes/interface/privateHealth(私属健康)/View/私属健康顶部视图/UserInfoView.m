//
//  UserInfoView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UserInfoView.h"
#import "SZRHUD.h"
#import "XLCircle.h"
#define VIPImageArr @[@"HHVIP",@"goldVIP",@"Platinum",@"diamondVIP"]
@interface UserInfoView ()
/** 时间 */
@property (nonatomic,strong) NSTimer* timer;
@end
@implementation UserInfoView


-(void)createUI{
    //头像背景视图
    UIImageView * headImageBG = [UIImageView new];
    [self addSubview:headImageBG];
    headImageBG.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    headImageBG.sd_cornerRadiusFromHeightRatio = @(0.5);
    headImageBG.image = [UIImage imageNamed:@"default_circle"];
    
    //进度条
    XLCircle * healthValueProgress = [[XLCircle alloc]init];
//    healthValueProgress.healthValueStr = self.healthValueLa.text;
    [self addSubview:healthValueProgress];
    self.healthValueProgress = healthValueProgress;
    
    healthValueProgress.sd_layout
    .heightRatioToView(self,277.0/350)
    .widthEqualToHeight(YES)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    
    //头像
    UIImageView * headImage = [UIImageView new];
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageV = headImage;
    [self addSubview:headImage];
    headImage.sd_layout
    .heightRatioToView(self,(238.0 - 20)/350)
    .widthEqualToHeight(YES)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    headImage.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    UIImageView * smallVipImageV = [UIImageView new];
    self.vipImageV = smallVipImageV;
    smallVipImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    smallVipImageV.layer.borderWidth = kAdaptedHeight(2);
    [self addSubview:smallVipImageV];
    smallVipImageV.sd_layout
    .heightRatioToView(self,(277-238.0 + 20)/350)
    .widthEqualToHeight(YES)
    .centerXEqualToView(self).offset(238/350*self.width/2/2)
    .centerYEqualToView(self).offset((238.0 - 80)/350*self.width/2/2*sqrt(3));
    smallVipImageV.sd_cornerRadiusFromHeightRatio = @0.5;
    
    // 新改需求
    UILabel* healthLa = [UILabel new];
    healthLa.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(healthLa, kAdaptedWidth(12), [UIColor whiteColor]);
    healthLa.text = self.healthStr;
    [self addSubview:healthLa];
    healthLa.sd_layout
    .heightRatioToView(self,(277-238.0 + 20)/350)
    .widthIs(120)
    .centerXEqualToView(self).offset(238/350*self.width/2/2)
    .centerYEqualToView(self).offset((238.0-400)/350*self.width/2/2*sqrt(3));
    
    UILabel* healthValueLa = [UILabel new];
    self.healthValueLa = healthValueLa;
    healthValueLa.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(healthValueLa, kAdaptedWidth(25), [UIColor whiteColor]);
    [self updateProgress];
    
    [self addSubview:healthValueLa];
    healthValueLa.sd_layout
    .heightRatioToView(self,(277-238.0 + 20)/350)
    .topSpaceToView(healthLa,-4)
    .widthIs(120)
    .centerXEqualToView(self).offset(238/350*self.width/2/2);
    
    UILabel* dateLa = [UILabel new];
    dateLa.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(dateLa, kAdaptedWidth(8), [UIColor whiteColor]);
    dateLa.text = [NSString stringWithFormat:@"评论时间：%@",self.dateStr];
    [self addSubview:dateLa];
    dateLa.sd_layout
    .heightRatioToView(self.headImageV,(277-238.0 + 20)/350)
    .widthIs(120)
    .centerXEqualToView(self).offset(238/350*self.width/2/2)
    .centerYEqualToView(self).offset((238.0 - 180)/350*self.width/2/2*sqrt(3));
    [self updateData];
}

-(void)updateProgress{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerSelector:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


-(void)timerSelector:(NSTimer *)timer{

    static NSInteger value = 0;

//    SZRLog(@"%ld %d", value, self.healthValueStr);
    
    if (value == self.healthValueStr*100) {
        [timer invalidate];
        timer = nil;
    }

    NSInteger intervalValue = self.healthValueStr*100 / 100;
//    SZRLog(@"%ld", intervalValue);
    self.healthValueLa.text = [NSString stringWithFormat:@"%ld", (NSInteger)(value / 100.f)];
    value += intervalValue;

}



-(void)updateData{
    [VDNetRequest VD_OSSImageView:self.headImageV fullURLStr:self.headImageStr placeHolderrImage:@""];
    if (self.vipLevel >= VIPImageArr.count) {
        self.vipLevel = 3;
    }
    self.vipImageV.image = [UIImage imageNamed:VIPImageArr[self.vipLevel]];
    
    self.healthValueProgress.progress = self.healthValue;
    
}


@end
