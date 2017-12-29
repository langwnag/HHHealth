//
//  SZRVOICE.h
//  YiJiaYi
//
//  Created by XiaDian on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RefreshBtnBlock)(void);

@interface SZRVOICE : UIView
@property(nonatomic,strong)UIViewController *dd;

@property(nonatomic,copy)RefreshBtnBlock  refreshBtnBlock;
//计时的定时器
@property(nonatomic,strong)NSTimer *timer;
//秒数lable
@property(nonatomic,assign)NSInteger secend;


@end
