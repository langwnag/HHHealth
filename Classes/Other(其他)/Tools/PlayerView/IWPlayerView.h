//
//  ZFPlayerView.h
//  Player
//
//  Created by 任子丰 on 16/3/3.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IWPlayerGoBackBlock)(void);

@interface IWPlayerView : UIView

/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;
/** 标题 */
@property(nonatomic,copy)NSString * nameStr;

/** 返回按钮Block */
@property (nonatomic, copy) IWPlayerGoBackBlock goBackBlock;
/**
 *  取消延时隐藏maskView的方法,在ViewController的delloc方法中调用
 *  用于解决：刚打开视频播放器，就关闭该页面，maskView的延时隐藏还未执行。
 */
- (void)cancelAutoFadeOutControlBar;

- (void)fullScreenAction:(UIButton *)sender;

@end
