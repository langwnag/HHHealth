//
//  UIView+Extend.m
//  客邦
//
//  Created by SZR on 2016/11/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
