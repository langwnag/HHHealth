//
//  MoviePlayerViewController.m
//  Player
//
//  Created by 任子丰 on 16/3/3.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "IWMPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IWPlayerView.h"

@interface IWMPlayerViewController ()

@property(nonatomic,strong)IWPlayerView *playerView;
@end

@implementation IWMPlayerViewController

-(void)dealloc
{
    //NSLog(@"%@释放了",self.class);
    [self.playerView cancelAutoFadeOutControlBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView = [[IWPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [self.view addSubview:self.playerView];
    self.playerView.nameStr = self.videoTitle;
    self.playerView.videoURL = self.videoURL;
     __weak typeof(self) weakSelf = self;
    self.playerView.goBackBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor  = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}


//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
