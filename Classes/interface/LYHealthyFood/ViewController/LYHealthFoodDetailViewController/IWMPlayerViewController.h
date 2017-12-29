//
//  IWMPlayerViewController.h
//  Player
//
//  Created by 任子丰 on 16/3/3.
//  Copyright © 2016年 任子丰. All rights reserved.
//

/** 视频播放控制器 */
#import <UIKit/UIKit.h>

@interface IWMPlayerViewController : UIViewController
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;
/** 标题 */
@property(nonatomic,copy)NSString * videoTitle;
@end
