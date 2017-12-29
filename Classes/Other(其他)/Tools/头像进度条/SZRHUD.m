//
//  SZRHUD.m
//  SZRHUD
//
//  Created by XiaDian on 16/6/21.
//  Copyright © 2016年 vdchina. All rights reserved.
//

#import "SZRHUD.h"
@interface SZRHUD ()

//进度条定时器
@property(nonatomic,strong)NSTimer*timer;
//多长时间一步
@property(nonatomic,assign)CGFloat step;

@property(nonatomic,assign)CGFloat sumSteps;


@end

@implementation SZRHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endProgress=1.0;
        self.backgroundColor=[UIColor clearColor];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
//    self.step = (CGFloat)SZRANIMATIONTIME/(self.endProgress*M_PI*self.bounds.size.width);
    
    self.step = (CGFloat)SZRANIMATIONTIME/(M_PI*self.bounds.size.width);

    //贝塞尔曲线画出进度线
    [self getProgressView];
    
}
/**
 *  获取进度条View
 */
-(void)getProgressView{
    CAShapeLayer *layer = [CAShapeLayer layer];
    long double startAngle = M_PI/2 + 1.0/9*2*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0) radius:self.bounds.size.width/2.0 startAngle:startAngle endAngle:startAngle+100.0/130*2*M_PI*self.endProgress clockwise:YES];
    layer.path = path.CGPath;
    layer.lineWidth=SZRLINEWIDTH;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor =SZRHUDCOLOR.CGColor;
    [self.layer addSublayer:layer];
   
    
}

-(void)endProgress:(CGFloat)progress{
    _endProgress = progress;
    [self setNeedsDisplay];
}

/**
 *  添加基本动画
 *
 *  @param layer
 *  @param duration
 */
- (void)addAnimation:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration=duration;
    [layer addAnimation:animation forKey:nil];
}



@end
