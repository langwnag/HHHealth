//
//  AppHubView.h
//  IHealth
//
//  Created by zhengmeijie on 16/1/28.
//  Copyright © 2016年 zhengmeijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^LYDeleteBlock)();
//#define APP_HUB_VIEW [AppHubView shareHubView]
/**
 *  提醒视图
 */
@interface AppHubView : NSObject

@property (nonatomic, copy) LYDeleteBlock deleteBlock;
//@property (nonatomic,assign) CGFloat progress;
/**
 *  单例
 *
 *  @return 提醒视图实例
 */
//+ (AppHubView*)shareHubView;
//
//
//- (void)showTips:(NSString*)title;
//
//- (void)showHubViewTitle:(NSString*)title inView:(UIView*)displayView;
//- (void)showHubViewTitle:(NSString*)title autoHideTime:(NSTimeInterval)timeInterval inView:(UIView*)displayView;
//- (void)showHubViewTitle:(NSString*)title defaultTimeInView:(UIView*)displayView;
//- (void)showHubViewAnnularProgressTitle:(NSString*)title inView:(UIView*)displayView;
//- (void)showHubViewIndeterminateProgressTitle:(NSString*)title inView:(UIView*)displayView;
//- (void)hideHubView;

+ (void)showAlertWithTitle:(NSString *)title deleteBlock:(LYDeleteBlock)deleteBlock;

@end



@protocol KYEmptyDataSetSource;
@protocol KYEmptyDataSetDelegate;

#define KYEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")


@interface UIScrollView (EmptyDataSet)


@property (nonatomic, weak) IBOutlet id <KYEmptyDataSetSource> emptyDataSetSource;

@property (nonatomic, weak) IBOutlet id <KYEmptyDataSetDelegate> emptyDataSetDelegate;

@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;


- (void)reloadEmptyDataSet;

@end



@protocol KYEmptyDataSetSource <NSObject>
@optional


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;



- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;


- (CAAnimation *) imageAnimationForEmptyDataSet:(UIScrollView *) scrollView;


- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;


- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView KYEmptyDataSetDeprecated(-verticalOffsetForEmptyDataSet:);
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;

@end


@protocol KYEmptyDataSetDelegate <NSObject>
@optional


- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;


- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView;


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;


- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;


- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;


- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView KYEmptyDataSetDeprecated(-emptyDataSet:didTapView:);


- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView KYEmptyDataSetDeprecated(-emptyDataSet:didTapButton:);


- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;


- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;


- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;


- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;


- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;


- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end

#undef KYEmptyDataSetDeprecated


