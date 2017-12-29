//
//  HHSwitchBtnView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//
#define PCH_Button_WIDTH 80
#define PCH_Button_HEIGHT 20

#import "HHSwitchBtnView.h"
@interface HHSwitchBtnView ()
/** 图标 */
@property(nonatomic,copy)NSArray * iconArr;
/** 文字 */
@property(nonatomic,copy)NSArray * titleArr;

@end
@implementation HHSwitchBtnView
{
    UIButton* _switchBtn;
    UILabel* _titleLa;
}
- (NSArray *)iconArr{
    if (!_iconArr) {
        _iconArr = @[@"play",@"play",@""];
    }
    return _iconArr;
}

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"食材准备",@"制作步骤",@""];
    }
    return _titleArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    for (int i = 0; i < self.iconArr.count; i++) {
        UIView* bottomView = [[UIView alloc] init];
        float gap = (self.bounds.size.width - PCH_Button_WIDTH* 3)/4;
        bottomView.frame = CGRectMake(gap + i%3*(PCH_Button_WIDTH + gap) , 5, PCH_Button_WIDTH, PCH_Button_HEIGHT);
        bottomView.tag = 100+i;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTap:)];
        [bottomView addGestureRecognizer:tap];
        [self addSubview:bottomView];
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchBtn.center = bottomView.center;
        _switchBtn.frame = CGRectMake(0,0, 20, 20);
        [_switchBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.iconArr[i]]] forState:UIControlStateNormal];
        _switchBtn.userInteractionEnabled = NO;
        [bottomView addSubview:_switchBtn];

        _titleLa = [[UILabel alloc] init];
        _titleLa.center = bottomView.center;
        _titleLa.frame = CGRectMake(20, 0, 70, 20);
        _titleLa.text = [NSString stringWithFormat:@"%@",self.titleArr[i]];
        _titleLa.font = [UIFont systemFontOfSize:14];
        _titleLa.textColor = [UIColor whiteColor];
        [bottomView addSubview:_titleLa];
     
    }

}
- (void)bottomViewTap:(UITapGestureRecognizer* )viewTap{

    !self.viewTapBlock ? : self.viewTapBlock(viewTap.view.tag+1);
}


@end
