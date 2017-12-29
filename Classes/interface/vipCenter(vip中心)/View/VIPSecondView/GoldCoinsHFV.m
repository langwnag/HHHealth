//
//  GoldCoinsHFV.m
//  YiJiaYi
//
//  Created by mac on 2017/3/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GoldCoinsHFV.h"

@implementation GoldCoinsHFV
{
    UILabel* _nameLa;
    UILabel* _moneyLa;
    UIImageView* _iconImg;
    UIButton* _coinsBtn;
    UIView* _botView;
    UILabel* _desLa;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [SZRFunction SZRSetLayerImage:self imageStr:@"topUp_BG"];

    _nameLa = [SZRFunction createLabelWithFrame:CGRectNull color:HEXCOLOR(0xffffff) font:[UIFont systemFontOfSize:kAdaptedHeight(28/2)] text:@"当前合合币"];
    [self addSubview:_nameLa];
    
    _iconImg = [SZRFunction createImageViewFrame:CGRectNull imageName:@"qe" color:nil];
    [self addSubview:_iconImg];
    
    _moneyLa = [UILabel new];
    _moneyLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:@"2000元" withSubStr:@"2000" withColor:HEXCOLOR(0xffffff) withFont:[UIFont systemFontOfSize:kAdaptedHeight(100/2)]];
    _moneyLa.textColor =HEXCOLOR(0xffffff);
    _moneyLa.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLa];
    
    _coinsBtn = [SZRFunction createButtonWithFrame:CGRectNull withTitle:@"我要充值 >" withImageStr:@"" withBackImageStr:@""];
    [_coinsBtn addTarget:self action:@selector(payCoins:) forControlEvents:UIControlEventTouchUpInside];
    _coinsBtn.titleLabel.font = [UIFont systemFontOfSize:kAdaptedHeight(28/2)];
    _coinsBtn.layer.cornerRadius = 5.0f;
    _coinsBtn.layer.masksToBounds = YES;
    _coinsBtn.layer.borderWidth = 1.0f;
    _coinsBtn.layer.borderColor = HEXCOLOR(0xffffff).CGColor;
    [self addSubview:_coinsBtn];
    
    _botView = [UIView new];
    _botView.backgroundColor = HEXCOLOR(0xefeff4);
    [self addSubview:_botView];

    _desLa = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_6 font:[UIFont systemFontOfSize:kAdaptedHeight(28/2)] text:@"交易明细"];
    [_botView addSubview:_desLa];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kAdaptedWidth(20/2));
        make.top.mas_equalTo(kAdaptedHeight(28/2));
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(300/2), kAdaptedHeight(21)));
    }];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kAdaptedWidth(20/2));
        make.top.equalTo(_nameLa.mas_top);
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(32/2), kAdaptedHeight(32/2)));
    }];
    [_moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAdaptedHeight(133/2));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(200), kAdaptedHeight(45)));
    }];
    [_coinsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLa.mas_bottom).offset(kAdaptedHeight(88/2));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(172/2), kAdaptedHeight(56/2)));
    }];
    [_botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SZRScreenWidth, kAdaptedHeight(45)));
    }];
    [_desLa mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(kAdaptedWidth(20/2));
        make.centerY.equalTo(_botView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kAdaptedWidth(200/2), kAdaptedHeight(21)));
    }];
    
}
- (void)payCoins:(UIButton* )btn{
    if (self.skipPayBlock) {
        self.skipPayBlock();
    }
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
