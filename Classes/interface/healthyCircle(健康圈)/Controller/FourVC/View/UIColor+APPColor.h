//
//  UIColor+APPColor.h
//  IHealth_V2
//
//  Created by Mr_Li on 16/12/3.
//  Copyright © 2016年 Mr_Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (APPColor)

+ (UIColor *)getRGBColor:(unsigned long)rgbValue;

+ (UIColor *)getRGBColor:(unsigned long)rgbValue alpha:(float)alpha;

//主题颜色(绿色)
+ (UIColor *)mainColor;

//tabBar 颜色
+ (UIColor *)tabBarColor;

//背景颜色
+ (UIColor *)backgroundColor;

//浅边框颜色
+ (UIColor *)lightBorderColor;

//深边框颜色
+ (UIColor *)darkBorderColor;

//黑
+ (UIColor *)black;

//红
+ (UIColor *)red;

//浅灰色
+ (UIColor *)lightGray;
@end
