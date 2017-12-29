//
//  GiftBarrageView.h
//  YiJiaYi
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftBarrageView : UIView
+ (instancetype)giftIcon:(NSString *)giftIcon;
+ (instancetype)giftIcon:(NSString *)giftIcon giftName:(NSString *)giftName;
- (void)startAnimatingCompleted:(void(^)())completed;

@end
