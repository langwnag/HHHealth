//
//  SZRRipple.m
//  YiJiaYi
//
//  Created by XiaDian on 16/6/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SZRRipple.h"
@interface SZRRipple ()
@property(nonatomic,strong)UILabel *lab;
//秒数lable
@property(nonatomic,assign)NSInteger secend;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSTimer *circleTimer;
@end
@implementation SZRRipple
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.secend=6;
        self.lab=[[UILabel alloc]init];
        self.lab.text=@"6s";
        UIImage* image = [UIImage imageNamed:@"bg.png"];
        self.layer.contents = (id)image.CGImage;
        self.circleTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickAnimation:) userInfo:nil repeats:YES];
        }
    return self;
}
-(void)layoutSubviews{
    self.lab.bounds=CGRectMake(0, 0, self.frame.size.width/3.0, self.frame.size.width/3.0);
    self.lab.layer.borderWidth=20;
    //中心圆圈
    self.lab.layer.cornerRadius=self.frame.size.width/6.0;
    self.lab.layer.masksToBounds=YES;
    self.lab.layer.borderColor=[UIColor colorWithRed:88/255.0 green:238/255.0 blue:206/255.0 alpha:1].CGColor;
    self.lab.backgroundColor=[UIColor colorWithRed:18/255.0 green:97/255.0 blue:97/255.0 alpha:1];
    self.lab.center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    if (!self.timer) {
       self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(adddsecend:) userInfo:nil repeats:YES];
    }
    self.lab.textColor=[UIColor colorWithRed:88/255.0 green:238/255.0 blue:206/255.0 alpha:1];
    self.lab.font=[UIFont systemFontOfSize:33];
    self.lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.lab];
}
-(void)adddsecend:(NSTimer *)timer{
    if (self.secend == 0) {
        //跳转界面
        self.skipVCBlock(self.timer,self.circleTimer);
        return;
    }
    self.secend-=1;
    self.lab.text=[NSString stringWithFormat:@"%zds",self.secend];
}
- (void)clickAnimation:(id)sender{
    [self startAnimation];
}
- (void)startAnimation{
    
    CALayer*layer = [CALayer layer];
    layer.frame=CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width);
    layer.cornerRadius= [UIScreen mainScreen].bounds.size.width/2;
    layer.position=self.layer.position;
    layer.borderColor=SZRNAVIGATION.CGColor;
    layer.borderWidth=3;
    [self.layer addSublayer:layer];
    
    
    CABasicAnimation*boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    boundsAnimation.fromValue= [NSNumber numberWithFloat:0];
    
    boundsAnimation.toValue= [NSNumber numberWithFloat:1];
    
    boundsAnimation.removedOnCompletion=YES;
    
    boundsAnimation.duration=3.0;
    
    
    CABasicAnimation*opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue= [NSNumber numberWithFloat:1];
    
    opacityAnimation.toValue= [NSNumber numberWithFloat:0];
    
    opacityAnimation.removedOnCompletion=YES;
    
    opacityAnimation.duration=3.0;
    
    
    CAAnimationGroup*group = [CAAnimationGroup animation];
    
    group.animations=@[boundsAnimation, opacityAnimation];
    
    group.duration=3.0;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [layer addAnimation:group forKey:@"xiuyixiu"];
    
    [self performSelector:@selector(removeLayer:)withObject:layer afterDelay:3];
    
}
- (void)removeLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
    
}


-(void)releaseTimer{
    [self.timer invalidate];
    [self.circleTimer invalidate];
    self.timer = nil;
    self.circleTimer = nil;
}


@end
