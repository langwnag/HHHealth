//
//  RadarView.h
//  雷达旋转扫描demo
//
//  Created by SZR on 16/8/31.
//  Copyright © 2016年 VDChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarView : UIView
@property(nonatomic, assign) CGFloat selfWidth;
@property(nonatomic, strong) UIImageView *radarImageV;
@property(nonatomic, strong) UILabel *descrpLa;
@property(nonatomic, assign) BOOL isSkipVC;
- (void)beginAnimation;
@end
