//
//  VDAlertView.m
//  客邦
//
//  Created by SZR on 16/4/8.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "VDAlertView.h"

@interface VDAlertView ()
//标题
@property(nonatomic,copy)NSString * title;
//btn的title数组
@property (nonatomic,strong) NSArray * btnTitleArr;
//阴影视图
@property (nonatomic,strong) UIView * shadeView;
//内容视图
@property (nonatomic,strong) UIView * contentView;
//宽度
@property (nonatomic,assign) CGFloat viewWidth;



@end

@implementation VDAlertView

- (instancetype)initWithTitle:(NSString *)title delegate:(id<VDAlertViewDelegate>)delegate btnTitles:(NSArray *)btnTitles{
    if (self = [super initWithFrame:SZRScreenBounds]) {
        //初始化数据
        self.title = title;
        self.btnTitleArr = [NSArray arrayWithArray:btnTitles];
        
        self.backgroundColor = [UIColor clearColor];
        //创建阴影视图
        [self createShadeView];
        self.delegate = delegate;
        [self initContentView];
    }
    return self;
}
//创建阴影视图
- (void)createShadeView{
    self.shadeView = [[UIView alloc]initWithFrame:self.frame];
    self.shadeView.backgroundColor = [UIColor blackColor];
    self.shadeView.alpha = 0.6;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picTapDown)];
    //手势添加到图片上
    [self.shadeView addGestureRecognizer:tap];
    [self addSubview:self.shadeView];
}
- (void)picTapDown{
    [self removeFromSuperview];
}

//创建视图控件
- (void)initContentView{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(30, 150, SZRScreenWidth-30*2, 122)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //居中显示
    self.contentView.center = CGPointMake(self.centerX, self.centerY-64);
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
    self.viewWidth = self.contentView.frame.size.width;
    //创建标题
    [self createTitle];
    //创建底部button
    [self createBtn];
}

//创建标题
- (void)createTitle{
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, self.viewWidth, 40) color:SZRAPPCOLOR font:[UIFont systemFontOfSize:15] text:self.title];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    //创建下边的分界线
    UILabel * sideLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.viewWidth, 1)];
    sideLabel.backgroundColor = SZRAPPCOLOR;
    [self.contentView addSubview:sideLabel];
}
//创建button
- (void)createBtn{
    UIButton * btn1 = [SZRFunction createButtonWithFrame:CGRectMake(0, 41, self.viewWidth, 40) withTitle:self.btnTitleArr[0] withImageStr:nil withBackImageStr:nil];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn1];
    //创建中间的分界线
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 81, self.viewWidth, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    
    //创建下面的btn
    UIButton * btn2 = [SZRFunction createButtonWithFrame:CGRectMake(0, 82, self.viewWidth, 40) withTitle:self.btnTitleArr[1] withImageStr:nil withBackImageStr:nil];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn2];
}

//点击btn响应事件
- (void)btnClick:(UIButton *)btn{
    //如果代理非空 且 代理实现了这个方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:[self.btnTitleArr indexOfObject:btn.titleLabel.text]];
    }
    [self hide];
}
//视图显示
- (void)show{
    UIViewController * VC = (UIViewController *)self.delegate;
    NSLog(@"%@",VC);
    [self addSubview:self.contentView];
    [VC.view addSubview:self];
}


//视图消失
- (void)hide{
    [self removeFromSuperview];
}


@end
