//
//  ZFPlayerMaskView.h
//  Player
//
//  Created by 任子丰 on 16/3/4.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@interface IWPlayerMaskView : UIView


/** 开始播放按钮 */
@property(nonatomic,strong)UIButton *startBtn;
/** 当前播放时长label */
@property(nonatomic,strong)UILabel *currentTimeLabel;
/** 视频总时长label */
@property(nonatomic,strong)UILabel *totalTimeLabel;
/** 缓冲进度条 */
//@property(nonatomic,strong)UIProgressView *progressView;
/** 滑杆 */
@property(nonatomic,strong)UISlider *videoSlider;
/** 全屏按钮 */
@property(nonatomic,strong)UIButton *fullScreenBtn;

@property(nonatomic,strong)UIButton *lockBtn;

@property (nonatomic, strong) AVPlayer *player;

/** VR模式 */
@property(nonatomic,strong)UIButton *VRBtn;

/** 剧集按钮 */
@property(nonatomic,strong)UIButton *itemsBtn;

/** 视频格式 3D/360/2D */
@property(nonatomic,strong)UILabel *formatLabel;

/** 名称 */
@property(nonatomic,strong)UILabel *nameLabel;

/** 当前选集 */
@property(nonatomic,strong)UILabel *seqLabel;

/** 标题 */
@property (nonatomic,copy) NSString* titleStr;



@end
