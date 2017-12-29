//
//  LYCountTime.m
//  IHealth_V2
//
//  Created by Mr Li on 16/11/9.
//  Copyright © 2016年 zhengmeijie. All rights reserved.
//

#import "LYCountTime.h"

@implementation LYCountTime

- (void)countTimeWithBtn:(UIButton *)btn{
    
    __weak LYCountTime * weakSelf = self;
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf sendCodeButtonIsClick:YES btn:btn];
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"发送验证码"];
                [btn setAttributedTitle:title forState:UIControlStateNormal];
            });
        }else{
            NSInteger seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf sendCodeButtonIsClick:NO btn:btn];
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld 秒后重发", seconds]];
                [btn setAttributedTitle:title forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 发送验证码按钮是否可以点击
- (void)sendCodeButtonIsClick:(BOOL)isClick btn:(UIButton *)btn{
    
    if (btn.enabled != isClick) {
        btn.enabled = isClick;
        [btn setBackgroundColor:(isClick ? [UIColor orangeColor] : [UIColor lightGrayColor])];
    }
}

#pragma mark - 单例
+ (LYCountTime*)shareCountTime{
    
    static LYCountTime *countTime = nil;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        countTime = [[LYCountTime alloc]init];
    });
    return countTime;
}


@end
