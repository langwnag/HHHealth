//
//  LYPlayBannerView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYPlayBannerView.h"

@interface LYPlayBannerView ()

@property (nonatomic, strong) UIImageView * playImageView;

@end

static CGFloat const playImageViewHeight = 30;

@implementation LYPlayBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.playImageView];
}

- (void)setPlayImage:(UIImage *)playImage{
    _playImage = playImage;
    self.playImageView.image = playImage;
}

- (UIImageView *)playImageView{
    if (!_playImageView) {
        CGFloat originX = (self.frame.size.width - playImageViewHeight) / 2;
        CGFloat originY = (self.frame.size.height - playImageViewHeight) / 2;
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, playImageViewHeight, playImageViewHeight)];
        _playImageView.image = [UIImage imageNamed:@"swithBtn"];
        _playImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
        [_playImageView addGestureRecognizer:tap];

    }
    return _playImageView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

- (void)tapOnImageView:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayBannerView)]) {
        [self.delegate clickPlayBannerView];
    }
}


@end
