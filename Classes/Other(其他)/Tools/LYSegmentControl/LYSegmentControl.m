//
//  LYSegmentControl.m
//  LYScrollView
//
//  Created by Mr.Li on 2017/7/11.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYSegmentControl.h"
#import "LYSegmentItem.h"

@interface LYSegmentControl ()

@property (nonatomic, strong) UIView        * topLineView;
@property (nonatomic, strong) UIView        * bottomLineView;
@property (nonatomic, strong) UIScrollView  * scrollView;
@end

@implementation LYSegmentControl

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.titleArr = arr;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topLineView];
        [self addSubview:self.bottomLineView];
    }
    return self;
}

- (void)setTitleArr:(NSArray *)titleArr{
    
    CGFloat itemWidth = self.frame.size.width / titleArr.count;

    for (NSInteger i = 0; i < titleArr.count; i++) {
        LYSegmentItem * item = [[LYSegmentItem alloc] initWithFrame:CGRectMake(itemWidth * i, 0.5, itemWidth, self.frame.size.height - 1)];
        item.title = titleArr[i];
        item.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSegcontrolItem:)];
        [item addGestureRecognizer:tap];
        [self addSubview:item];
    }
}

- (void)tapOnSegcontrolItem:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld", tap.view.tag);
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[LYSegmentItem class]]) {
            LYSegmentItem * tmpItem = (LYSegmentItem *)view;
            if (view.tag != tap.view.tag) {
                tmpItem.selected = NO;
            }else{
                tmpItem.selected = YES;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(lySegmentControlSelectAtIndex:)]) {
        [self.delegate lySegmentControlSelectAtIndex:tap.view.tag];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[LYSegmentItem class]]) {
            LYSegmentItem * tmpItem = (LYSegmentItem *)view;
            if (view.tag == selectedIndex) {
                tmpItem.selected = YES;
            }else{
                tmpItem.selected = NO;
            }
        }
    }
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

//- (UIScrollView *)scrollView{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds]
//    }
//}

- (void)setShowTopline:(BOOL)showTopline{
    _showTopline = showTopline;
    self.topLineView.hidden = !showTopline;
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    self.bottomLineView.hidden = !showBottomLine;
}

@end
