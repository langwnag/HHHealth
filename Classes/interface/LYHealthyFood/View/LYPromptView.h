//
//  LYPromptView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

typedef void(^LYBecomeMemberBlcok)(NSString * price, NSString * title);
@interface LYPromptView : UIView

@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, copy) LYBecomeMemberBlcok becomeMemberBlock;

+ (LYPromptView *)sharePromptView;

- (void)dismiss;

@end
