//
//  ZFPlayerMaskView.m
//  Player
//
//  Created by 任子丰 on 16/3/4.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "IWPlayerMaskView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry.h>

@interface IWPlayerMaskView ()

/** bottom渐变层*/
@property (strong, nonatomic) CAGradientLayer *bottomGradientLayer;
/** top渐变层 */
@property (strong, nonatomic) CAGradientLayer *topGradientLayer;
/** bottomView*/
@property(nonatomic,strong)UIImageView *bottomImageView;
/** topView */
@property(nonatomic,strong)UIImageView *topImageView;

@end

@implementation IWPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // 初始化渐变层
        [self initCAGradientLayer];
        [self layoutSetting];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)layoutSetting
{
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [self addSubview:self.topImageView];
    
    self.bottomImageView = [[UIImageView alloc] init];
    self.bottomImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [self addSubview:self.bottomImageView];
    
    self.bottomGradientLayer.frame = self.bottomImageView.bounds;
    self.topGradientLayer.frame = self.topImageView.bounds;
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.startBtn];
    // 播放按钮点击事件
    [self.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];

    self.currentTimeLabel = [[UILabel alloc] init];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.currentTimeLabel];
    
    self.totalTimeLabel = [[UILabel alloc] init];
    self.totalTimeLabel.textColor = [UIColor lightGrayColor];
    self.totalTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.totalTimeLabel];
    
    self.videoSlider = [[UISlider alloc] init];
    self.videoSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.videoSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self addSubview:self.videoSlider];
    
    self.formatLabel = [[UILabel alloc] init];
    [self addSubview:self.formatLabel];
//    self.formatLabel.text = @"2D";
    self.formatLabel.textColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc] init];
    [self addSubview:self.nameLabel];
//    self.nameLabel.text = [NSString stringWithFormat:@"%@",@"爸爸快长大"];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.seqLabel = [[UILabel alloc] init];
    [self addSubview:self.seqLabel];
//    self.seqLabel.text = [NSString stringWithFormat:@"第%@集",@"22"];
    self.seqLabel.textColor = [UIColor whiteColor];
//    
//    self.VRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:self.VRBtn];
//    [self.VRBtn addTarget:self action:@selector(clickVR:) forControlEvents:UIControlEventTouchUpInside];
//    self.VRBtn.backgroundColor = [UIColor lightGrayColor];
//    self.VRBtn.layer.cornerRadius = 5.0;
//    [self.VRBtn setTitle:@"进入VR" forState:UIControlStateNormal];
//    
//    self.itemsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:self.itemsBtn];
//    [self.itemsBtn addTarget:self action:@selector(clickItems:) forControlEvents:UIControlEventTouchUpInside];
//    self.itemsBtn.backgroundColor = [UIColor lightGrayColor];
//    self.itemsBtn.layer.cornerRadius = 5.0;
//    [self.itemsBtn setTitle:@"剧 集" forState:UIControlStateNormal];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(60));
    }];
    
    //格式/名称/当前选集
    [self.formatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(50);
//        make.width.equalTo(@(30));
        make.height.equalTo(@(28));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formatLabel);
//        make.left.equalTo(self.formatLabel.mas_right).offset(10);
//        make.width.equalTo(@(200));
        make.centerX.equalTo(self);
        make.height.equalTo(self.formatLabel);
    }];
    
    [self.seqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formatLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
//        make.width.equalTo(@(60));
        make.height.equalTo(self.formatLabel);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-90);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(90));
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.mas_bottom).offset(-55);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startBtn);
        make.left.equalTo(self.startBtn.mas_right).offset(30);
        make.width.equalTo(@(80));
        make.height.equalTo(self.startBtn);
        
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startBtn);
        make.left.equalTo(self.currentTimeLabel.mas_right);
        make.width.equalTo(@(80));
        make.height.equalTo(self.startBtn);
        
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startBtn).offset(-10);
        make.centerX.equalTo(self);
        make.left.equalTo(self.startBtn);
        make.height.equalTo(@(2));

    }];
    
    //VR模式/剧集列表
//    [self.itemsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.startBtn);
//        make.right.equalTo(self.videoSlider);
//        make.width.equalTo(@(60));
//        make.height.equalTo(@(30));
//    }];
//    
//    [self.VRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.startBtn);
//        make.right.equalTo(self.itemsBtn.mas_left).offset(-15);
////        make.width.equalTo(self.itemsBtn);
//        make.height.equalTo(self.itemsBtn);
//        
//    }];
    

}

- (void)initCAGradientLayer
{
    //初始化Bottom渐变层
    self.bottomGradientLayer = [CAGradientLayer layer];
    [self.bottomImageView.layer addSublayer:self.bottomGradientLayer];
    //设置渐变颜色方向
    self.bottomGradientLayer.startPoint = CGPointMake(0, 0);
    self.bottomGradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    self.bottomGradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                        (__bridge id)[UIColor blackColor].CGColor];
    //设定颜色分割点
    self.bottomGradientLayer.locations = @[@(0.0f) ,@(1.0f)];

    
    //初始Top化渐变层
    self.topGradientLayer = [CAGradientLayer layer];
    [self.topImageView.layer addSublayer:self.topGradientLayer];
    //设置渐变颜色方向
    self.topGradientLayer.startPoint = CGPointMake(1, 0);
    self.topGradientLayer.endPoint = CGPointMake(1, 1);
    //设定颜色组
    self.topGradientLayer.colors = @[ (__bridge id)[UIColor blackColor].CGColor,
                                      (__bridge id)[UIColor clearColor].CGColor];
    //设定颜色分割点
    self.topGradientLayer.locations = @[@(0.0f) ,@(1.0f)];

}


//播放、暂停
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        [_player play];
        [button setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        
    } else {
        [_player pause];
        [button setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        
    }
    button.selected =!button.selected;
}

//进入VR模式
-(void)clickVR:(UIButton*)btn{
    NSLog(@"进入VR模式");
}

//显示剧集列表
-(void)clickItems:(UIButton*)btn{
    NSLog(@"显示剧集列表");
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.nameLabel.text = titleStr;
}

//if (self.isLocked) {
//    [self unLockTheScreen];
//    return;
//}else {
//    if (self.isFullScreen) {
//        [self.timer invalidate];
//        [_player pause];
//        if (self.goBackBlock) {
//            self.goBackBlock();
//        }
//    }else {
//        [self interfaceOrientation:UIInterfaceOrientationPortrait];
//    }
//}


@end
