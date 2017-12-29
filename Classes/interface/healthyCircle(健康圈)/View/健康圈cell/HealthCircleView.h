//
//  HealthCircleView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DajiaView.h"
@class healthyCircleVC;

@interface HealthCircleView : UIView

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)DajiaView * secondView;//类似朋友圈界面

@property(nonatomic,strong)healthyCircleVC * circleVC;


-(void)changeView;

@end
