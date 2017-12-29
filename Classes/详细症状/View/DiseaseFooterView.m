//
//  DiseaseFooterView.m
//  YiJiaYi
//
//  Created by SZR on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DiseaseFooterView.h"
@implementation DiseaseFooterView
{
    UILabel * _placeHoderLabel;//textView上面占位文字
}

- (void)drawRect:(CGRect)rect {
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //创建占位label
    _placeHoderLabel = [SZRFunction createLabelWithFrame:CGRectMake(10, 5, self.textView.frame.size.width-20, 21) color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:16] text:@"您还可以添加您的描述"];
    [self.textView addSubview:_placeHoderLabel];
    
}

- (IBAction)releaseBtnClick:(UIButton *)sender {
    
    if (self.returnBlock !=nil) {
        self.returnBlock();

    }
}
//textView代理方法
-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textView开始编辑");
    _placeHoderLabel.alpha = 0;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textView结束编辑");
    if (self.textView.text.length == 0) {
        _placeHoderLabel.alpha = 1;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}


@end
