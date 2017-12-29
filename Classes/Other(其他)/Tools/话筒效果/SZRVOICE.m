//
//  SZRVOICE.m
//  YiJiaYi
//
//  Created by XiaDian on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SZRVOICE.h"

#import "SZRTabBarVC.h"
@interface SZRVOICE ()
@property(nonatomic,strong)UILabel *lab;



@property(nonatomic,strong)NSTimer *circleTimer;


/** 录音按钮 */
@property (nonatomic,strong) UIButton* recordBtn;

///** 播放按钮 */
//@property (nonatomic,strong) UIButton* playBtn;

@property(nonatomic,assign)BOOL first;

@end
@implementation SZRVOICE


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        self.secend=0;
        self.lab=[[UILabel alloc]init];
        self.lab.text=@"0s";
        
        //圆环的定时器
        self.circleTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickAnimation:) userInfo:nil repeats:YES];
        //计算时间定时器
         self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(adddsecend:) userInfo:nil repeats:YES];
        
        //添加手势
        [self createGesture];
        
        
        [self getBtn];
    }
    return self;
}
-(void)layoutSubviews{
    self.lab.bounds=CGRectMake(0, 0, self.frame.size.width/4.0, self.frame.size.width*2/5.0);
    self.lab.layer.cornerRadius=self.frame.size.width/8.0;
    self.lab.layer.masksToBounds=YES;
    self.lab.layer.borderColor=[UIColor colorWithRed:88/255.0 green:238/255.0 blue:206/255.0 alpha:1].CGColor;
    self.lab.backgroundColor=[UIColor colorWithRed:88/255.0 green:238/255.0 blue:206/255.0 alpha:1];
    self.lab.center=CGPointMake(self.frame.size.width/2.0,self.frame.size.height-self.frame.size.width*2/10.0-60-20);
    if (self.first==NO) {
        self.lab.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            // 放大
            self.lab.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
        self.first=YES;
    }
    self.lab.textColor=[UIColor whiteColor];
    self.lab.font=[UIFont systemFontOfSize:33];
    self.lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.lab];
}
-(void)adddsecend:(NSTimer *)timer{
    self.secend+=1;
    self.lab.text=[NSString stringWithFormat:@"%zds",self.secend];
}
- (void)clickAnimation:(id)sender{
      [self startAnimation];
}

-(void)createGesture{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelf)];
    [self addGestureRecognizer:tap];
}


- (void)startAnimation{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0,self.bounds.size.width/2.0) radius:self.bounds.size.width/2.0-50 startAngle:-M_PI/4 endAngle:-M_PI*3/4 clockwise:NO];
    layer.path = path.CGPath;
    layer.lineWidth=10;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor=[UIColor colorWithRed:88/255.0 green:238/255.0 blue:206/255.0 alpha:1].CGColor;
    layer.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);;
    layer.position=CGPointMake(self.bounds.size.width/2.0,self.frame.size.height-self.frame.size.width*2/10.0-60-20);
    [self.layer addSublayer:layer];
    
    CABasicAnimation*boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    boundsAnimation.fromValue= [NSNumber numberWithFloat:0.6];
    
    boundsAnimation.toValue= [NSNumber numberWithFloat:1.5];
    
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

-(void)clickSelf{
    [self removeFromSuperview];
}




- (void)removeLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
    
}


-(void)dealloc{
    [self.circleTimer invalidate];
    [self.timer invalidate];

//    [self.recordTool stopPlaying];
//    [self.recordTool stopRecording];


}
//

- (void)getBtn{
    
    //创建录音按钮
    self.recordBtn = [SZRFunction createButtonWithFrame:CGRectMake(SZRScreenWidth/2.0-30, SZRScreenHeight-60, 60, 60) withTitle:nil withImageStr:@"dialogue_selected" withBackImageStr:nil];
    self.recordBtn.userInteractionEnabled = NO;
    
    [self addSubview:self.recordBtn];
    
    

//    self.recordTool.delegate = self;
    
#pragma mark SZR注释
    // 录音按钮
//    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDown) forControlEvents:UIControlEventTouchDown];
//    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    
//    self.playBtn = [SZRFunction createButtonWithFrame:CGRectMake(10, 100, 100, 30) withTitle:@"播放按钮" withImageStr:nil withBackImageStr:nil];
//    self.playBtn.backgroundColor=[UIColor redColor];
//    [self addSubview:self.playBtn];
#pragma mark SZR修改
    
    
    // 播放按钮
//    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
//    
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
