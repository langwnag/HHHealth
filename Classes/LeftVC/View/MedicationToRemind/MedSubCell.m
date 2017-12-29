//
//  MedSubCell.m
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedSubCell.h"

@implementation MedSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILabel * leftLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, 0, 40, 25) color:kWord_Gray_6 font:[UIFont systemFontOfSize:15] text:@"药品:"];
    self.drugNameTextF.leftView = leftLabel;
    self.drugNameTextF.leftViewMode = UITextFieldViewModeAlways;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.drugNameBlock) {
        self.drugNameBlock(_drugNameTextF.text);
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_drugNameTextF resignFirstResponder];
    return YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)richScanBtnClick:(UIButton *)sender {
    SZRLog(@"扫码");
}
@end
