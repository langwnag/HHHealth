//
//  LYFunctionMenuView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYFunctionMenuView.h"

@interface LYFunctionMenuView ()

@property (nonatomic, strong) UILabel   * titleLab;
@property (nonatomic, strong) UIView    * topLineView;
@property (nonatomic, strong) UIView    * bottomLineView;

@end

static CGFloat const leadingSpace = 15;
static CGFloat const topSpace = 10;

@implementation LYFunctionMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
        [self addGestureRecognize];
    }
    return self;
}

- (void)configUI{
//    [self addSubview:self.topLineView];
    [self addSubview:self.titleLab];
//    [self addSubview:self.bottomLineView];
}

- (void)addGestureRecognize{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tapOnFunctionMenuView)]) {
        [self.delegate tapOnFunctionMenuView];
    }
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(leadingSpace, topSpace, self.frame.size.width / 2, self.frame.size.height - topSpace * 2)];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = HEXCOLOR(0x444444);
        _titleLab.text = @"数量";
    }
    return _titleLab;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        _topLineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _topLineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        _bottomLineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _bottomLineView;
}

- (void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    _rightView.frame = CGRectMake(self.frame.size.width - 15 - rightView.frame.size.width, 0, rightView.frame.size.width, rightView.frame.size.height);
    [self addSubview:_rightView];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setClickable:(BOOL)clickable{
    _clickable = clickable;
    self.userInteractionEnabled = clickable;
}
@end
