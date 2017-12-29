//
//  LYFunctionMenuView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

@protocol LYFunctionMenuViewDelegate <NSObject>

- (void)tapOnFunctionMenuView;

@end

/**
 左侧为lab 右侧视图自定义
 */
@interface LYFunctionMenuView : UIView

/** 左侧lab的text */
@property (nonatomic, strong) NSString * title;
/** 右侧视图 */
@property (nonatomic, strong) UIView * rightView;

/** titleLab距离左侧的间距 */
@property (nonatomic, assign) CGFloat leadingSpace;
/** titleLab距离顶部的间距 */
@property (nonatomic, assign) CGFloat topSpace;

/** 是否可点击 */
@property (nonatomic, assign) BOOL clickable;

@property (nonatomic, assign) id<LYFunctionMenuViewDelegate>delegate;

@end
