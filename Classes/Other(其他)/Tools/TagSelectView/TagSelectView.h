//
//  TagSelectView.h
//  标签选择
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 huanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 屏幕的宽度
 */
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 * 屏幕高度
 */
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@protocol TagSelectViewDelegate <NSObject>

-(void)TagdidSelectTitle:(NSString *)title SelectIndex:(NSInteger)index;
@end

@interface TagSelectView : UIView

/** 当VC中底部视图的左间距在不是0（非.leftSpaceToView(self.view,0)
）的时候设置，外界控制的底部视图title_View宽度 ,默认值0*/
@property (nonatomic,assign) CGFloat viewWidth;

@property(nonatomic,weak)id<TagSelectViewDelegate>delegate;

-(void)setUpTitleArray:(NSMutableArray *)titleArray;

-(void)reloadViewData;

@end
