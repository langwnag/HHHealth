//
//  LYPlayBannerView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

@protocol LYPlayBannerViewDelegate <NSObject>

- (void)clickPlayBannerView;

@end

/**
 带有播放按钮的banner
 */
@interface LYPlayBannerView : UIView

/** imageView */
@property (nonatomic, strong) UIImageView * imageView;

/** 播放按钮图片 */
@property (nonatomic, strong) UIImage * playImage;


/** delegate */
@property (nonatomic, assign) id<LYPlayBannerViewDelegate>delegate;

@end
