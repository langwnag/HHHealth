//
//  LYSegmentControl.h
//  LYScrollView
//
//  Created by Mr.Li on 2017/7/11.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYSegmentControlDelegate <NSObject>

- (void)lySegmentControlSelectAtIndex:(NSInteger)index;

@end

@interface LYSegmentControl : UIView

/** title */
@property (nonatomic, strong) NSArray * titleArr;
/** 选中位置 */
@property (nonatomic, assign) NSInteger selectedIndex;

/** 显示顶部线 默认显示*/
@property (nonatomic, assign) BOOL showTopline;
/** 是否显示底部线 默认显示*/
@property (nonatomic, assign) BOOL showBottomLine;

/** 代理 */
@property (nonatomic, assign) id<LYSegmentControlDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arr;

@end
