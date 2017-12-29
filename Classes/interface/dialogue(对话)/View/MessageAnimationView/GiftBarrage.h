//
//  GiftBarrage.h
//  YiJiaYi
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftBarrageView.h"
@interface GiftBarrage : NSObject
- (instancetype)initBarrageToView:(UIView* )toView;

- (void)addBarrageItem:(GiftBarrageView *)barrageItem;
- (void)startBarrage;
- (void)stopBarrage;

@end
