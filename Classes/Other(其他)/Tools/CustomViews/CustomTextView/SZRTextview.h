//
//  SZRTextview.h
//  SZRTextview
//
//  Created by SZR on 2017/2/24.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZRTextview : UIView<UITextViewDelegate>

@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,assign)NSInteger maxNum;
@property(nonatomic,copy)NSString * placeHolder;
@property(nonatomic,copy)NSString * originalText;


-(instancetype)initWithText:(NSString *)originalText PlaceHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum;

-(void)configWithText:(NSString *)originalText PlaceHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum;

-(void)resetTextViewBGColor:(UIColor *)bgColor;



@end
