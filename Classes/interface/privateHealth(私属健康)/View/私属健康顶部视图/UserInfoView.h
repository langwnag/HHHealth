//
//  UserInfoView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLCircle;

@interface UserInfoView : UIView

@property(nonatomic,copy)NSString * headImageStr;
@property(nonatomic,assign)CGFloat healthValue;
@property(nonatomic,assign)NSInteger vipLevel;
@property(nonatomic,assign)BOOL isNotification;

@property(nonatomic,strong)UIImageView * headImageV;
@property(nonatomic,strong)UIImageView * vipImageV;
@property(nonatomic,strong)XLCircle * healthValueProgress;

/** 健康值 */
@property (nonatomic,strong) UILabel* healthValueLa;

/** 健康状况 */
@property (nonatomic,strong) NSString* healthStr;
/** 健康值 */
@property (nonatomic,assign) int healthValueStr;
/** 日期 */
@property (nonatomic,copy) NSString* dateStr;


-(void)createUI;

-(void)updateData;
@end
