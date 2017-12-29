//
//  SZRRipple.h
//  YiJiaYi
//
//  Created by XiaDian on 16/6/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SkipVCBlock)(NSTimer *,NSTimer *);

@interface SZRRipple : UIView

@property(nonatomic,copy)SkipVCBlock skipVCBlock;


@end
