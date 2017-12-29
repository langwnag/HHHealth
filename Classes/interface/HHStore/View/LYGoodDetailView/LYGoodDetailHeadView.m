//
//  LYGoodDetailHeadView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYGoodDetailHeadView.h"

@interface LYGoodDetailHeadView ()

@property (nonatomic, strong) UIImageView   * bannerView;

@property (nonatomic, strong) UIView        * lineView;

@end

static CGFloat const bannerViewHeight = 210.0f;
static CGFloat const lineViewHeight = 20.0f;

@implementation LYGoodDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        [self setDataWithModel:nil];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.bannerView];
    [self addSubview:self.goodNameLab];
    [self addSubview:self.goodDescLab];
    [self addSubview:self.goodDiscountLab];
    [self addSubview:self.goodOriginalLab];
    [self addSubview:self.lineView];
}

- (void)setDataWithModel:(LYGoodDetailModel *)model{
    [self.bannerView sd_setImageWithURL:[NSURL URLWithString:model.attributeUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
    self.goodNameLab.text = model.name;
    self.goodDescLab.text = model.descriptor;
    self.goodDiscountLab.text = [NSString stringWithFormat:@"%.2lf", model.discountPrice];
    self.goodOriginalLab.attributedText = [self getMiddleLineAttStrWithString:[NSString stringWithFormat:@"%.2lf", model.basicPrice]];
   
   
}

- (NSMutableAttributedString *)getMiddleLineAttStrWithString:(NSString *)string{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string attributes:attribtDic];
    return attStr;
}
#pragma mark - lazy load
- (UIImageView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, bannerViewHeight)];
    }
    return _bannerView;
}

- (UILabel *)goodNameLab{
    if (!_goodNameLab) {
        _goodNameLab = [[UILabel alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(self.bannerView.frame) + 20, self.frame.size.width - 100, 20)];
        _goodNameLab.font = [UIFont systemFontOfSize:15];
        _goodNameLab.textColor = HEXCOLOR(0x444444);
    }
    return _goodNameLab;
}

- (UILabel *)goodDescLab{
    if (!_goodDescLab) {
        _goodDescLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.goodNameLab.frame), CGRectGetMaxY(self.goodNameLab.frame) + 10, CGRectGetWidth(self.goodNameLab.frame), 15)];
        _goodDescLab.font = [UIFont systemFontOfSize:11];
        _goodDescLab.textColor = HEXCOLOR(0x999999);
    }
    return _goodDescLab;
}

- (UILabel *)goodDiscountLab{
    if (!_goodDiscountLab) {
        _goodDiscountLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodNameLab.frame) + 5, CGRectGetMaxY(self.bannerView.frame) + 20, self.frame.size.width - CGRectGetWidth(self.goodNameLab.frame) - 5 - 15, 20)];
        _goodDiscountLab.font = [UIFont systemFontOfSize:18];
        _goodDiscountLab.textColor = HEXCOLOR(0xff6666);
        _goodDiscountLab.textAlignment = NSTextAlignmentRight;
    }
    return _goodDiscountLab;
}

- (UILabel *)goodOriginalLab{
    if (!_goodOriginalLab) {
        _goodOriginalLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodDescLab.frame) + 5, CGRectGetMaxY(self.goodDiscountLab.frame) + 7, self.frame.size.width - CGRectGetWidth(self.goodDescLab.frame) - 5 - 15, 15)];
        _goodOriginalLab.font = [UIFont systemFontOfSize:10];
        _goodOriginalLab.textColor = HEXCOLOR(0x999999);
        _goodOriginalLab.textAlignment = NSTextAlignmentRight;
    }
    return _goodOriginalLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - lineViewHeight, self.frame.size.width , lineViewHeight)];
        _lineView.backgroundColor = HEXCOLOR(0xefeff4);
    }
    return _lineView;
}
@end
