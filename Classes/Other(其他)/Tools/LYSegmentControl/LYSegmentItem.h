//
//  LYSegmentItem.h
//  LYScrollView
//
//  Created by Mr.Li on 2017/6/28.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSegmentItem : UIView

@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * backgroundColor;
/** title */
@property (nonatomic, strong) NSString * title;
/** 是否选中 */
@property (nonatomic, assign) BOOL selected;

@end
