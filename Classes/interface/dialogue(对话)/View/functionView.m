//
//  functionView.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//
#define PCH_Button_HEIGHT 60
#define PCH_Button_WIDTH 60
#define imageArr @[@"onLine",@"familyVister",@"The phone",@"signing"]
#define nameArr @[@"在线问诊",@"上门家访",@"电话咨询",@"签约医生"]

#import "functionView.h"

@implementation functionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubBtn];
    }
    return self;
}

- (CGFloat)addSubBtn{

    for (int i = 0; i < imageArr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        float gap = (SZRScreenWidth - PCH_Button_WIDTH*4)/5;
        btn.frame = CGRectMake(gap + i%4*(PCH_Button_WIDTH + gap), 5, PCH_Button_WIDTH, PCH_Button_HEIGHT);
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fuctionBtns:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        UILabel* fuLa = [[UILabel alloc]init];
        fuLa.frame = CGRectMake(gap + i%4*(PCH_Button_WIDTH + gap), CGRectGetMaxY(btn.frame)-25, PCH_Button_WIDTH, PCH_Button_HEIGHT);
        fuLa.text = [NSString stringWithFormat:@"%@",nameArr[i]];
        fuLa.textColor = [UIColor whiteColor];
        fuLa.font = [UIFont systemFontOfSize:14];
        fuLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fuLa];
        
    }
    return 60;
}
- (void)fuctionBtns:(UIButton* )sender{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag);
    }
    
};


@end
