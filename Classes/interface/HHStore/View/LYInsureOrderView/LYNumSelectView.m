//
//  LYNumSelectView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYNumSelectView.h"

@interface LYNumSelectView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField   * textField;
@property (nonatomic, strong) UIButton      * plusBtn;
@property (nonatomic, strong) UIButton      * subBtn;

@end

static CGFloat const btnWidth = 15;

@implementation LYNumSelectView

- (instancetype)initWithFrame:(CGRect)frame
                   currentNum:(NSInteger)currentNum
                       maxNum:(NSInteger)maxNum{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.plusBtn];
        [self addSubview:self.textField];
        [self addSubview:self.subBtn];
        self.maxNum = maxNum;
        self.currentNum = currentNum;
    }
    return self;
}

- (void)configUI{

}

- (UIButton *)plusBtn{
    if (!_plusBtn) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setFrame:CGRectMake(CGRectGetMaxX(self.textField.frame) + 5, CGRectGetMinY(self.subBtn.frame), btnWidth, btnWidth)];
        [_plusBtn addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        CGFloat width = self.frame.size.width - (btnWidth + 5 * 2) * 2;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.subBtn.frame) + 5, 0, width, self.frame.size.height)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)subBtn{
    if (!_subBtn) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat originY = (self.frame.size.height - btnWidth) / 2;
        [_subBtn setFrame:CGRectMake(5, originY, btnWidth, btnWidth)];
        [_subBtn addTarget:self action:@selector(subBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (self.currentNum > 1) {
            [_subBtn setBackgroundImage:[UIImage imageNamed:@"subG"] forState:UIControlStateNormal];
        }else{
            [_subBtn setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
        }
    }
    return _subBtn;
}

- (void)plusBtnClicked:(UIButton *)plusBtn{
    [self.textField resignFirstResponder];
    if (self.maxNum > self.currentNum) {
        self.currentNum += 1;
    }
}

- (void)subBtnClicked:(UIButton *)subBtn{
    [self.textField resignFirstResponder];
    if (self.currentNum > 1) {
        self.currentNum -= 1;
    }
}

- (void)setCurrentNum:(NSInteger)currentNum{
//    _currentNum = currentNum > 0 ? currentNum : 1;
//    self.textField.text = [NSString stringWithFormat:@"%ld", _currentNum];
    _currentNum = currentNum;
    self.textField.text = [NSString stringWithFormat:@"%ld", _currentNum];
    if (_currentNum > 1 && _currentNum < self.maxNum) {
        self.subBtn.enabled = YES;
        [self.subBtn setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
        self.plusBtn.enabled = YES;
        [self.plusBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    
    }else if(_currentNum <= 1){
        self.subBtn.enabled = NO;
        [self.subBtn setBackgroundImage:[UIImage imageNamed:@"subG"] forState:UIControlStateNormal];
        self.plusBtn.enabled = YES;
        [self.plusBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];

    }else if (_currentNum >= self.maxNum){
        self.plusBtn.enabled = NO;
        [self.plusBtn setBackgroundImage:[UIImage imageNamed:@"plusG"] forState:UIControlStateNormal];
        self.subBtn.enabled = YES;
        [self.subBtn setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.textField.text = nil;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //删除操作
    if (range.length == 1) {
        self.currentNum = [textField.text integerValue] / 10;
        
        return NO;
    }
    NSMutableString * tmpStr = [[NSMutableString alloc] initWithString:string];
    if (self.textField.text && [self.textField.text integerValue] > 0) {
        [tmpStr insertString:textField.text atIndex:0];
    }
    if ([tmpStr integerValue] > self.maxNum || [string integerValue] > self.maxNum) {
        NSLog(@"不能超过最大数量");
        textField.text = [NSString stringWithFormat:@"%ld", self.maxNum];
        self.currentNum = self.maxNum;
        return NO;
    }else{
        self.currentNum = [[NSString stringWithFormat:@"%@%@", textField.text, string] integerValue];
        return NO;
    }
    return YES;
}
@end
