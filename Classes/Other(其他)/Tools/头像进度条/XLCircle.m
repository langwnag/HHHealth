//
//  Circle.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircle.h"

static CGFloat endPointMargin = 1.0f;

@interface XLCircle ()
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    NSTimer * _timer;
    CGFloat _fakeProgress;
    BOOL _noFirstShow;
    
    
}
@end

@implementation XLCircle


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self buildLayout];
    }
    return self;
}


-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    if (!_noFirstShow) {
       [self buildLayout];
        _noFirstShow = YES;
    }
    
}

-(void)buildLayout
{
    _lineWidth = kAdaptedHeight(39.0/4);
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    
    long double startAngle = M_PI/2 + 15.0/140*2*M_PI;
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:startAngle + 2 * M_PI clockwise:YES];
    
    //添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = HEXCOLOR(0xd6fff7).CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[HEXCOLOR(0xffffcc) CGColor],(id)[HEXCOLOR(0x21d5af) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
//    [_progressLayer removeAllAnimations];
//    _fakeProgress = 0;
 
    
}

-(void)setProgress:(float)progress
{
    SZRLog(@"progress = %.2f",progress);
    _progress = progress;
    _fakeProgress = 0;
    _progressLayer.strokeEnd = 0;
    [_progressLayer removeAllAnimations];
    [self updateProgress];
}


-(void)updateProgress{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerSelector:) userInfo:nil repeats:YES];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (_fakeProgress >= _progress) {
//            _fakeProgress = _progress;
//            _progressLayer.strokeEnd = _fakeProgress/1.4;
//            
//            if (timer) {
//                [timer invalidate];
//                timer = nil;
//            }
//            return;
//        }
//        _fakeProgress += 0.01;
//        _progressLayer.strokeEnd = _fakeProgress/1.4;
//
//    }];
    
}


-(void)timerSelector:(NSTimer *)timer{
    if (_fakeProgress >= _progress) {
        _fakeProgress = _progress;
        _progressLayer.strokeEnd = _fakeProgress/1.4;
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        return;
    }
    _fakeProgress += 0.01;
    _progressLayer.strokeEnd = _fakeProgress/1.4;
}

//-(void)removeAnimation:(NSNotification *)noti{
//    _fakeProgress = 0;
//    _progressLayer.strokeEnd = 0;
//    [_progressLayer removeAllAnimations];
//}



@end
