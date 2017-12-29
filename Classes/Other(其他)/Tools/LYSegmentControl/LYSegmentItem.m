//
//  LYSegmentItem.m
//  LYScrollView
//
//  Created by Mr.Li on 2017/6/28.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYSegmentItem.h"

@interface LYSegmentItem ()

@property (nonatomic, strong) UILabel   * titleLab;
@property (nonatomic, strong) UIView    * lineView;

@end

@implementation LYSegmentItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.titleLab];
    [self addSubview:self.lineView];
}

#pragma mark - lazy load
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = @"123";
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), self.frame.size.width, 2)];
    }
    return _lineView;
}
#pragma mark - rewrite set method
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _titleLab.textColor = textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    _titleLab.backgroundColor = backgroundColor;
}

- (void)setFontSize:(NSInteger)fontSize{
    _fontSize = fontSize;
    _titleLab.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (self.selected) {
        self.titleLab.textColor = [UIColor redColor];
        self.lineView.backgroundColor = [UIColor redColor];
    }else{
        self.titleLab.textColor = [UIColor blackColor];
        self.lineView.backgroundColor = [UIColor clearColor];
    }
}


@end
