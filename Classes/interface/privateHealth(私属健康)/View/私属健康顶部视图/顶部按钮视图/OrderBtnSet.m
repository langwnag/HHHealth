



//
//  OrderBtnSet.m
//  客邦
//
//  Created by 莱昂纳德 on 16/8/12.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#define Button_HEIGHT 30
#define Button_WIDTH 50


#import "OrderBtnSet.h"
@interface OrderBtnSet ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UILabel* slideLa;

@property(nonatomic,assign)CGFloat frameWidth;
@property(nonatomic,assign)CGFloat frameHeight;


@end
@implementation OrderBtnSet
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArr = [NSMutableArray arrayWithObjects:@"心率",@"血压",@"血氧",@"呼吸",@"计步", nil];
        self.frameWidth = frame.size.width;
        self.frameHeight = frame.size.height;
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = SZR_NewNavColor;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    
    [self createSVLabel];
   
    CGFloat leftSpace = self.frameWidth == 320 ? 20 : 40;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        float gap = (self.frameWidth - Button_WIDTH*5 - leftSpace*2)/4;
        btn.frame = CGRectMake(leftSpace + i*(Button_WIDTH + gap), 0, Button_WIDTH, Button_HEIGHT);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 100+i;
        [btn setTitle:[NSString stringWithFormat:@"%@",self.dataArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(OrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:btn];

        if (i == 0) {
            self.slideLa.centerX = btn.centerX;
        }
        
    }
    
    [self bringSubviewToFront:self.slideLa];
    self.contentSize = CGSizeMake(SZRScreenWidth, 30);
    NSString * str = self.dataArr[0];
    self.initialStrBlock(str);
}

#pragma mark 创建ScrollView下面滑动的条
-(void)createSVLabel{

    self.slideLa = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frameHeight-3, 40, 3)];
    self.slideLa.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.slideLa];

}

#pragma mark 点击button响应事件
-  (void)OrderBtn:(UIButton* )btn{
    
    CGPoint  btnCenter = btn.center;
    [UIView animateWithDuration:0.5 animations:^{
        self.slideLa.centerX = btnCenter.x;
    }];
    
   //传值
    if ([self.Tagdelegate respondsToSelector:@selector(OrderBtnSet:)]) {
    
        [self.Tagdelegate OrderBtnSet:btn.titleLabel.text];

    }
    
}

@end
