//
//  HealthRecordsBtn.m
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//
#define SZR_NewNavColor RGBCOLOR(28,110,110)
#define Button_HEIGHT 30
#define Button_WIDTH 120


#import "HealthRecordsBtn.h"

@interface HealthRecordsBtn ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * archivesArr;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UILabel* slideLa;

@property(nonatomic,assign)CGFloat frameWidth;
@property(nonatomic,assign)CGFloat frameHeight;


@end
@implementation HealthRecordsBtn
- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        self.backgroundColor = SZR_NewNavColor;
        self.archivesArr = [NSMutableArray arrayWithObjects:@"个人资料",@"体检报告",nil];
        self.frameWidth = frame.size.width;
        self.frameHeight = frame.size.height;
    }
    return self;
}

- (void)createAchivesUI{
    self.backgroundColor = [UIColor whiteColor];
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;

    [self createSVLabel];
    
//    CGFloat leftSpace = self.frameWidth == 320 ? 50 : 45;

    for (int i = 0; i < self.archivesArr.count; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        float gap = (self.frameWidth - Button_WIDTH*2)/3;
        // gap 是最左侧的宽度，如果i=0；第一个就别成 gap + i*(Button_WIDTH + gap)
        btn.frame = CGRectMake(gap + i*(Button_WIDTH + gap), 0, Button_WIDTH, Button_HEIGHT);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 100+i;
        [btn setTitle:[NSString stringWithFormat:@"%@",self.archivesArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(OrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:SZR_NewNavColor forState:UIControlStateNormal];
        [self addSubview:btn];
        
        if (i == self.selecteIndex) {
            self.slideLa.centerX = btn.centerX;
        }
        
    }
    
    [self bringSubviewToFront:self.slideLa];
    self.contentSize = CGSizeMake(2* SZRScreenWidth, 30);
    NSString* str = self.archivesArr[0];
    if (self.initialStrBlock) {
        self.initialStrBlock(str);
    }
}
#pragma mark 创建ScrollView下面滑动的条
-(void)createSVLabel{
    
    self.slideLa = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frameHeight-3, 130, 3)];
    self.slideLa.backgroundColor = SZR_NewNavColor;
    [self addSubview:self.slideLa];
    
}

#pragma mark 点击button响应事件

-  (void)OrderBtn:(UIButton* )btn{
    
    CGPoint  btnCenter = btn.center;
    [UIView animateWithDuration:0.5 animations:^{
        self.slideLa.centerX = btnCenter.x;
    }];
    
    //传值
    if ([self.Tagdelegate respondsToSelector:@selector(HealthRecordsBtnDidClickedName:)]) {
        
        [self.Tagdelegate HealthRecordsBtnDidClickedName:btn.titleLabel.text];
    }
    
}


















@end
