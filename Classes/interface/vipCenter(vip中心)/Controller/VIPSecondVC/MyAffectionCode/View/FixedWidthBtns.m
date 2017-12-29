//
//  FixedWidthBtns.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FixedWidthBtns.h"
#define kBtnTag 100

NSString * const fFontSize = @"fFontSize";
NSString * const fBackgroundColor = @"fBackgroundColor";
NSString * const fBtnFontColor = @"fBtnFontColor";
NSString * const fEachRowBtnNum = @"fEachRowBtnNum";
NSString * const fBtnWidth = @"fBtnWidth";
NSString * const fBtnHeight = @"fBtnHeight";
NSString * const fTopSpace = @"fTopSpace";
NSString * const fRowSpace = @"fRowSpace";


@implementation FixedWidthBtns
{
    NSArray * _dataArr;
}


-(void)loadBtnsWithData:(NSArray *)arr propertyDic:(NSDictionary *)dic{
    
    [self loadProperty:dic];
    
    [self loadBtnsWithData:arr];
    
}

-(void)loadProperty:(NSDictionary *)dic{
    _fontSize = [dic[fFontSize] integerValue];
    _backgroundColor = dic[fBackgroundColor];
    _btnFontColor = dic[fBtnFontColor];
    _eachRowBtnNum = [dic[fEachRowBtnNum] integerValue];
    _btnWidth = [dic[fBtnWidth] floatValue];
    _btnHeight = [dic[fBtnHeight] floatValue];
    _topSpace = [dic[fTopSpace] floatValue];
    _rowSpace = [dic[fRowSpace] floatValue];
}

-(void)loadBtnsWithData:(NSArray *)arr{
    _dataArr = arr;
    //每行之间的间距
    CGFloat lineSpace = (self.width - (_btnWidth * _eachRowBtnNum))/(_eachRowBtnNum + 1);
    for (int i = 0; i < arr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kBtnTag + i;
        [btn setTitleColor:_btnFontColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSize];
        btn.backgroundColor = _backgroundColor;
        btn.frame = CGRectMake(lineSpace + (lineSpace + _btnWidth)*(i%_eachRowBtnNum), _topSpace + (_btnHeight + _rowSpace)*(i/_eachRowBtnNum), _btnWidth, _btnHeight);
        btn.layer.cornerRadius = _btnHeight/4.0;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
}

-(void)clickBtn:(UIButton *)btn{
    SZRLog(@"btn.tag = %zd",btn.tag);
    if (self.btnViewBlock) {
        self.btnViewBlock(btn.tag - kBtnTag);
    }
}


@end
