//
//  NowLocationVC.h
//  YiJiaYi
//
//  Created by SZR on 2017/5/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface NowLocationVC : BaseVC

@property(nonatomic,strong)AMapPOI * oldPOI;
@property(nonatomic,copy)void (^POIBlock)(AMapPOI * POI);

@end
