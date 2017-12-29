//
//  HeightAndWeightCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/10.
//  Copyright © 2017年 mac. All rights reserved.
//
#import "HeightAndWeightCell.h"
@interface HeightAndWeightCell ()<UITextFieldDelegate>
@end
@implementation HeightAndWeightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bodyLabel.textColor = kWord_Gray_6;
    self.bodyLabel.font=kAdaptedFontSize(14);
    self.valueLabel.textColor = kWord_Gray_9;
    self.valueLabel.font=kAdaptedFontSize(14);
    self.TF.textColor = kWord_Gray_9;
    self.TF.delegate = self;

    UIView * contentView = self.contentView;
    self.bodyLabel.sd_layout
    .leftSpaceToView(contentView,kAdaptedWidth(15))
    .heightIs(kAdaptedHeight(20))
    .centerYEqualToView(contentView);
    [self.valueLabel setSingleLineAutoResizeWithMaxWidth:kAdaptedWidth(80)];
    
    self.valueLabel.sd_layout
    .rightSpaceToView(contentView,kAdaptedWidth(15))
    .heightRatioToView(self.bodyLabel,1)
    .centerYEqualToView(contentView);
    [self.valueLabel setSingleLineAutoResizeWithMaxWidth:kAdaptedWidth(80)];
    
    self.TF.sd_layout
    .leftSpaceToView(self.bodyLabel,0)
    .rightSpaceToView(self.valueLabel,0)
    .centerYEqualToView(contentView)
    .heightIs(kAdaptedHeight(20));
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }else if (textField.text){
        return textField.text.length < 3;
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (![SZRFunction HH_CheckNoNegativeNum:textField.text]) {
        [MBProgressHUD showTextOnly:@"请输入有效数字"];
    }else{
        if (self.textFieldBlock) {
            self.textFieldBlock(textField.text);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
