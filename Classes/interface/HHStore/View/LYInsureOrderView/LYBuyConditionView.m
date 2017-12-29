//
//  LYBuyConditionView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYBuyConditionView.h"
#import "LYNumSelectView.h"
#import "LYFunctionMenuView.h"
#import "LYNumSelectView.h"

@interface LYBuyConditionView ()<LYFunctionMenuViewDelegate>

@property (nonatomic, strong) UIImageView * goodImageView;
@property (nonatomic, strong) UILabel * goodNameLab;
@property (nonatomic, strong) UILabel * goodPriceLab;
@property (nonatomic, strong) UILabel * goodNumLab;
@property (nonatomic, strong) UIView * topLineView;
@property (nonatomic, strong) LYFunctionMenuView * numView;
@property (nonatomic, strong) LYNumSelectView * selectView;
@property (nonatomic, strong) UIView * bottomLineView;
@property (nonatomic, strong) LYFunctionMenuView * couponView;
@property (nonatomic, strong) UILabel * rightLab;

@end

@implementation LYBuyConditionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.goodImageView];
    [self addSubview:self.goodNameLab];
    [self addSubview:self.goodPriceLab];
    [self addSubview:self.topLineView];
    [self addSubview:self.numView];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.couponView];
}

- (UIImageView *)goodImageView{
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20, 150, 60)];
        _goodImageView.image = [UIImage imageNamed:@"999"];
    }
    return _goodImageView;
}

- (UILabel *)goodNameLab{
    if (!_goodNameLab) {
        _goodNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodImageView.frame) + 20, CGRectGetMinY(self.goodImageView.frame) + 10, self.frame.size.width - 18 - CGRectGetWidth(self.goodImageView.frame) - 20 - 15, 20)];
        _goodNameLab.font = [UIFont systemFontOfSize:15];
        _goodNameLab.textColor = HEXCOLOR(0x444444);
        _goodNameLab.text = @"合合智能手表";
    }
    return _goodNameLab;
}

- (UILabel *)goodPriceLab{
    if (!_goodPriceLab) {
        _goodPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.goodNameLab.frame), CGRectGetMaxY(self.goodNameLab.frame) + 10, CGRectGetWidth(self.goodNameLab.frame), 10)];
        _goodPriceLab.textColor = HEXCOLOR(0x444444);
        _goodPriceLab.font = [UIFont systemFontOfSize:12];
        _goodPriceLab.text = @"￥1999.00";
    }
    return _goodPriceLab;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodImageView.frame) + 20, self.frame.size.width, 1)];
        _topLineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _topLineView;
}

- (LYFunctionMenuView *)numView{
    if (!_numView) {
        _numView = [[LYFunctionMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLineView.frame), self.frame.size.width, 50)];
        _numView.title = @"数量";
        _numView.rightView = self.selectView;
        _numView.tag = 1001;
    }
    return _numView;
}

- (LYNumSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[LYNumSelectView alloc] initWithFrame:CGRectMake(0, 0, 100, 50) currentNum:2 maxNum:19];
    }
    return _selectView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numView.frame), self.frame.size.width, 0.5)];
        _bottomLineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _bottomLineView;
}

- (LYFunctionMenuView *)couponView{
    if (!_couponView) {
        _couponView = [[LYFunctionMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomLineView.frame), self.frame.size.width, 50)];
        _couponView.delegate = self;
        _couponView.title = @"优惠券";
        _couponView.rightView = self.rightLab;
        _couponView.tag = 1002;
    }
    return _couponView;
}

- (UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, 50)];
        _rightLab.textColor = HEXCOLOR(0x05cfaa);
        _rightLab.font = [UIFont systemFontOfSize:16];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.attributedText = [self getAddressLabAttTextWithString:@"合合通用券50元 "];
    }
    return _rightLab;
}

- (NSMutableAttributedString *)getAddressLabAttTextWithString:(NSString *)str{
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attach.image = [UIImage imageNamed:@"1111111"];
    attach.bounds = CGRectMake(5, -5, 20, 20);
    NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString * mutableAtt = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableAtt insertAttributedString:attStr atIndex:str.length];
    return mutableAtt;
}

- (void)tapOnFunctionMenuView{
    NSLog(@"tapOnFunctionMenuView");
}

@end
