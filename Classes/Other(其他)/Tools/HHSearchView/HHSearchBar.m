//
//  HHSearchBar.m
//  YiJiaYi
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHSearchBar.h"

@implementation HHSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"输入菜名或食材名搜索";
        self.keyboardType = UIKeyboardTypeDefault;
        self.backgroundImage = [HHSearchBar getImageWithColor:[UIColor clearColor] andHeight:44.0f ];
        //设置顶部搜索栏的背景色
        [self setBackgroundColor:HEXCOLOR(0xf0f0f6)];
        //设置顶部搜索栏输入框的样式
//        UITextField* searchField = [self valueForKey:@"01_pic_03"];
        UITextField* searchField = [[UITextField alloc] init];
        
        searchField.layer.borderWidth = 0.5f;
        searchField.layer.borderColor = [HEXCOLOR(0xdfdfdf) CGColor];
        searchField.layer.cornerRadius = 5.f;
    }
    return self;
}

+ (UIImage*) getImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
