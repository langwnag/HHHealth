//
//  LYFunctionLabView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYFunctionLabView.h"

@interface LYFunctionLabView ()

@property (nonatomic, strong) UILabel * titleLab;

@end

@implementation LYFunctionLabView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    textColor:(UIColor *)textColor
                     textFont:(CGFloat)textFont{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
        self.textColor = textColor;
        self.textFont = textFont;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    textColor:(UIColor *)textColor
                     textFont:(CGFloat)textFont
                 leadingSpace:(CGFloat)leadingSpace
                     topSpace:(CGFloat)topSpace{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
        self.textColor = textColor;
        self.textFont = textFont;
        self.leadingSpace = leadingSpace;
        self.topSpace = topSpace;
    }
    return self;

}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 40)];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = HEXCOLOR(0x444444);
        _titleLab.text = @"产品图文详情";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.titleLab.text = text;
}

- (void)setFuncLabBgColor:(UIColor *)funcLabBgColor{
    _funcLabBgColor = funcLabBgColor;
    self.backgroundColor = funcLabBgColor;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.titleLab.textColor = textColor;
}

- (void)setLabBackgroundColor:(UIColor *)labBackgroundColor{
    _labBackgroundColor = labBackgroundColor;
    self.titleLab.backgroundColor = labBackgroundColor;
}

- (void)setTextFont:(CGFloat)textFont{
    _textFont = textFont;
    self.titleLab.font = [UIFont systemFontOfSize:textFont];
}

- (void)setLeadingSpace:(CGFloat)leadingSpace{
    _leadingSpace = leadingSpace;
    CGRect titleLabRect = self.titleLab.frame;
    titleLabRect.origin.x = leadingSpace;
    titleLabRect.size.width = self.frame.size.width - leadingSpace * 2;
    self.titleLab.frame = titleLabRect;
}

- (void)setTopSpace:(CGFloat)topSpace{
    _topSpace = topSpace;
    CGRect titleLabRect = self.titleLab.frame;
    titleLabRect.origin.y = topSpace;
    titleLabRect.size.width = self.frame.size.height - topSpace * 2;
    self.titleLab.frame = titleLabRect;
}
@end
