//
//  VIPBrowser.h
//  YiJiaYi
//
//  Created by SZR on 2017/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVIPBrowserHeight kAdaptedWidth(190)


@class VIPBrowser;
@protocol VIPBrowserDelegate <NSObject>

@optional
- (void)movieBrowser:(VIPBrowser *)movieBrowser didSelectItemAtIndex:(NSInteger)index;
- (void)movieBrowser:(VIPBrowser *)movieBrowser didEndScrollingAtIndex:(NSInteger)index;
- (void)movieBrowser:(VIPBrowser *)movieBrowser didChangeItemAtIndex:(NSInteger)index;

@end

@interface VIPBrowser : UIView

@property (nonatomic, assign, readwrite) id<VIPBrowserDelegate> delegate;
@property (nonatomic, assign, readonly)  NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame VIPDataArr:(NSArray *)vipDataArr currentIndex:(NSInteger)index;


@end
