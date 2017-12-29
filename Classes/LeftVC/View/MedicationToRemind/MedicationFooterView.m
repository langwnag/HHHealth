//
//  MedicationFooterView.m
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedicationFooterView.h"

@implementation MedicationFooterView


- (void)drawRect:(CGRect)rect{
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    self.textView.delegate = self;
    
    //创建占位label
    _placeHoderLabel = [SZRFunction createLabelWithFrame:CGRectMake(10, 5, self.textView.frame.size.width-20, 21) color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14] text:@"您还可以添加您的描述"];
    [self.textView addSubview:_placeHoderLabel];
    if (_notes) {
        self.textView.text = _notes;
        _placeHoderLabel.alpha = 0;
    }

}

// textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHoderLabel.alpha = 0;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textView.text.length == 0) {
        _placeHoderLabel.alpha = 1;
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self endEditing:YES];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
