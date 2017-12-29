//
//  LYFunctionBtnView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYFunctionBtnView.h"

@interface LYFunctionBtnView ()

@property (nonatomic, strong) UIButton * functionBtn;

@end

@implementation LYFunctionBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.3];
        [self addSubview:self.functionBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
             functionBtnTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.functionBtn];
        self.functionBtnTitle = title;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
             functionBtnTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.functionBtn];
        self.functionBtnTitle = title;
        self.titleColor = titleColor;
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
             functionBtnTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                   btnBgColor:(UIColor *)btnBgColor{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.functionBtn];
        self.functionBtnTitle = title;
        self.titleColor = titleColor;
        self.btnBgColor = btnBgColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
             functionBtnTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                   btnBgColor:(UIColor *)btnBgColor
                  funcBgColor:(UIColor *)funcBgColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.functionBtn];
        self.functionBtnTitle = title;
        self.titleColor = titleColor;
        self.btnBgColor = btnBgColor;
        self.funcBgColor = funcBgColor;
    }
    return self;

}


- (UIButton *)functionBtn{
    if (!_functionBtn) {
        _functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _functionBtn.backgroundColor = HEXCOLOR(0xff6666);
        _functionBtn.titleLabel.textColor = [UIColor whiteColor];
        _functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_functionBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_functionBtn setFrame:CGRectMake(60, 10, self.frame.size.width - 60 * 2, self.frame.size.height - 10 * 2)];
        _functionBtn.layer.cornerRadius = 5;
        
        [_functionBtn addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _functionBtn;
}

- (void)functionBtnClicked:(UIButton *)btn{
    if (self.functionBtnBlock) {
        self.functionBtnBlock(btn);
    }
    
    if ([self.delegate respondsToSelector:@selector(clickFunctionBtn:)]) {
        [self.delegate clickFunctionBtn:btn];
    }
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self.functionBtn setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setFunctionBtnTitle:(NSString *)functionBtnTitle{
    _functionBtnTitle = functionBtnTitle;
    [self.functionBtn setTitle:functionBtnTitle forState:UIControlStateNormal];
}

- (void)setBtnBgColor:(UIColor *)btnBgColor{
    _btnBgColor = btnBgColor;
    [self.functionBtn setBackgroundColor:btnBgColor];
}

- (void)setFuncBgColor:(UIColor *)funcBgColor{
    _funcBgColor = funcBgColor;
    self.backgroundColor = funcBgColor;
}
@end
