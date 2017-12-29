//
//  LYNavigationView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYNavigationView.h"

@interface LYNavigationView ()

//@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation LYNavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = HEXCOLOR(0xefeff4);
//    [self addSubview:self.leftBtn];
    [self addSubview:self.titleLab];
    [self addSubview:self.lineView];
}


- (void)lyLeftBtnClicked:(UIButton *)btn{
    
}

//- (UIButton *)leftBtn{
//    if (!_leftBtn) {
//        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftBtn.frame = CGRectMake(15, 22, 20, 20);
//        [_leftBtn setImage:[UIImage imageNamed:kBackBtnName] forState:UIControlStateNormal];
//        [_leftBtn addTarget:self action:@selector(lyLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftBtn;
//}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, self.frame.size.width - 100, 44)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, self.frame.size.width, 0.5)];
        _lineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _lineView;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}
@end
