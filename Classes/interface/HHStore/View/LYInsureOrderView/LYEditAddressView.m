//
//  LYEditAddressView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYEditAddressView.h"

@interface LYEditAddressView ()

@property (nonatomic, strong) UILabel * addressLab;

@end

@implementation LYEditAddressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.addressLab];
    }
    return self;
}

- (UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width - 30, self.frame.size.height - 20)];
        _addressLab.textColor = HEXCOLOR(0x666666);
        _addressLab.font = [UIFont systemFontOfSize:14];
        _addressLab.textAlignment = NSTextAlignmentCenter;
        _addressLab.userInteractionEnabled = YES;
        _addressLab.attributedText = [self getAddressLabAttTextWithString:@"请添加收货地址"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAddressLab:)];
        [_addressLab addGestureRecognizer:tap];
    }
    return _addressLab;
}

- (void)tapOnAddressLab:(UILabel *)lab{
    if ([self.delegate respondsToSelector:@selector(clickAddressView:)]) {
        [self.delegate clickAddressView:lab];
    }
}

- (NSMutableAttributedString *)getAddressLabAttTextWithString:(NSString *)str{
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attach.image = [UIImage imageNamed:@"1111111"];
        attach.bounds = CGRectMake(-5, -5, 20, 20);
    NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString * mutableAtt = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableAtt insertAttributedString:attStr atIndex:0];
    return mutableAtt;

}
@end
