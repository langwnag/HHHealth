//
//  HHSwitchBtnView.h
//  YiJiaYi
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ViewTapBlock)(NSInteger tag);
@interface HHSwitchBtnView : UIView
@property (nonatomic,copy) ViewTapBlock viewTapBlock;
@end
