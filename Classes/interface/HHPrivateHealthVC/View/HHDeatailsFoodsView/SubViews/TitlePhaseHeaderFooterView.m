//
//  TitlePhaseHeaderFooterView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TitlePhaseHeaderFooterView.h"

@implementation TitlePhaseHeaderFooterView
{
    UIView* _lastView;
    
    UILabel* _titlePhaseLa;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _lastView = [UIView new];
        _lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _titlePhaseLa = [UILabel new];
        [self.contentView sd_addSubviews:@[_lastView,_titlePhaseLa]];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _lastView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(8);
    
    _titlePhaseLa.sd_layout
    .leftSpaceToView(self.contentView,80)
    .rightSpaceToView(self.contentView,80)
    .topSpaceToView(_lastView,k6P_3AdaptedHeight(20))
    .heightIs(21);

}

- (void)setTitleStr:(NSAttributedString *)titleStr{
    _titleStr = titleStr;
    _titlePhaseLa.attributedText= titleStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
