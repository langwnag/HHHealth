//
//  ServiceTimesCell.m
//  YiJiaYi
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ServiceTimesCell.h"

@implementation ServiceTimesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _serviceTimesLa.font = kLightFont(k6PFontAdaptedWidth(14));
    _numTextField.font = _serviceTimesLa.font;
    _numTextField.delegate = self;
    
    UIView * contentView = self.contentView;
    _serviceTimesLa.sd_layout
    .leftSpaceToView(contentView,k6P_3AdaptedWidth(82.0))
    .widthIs(k6P_3AdaptedWidth(175.0))
    .centerYEqualToView(contentView)
    .heightIs(k6P_3AdaptedHeight(55.0));


    _minusSignBtn.sd_layout
    .leftSpaceToView(_serviceTimesLa,k6P_3AdaptedHeight(24))
    .widthIs(k6PAdaptedWidth(30))
    .centerYEqualToView(contentView)
    .heightEqualToWidth(YES);
    
    _numTextField.sd_layout
    .leftSpaceToView(_minusSignBtn,0)
    .widthIs(k6PAdaptedWidth(50))
    .centerYEqualToView(contentView)
    .heightRatioToView(_minusSignBtn,1);
    
    _addSignBtn.sd_layout
    .leftSpaceToView(_numTextField,0)
    .widthRatioToView(_minusSignBtn,1)
    .centerYEqualToView(contentView)
    .heightRatioToView(_numTextField,1);

    
}

// 减号按钮
- (IBAction)decreaseBtnClick:(UIButton *)sender {
    NSInteger num = [_numTextField.text integerValue];
    if (num > 1) {
        // textField里的值减1
        _numTextField.text = [NSString stringWithFormat:@"%ld",num-1];
    }else{
        [MBProgressHUD showTextOnly:@"订购数量必须为大于等于1的整数"];
    }
}
// 加号按钮
- (IBAction)addBtnClick:(UIButton *)sender {
    NSInteger num = [_numTextField.text integerValue];
    if (num < 99) {
        // textField里数值加1
        _numTextField.text = [NSString stringWithFormat:@"%ld",num+1];
    }else{
        [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"最大可购买量为%d",99]];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_numTextField.text integerValue] == 1) {
       _numTextField.text = @"1";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldNoti:) name:UITextFieldTextDidChangeNotification object:nil];
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([_numTextField.text isEqualToString:@""]) {
        _numTextField.text = @"";
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldNoti:(NSNotification* )noti{
    if ([_numTextField.text integerValue] > 99 ) {
        [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"最大可购买量为%d",99]];
        _numTextField.text = [NSString stringWithFormat:@"%d",99];

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
