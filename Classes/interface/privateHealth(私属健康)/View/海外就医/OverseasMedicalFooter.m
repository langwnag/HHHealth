//
//  OverseasMedicalFooter.m
//  YiJiaYi
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OverseasMedicalFooter.h"
@interface OverseasMedicalFooter ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *onLineClickBtn;

@end
@implementation OverseasMedicalFooter
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.onLineClickBtn.layer.cornerRadius = 16.5f;
    self.onLineClickBtn.layer.masksToBounds = YES;
    self.onLineClickBtn.backgroundColor = HEXCOLOR(0xff6666);
    self.contactNameTF.placeholder = @"联系人电话";
    self.contactPhoneTF.placeholder = @"联系人姓名";
    self.contactNameTF.textColor = [UIColor lightGrayColor];
    self.contactNameTF.textColor = [UIColor lightGrayColor];
    self.contactNameTF.delegate = self;
    self.contactPhoneTF.delegate = self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.contactNameTF ]) {
        self.contactNameTF.placeholder = @"";
    }
    else {
        self.contactPhoneTF.placeholder = @"";
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.contactNameTF]) {
        self.contactNameTF.placeholder = @"联系人电话";
    }else {
       self.contactPhoneTF.placeholder = @"联系人姓名";
    }
}
- (IBAction)onLineClickBtn:(id)sender {
    if (self.contactTFBlock) {
        self.contactTFBlock(self.contactNameTF.text,self.contactPhoneTF.text);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

@end
