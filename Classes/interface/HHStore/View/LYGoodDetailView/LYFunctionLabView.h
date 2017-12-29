//
//  LYFunctionLabView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

/**
 携带有一个Lab的View
 */
@interface LYFunctionLabView : UIView

@property (nonatomic, strong) NSString      * text;
@property (nonatomic, strong) UIColor       * textColor;
@property (nonatomic, strong) UIColor       * funcLabBgColor;
@property (nonatomic, strong) UIColor       * labBackgroundColor;
@property (nonatomic, assign) CGFloat         textFont;

@property (nonatomic, assign) CGFloat         leadingSpace;
@property (nonatomic, assign) CGFloat         topSpace;

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(CGFloat)textFont;

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(CGFloat)textFont leadingSpace:(CGFloat)leadingSpace topSpace:(CGFloat)topSpace;
@end
