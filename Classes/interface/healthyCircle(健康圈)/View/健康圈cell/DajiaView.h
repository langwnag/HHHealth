//
//  DajiaView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HealthCircleModel.h"
@class healthyCircleVC;

typedef void(^HHPassVCBlock)(NSInteger userId, NSString * nickName);

@interface DajiaView : UIView

@property(nonatomic,strong)healthyCircleVC * circleVC;

//-(void)showTextfield;
//-(void)removeTextfield;


-(void)reloadCircleData:(NSMutableArray *)circleID;
@property (nonatomic,copy) void (^passVCBlock)(NSNumber* userId, NSString * name);
@property (nonatomic, copy) HHPassVCBlock passVcBlock;

@end
