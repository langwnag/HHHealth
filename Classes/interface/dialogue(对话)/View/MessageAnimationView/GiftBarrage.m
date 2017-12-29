//
//  GiftBarrage.m
//  YiJiaYi
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GiftBarrage.h"
#import "GiftBarrageView.h"
#define TrackOne @"TrackOne"
#define TrackTwo @"TrackTwo"
@interface GiftBarrage ()
@property (nonatomic,weak) UIView* topView;
@property (nonatomic,strong) NSMutableArray* barrageArray;
@property (nonatomic,strong) NSMutableDictionary* trackDict;
@property (nonatomic,strong) NSTimer* timer;


@end
@implementation GiftBarrage
- (instancetype)initBarrageToView:(UIView *)toView{
    if (self = [super init]) {
        _topView = toView;
        _barrageArray = [NSMutableArray array];
        _trackDict = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)addTimer{
    if (_timer) [self removeTimer];
        
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(postBarrage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)postBarrage{
    if (_barrageArray.count == 0) return;
    if (_trackDict.allKeys.count == 2) return;
    GiftBarrageView* item = _trackDict[TrackOne];
    if (!item) {
        GiftBarrageView* item = [_barrageArray firstObject];
        [_barrageArray removeObjectAtIndex:0];
        [_trackDict setObject:item forKey:TrackOne];
        item.y = -item.height;
        item.centerX = SZRScreenWidth/2;
        [_topView addSubview:item];
        [item startAnimatingCompleted:^{
            [_trackDict removeObjectForKey:TrackOne];
        }];

    }
    if (_barrageArray.count == 0) return;
    GiftBarrageView* item2 = _trackDict[TrackOne];
    if (!item2) {
        GiftBarrageView*item = [_barrageArray firstObject];
        [_barrageArray removeObjectAtIndex:0];
        [_trackDict setObject:item forKey:TrackTwo];
        item.y = -item.height;
        item.centerX = SZRScreenWidth/2;
        [_topView addSubview:item];
        [item startAnimatingCompleted:^{
            [_trackDict removeObjectForKey:TrackTwo];
        }];
    }
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)addBarrageItem:(GiftBarrageView *)barrageItem{
    [_barrageArray addObject:barrageItem];
}
- (void)startBarrage{
    [self addTimer];
}
- (void)stopBarrage{
    [self removeTimer];
}












@end
