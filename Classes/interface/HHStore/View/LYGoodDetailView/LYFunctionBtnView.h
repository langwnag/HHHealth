//
//  LYFunctionBtnView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

typedef void(^LYFunctionBtnBlock)(UIButton * btn);

@protocol LYFunctionBtnViewDelegate <NSObject>

- (void)clickFunctionBtn:(UIButton *)btn;

@end
/**
 携带有一个Button的View
 */
@interface LYFunctionBtnView : UIView

//click btn block
@property (nonatomic, copy) LYFunctionBtnBlock functionBtnBlock;

//btn title
@property (nonatomic, strong) NSString * functionBtnTitle;
//btn titleColor
@property (nonatomic, strong) UIColor * titleColor;
//btn backgroundColor
@property (nonatomic, strong) UIColor * btnBgColor;
//LYFunctionBtnView backgroundColor
@property (nonatomic, strong) UIColor * funcBgColor;

@property (nonatomic, assign) id<LYFunctionBtnViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame functionBtnTitle:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame functionBtnTitle:(NSString *)title titleColor:(UIColor *)titleColor;

- (instancetype)initWithFrame:(CGRect)frame functionBtnTitle:(NSString *)title titleColor:(UIColor *)titleColor btnBgColor:(UIColor *)btnBgColor;

- (instancetype)initWithFrame:(CGRect)frame functionBtnTitle:(NSString *)title titleColor:(UIColor *)titleColor btnBgColor:(UIColor *)btnBgColor funcBgColor:(UIColor *)funcBgColor;



@end
