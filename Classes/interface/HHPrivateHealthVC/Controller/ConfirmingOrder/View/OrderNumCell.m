//
//  OrderNumCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderNumCell.h"

@implementation OrderNumCell
{
    UIView* _lastView;
    UILabel* _numLa;
    UIButton* _minusBtn;
    UIButton* _addBtn;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _lastView = [UIView new];
        _lastView.backgroundColor = HEXCOLOR(0xefeff4);
        
        _numLa = [UILabel new];
        _numLa.text = @"数量";
        kLabelThinLightColor(_numLa, kAdaptedWidth_2(30), HEXCOLOR(0x444444));
        
        self.TF = [UITextField new];
        self.TF.textAlignment = NSTextAlignmentCenter;
        self.TF.keyboardType = UIKeyboardTypeNumberPad;
        self.TF.text = @"1";
        
        _minusBtn = [UIButton new];
        [_minusBtn setImage:IMG(@"minusBtn") forState:UIControlStateNormal];
        [_minusBtn addTarget:self action:@selector(minusClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _addBtn = [UIButton new];
        [_addBtn setImage:IMG(@"addBtn") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView sd_addSubviews:@[_lastView,_numLa,_minusBtn,_TF,_addBtn]];
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .heightIs(.8);
        
        _numLa.sd_layout
        .leftSpaceToView(self.contentView,kAdaptedWidth_2(33))
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(136))
        .heightIs(kAdaptedHeight_2(29));
        
        _minusBtn.sd_layout
        .rightSpaceToView(self.contentView,kAdaptedWidth_2(150))
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(27))
        .heightEqualToWidth();

        _TF.sd_layout
        .leftSpaceToView(_minusBtn,1)
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(93))
        .heightIs(kAdaptedHeight_2(27));

       _addBtn.sd_layout
        .leftSpaceToView(self.TF,1)
        .centerYEqualToView(self.contentView)
        .widthIs(kAdaptedWidth_2(27))
        .heightEqualToWidth();
        
    }
    return self;
}

- (void)setNumtest:(NSInteger)numtest{
    _numtest = numtest;
    self.TF.text = [NSString stringWithFormat:@"%ld",(long)numtest];

}

- (void)minusClickBtn:(UIButton* )minusBtn{
    SZRLog(@"减号");
    NSInteger num = [self.TF.text integerValue];
    if (num > 1) {
        // textField里的值减1
        self.TF.text = [NSString stringWithFormat:@"%ld",num-1];
    }else{
        [MBProgressHUD showTextOnly:@"订购数量必须为大于等于1的整数"];
    }

}

- (void)addClickBtn:(UIButton* )addBtn{
    SZRLog(@"加号");
    NSInteger num = [self.TF.text integerValue];
    if (num < 99) {
        self.TF.text = [NSString stringWithFormat:@"%ld",num+1];
    }else{
        [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"最大可购买量为%d",99]];
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.TF.text integerValue] == 1) {
        self.TF.text = @"1";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldNoti:) name:UITextFieldTextDidChangeNotification object:nil];
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.TF.text isEqualToString:@""]) {
        self.TF.text = @"";
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldNoti:(NSNotification* )noti{
    if ([self.TF.text integerValue] > 99 ) {
        [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"最大可购买量为%d",99]];
        self.TF.text = [NSString stringWithFormat:@"%d",99];
        
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 只允许输入数字
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location !=NSNotFound) {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
