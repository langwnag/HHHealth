//
//  SZRTextview.m
//  SZRTextview
//
//  Created by SZR on 2017/2/24.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "SZRTextview.h"


#define kHEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define kTextColor kHEXCOLOR(0x666666)
#define kEdgeSpace kAdaptedWidth(5)
#define kFontSize kAdaptedWidth(13)


@implementation SZRTextview

{
    UILabel * _placeHolderLabel;
    UILabel * _restNumLabel;
}


-(instancetype)initWithText:(NSString *)originalText PlaceHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum{
    if (self = [super init]) {
        _originalText = originalText;
        _placeHolder = placeHolder;
        _maxNum = maxNum;
        [self configUI];
    }
    return self;
}

-(void)configWithText:(NSString *)originalText PlaceHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum{
    _originalText = originalText;
    _placeHolder = placeHolder;
    _maxNum = maxNum;
    [self configUI];
}



-(void)configUI{
    
    UITextView * textView = [UITextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:kFontSize];
    textView.textColor = kTextColor;
    textView.textContainerInset = UIEdgeInsetsMake(kEdgeSpace, kEdgeSpace, 21, kEdgeSpace);
    textView.delegate = self;
    _textView = textView;
    [self addSubview:textView];
    
    _placeHolderLabel = [UILabel new];
    _placeHolderLabel.textColor = textView.textColor;
    _placeHolderLabel.font = textView.font;
    _placeHolderLabel.text = self.placeHolder;
    [textView addSubview:_placeHolderLabel];
    
    _restNumLabel = [UILabel new];
    _restNumLabel.textColor = HEXCOLOR(0xcccccc);
    _restNumLabel.font = textView.font;
    _restNumLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_restNumLabel];
    
    textView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    textView.sd_cornerRadius = @(kEdgeSpace);
    
    _placeHolderLabel.sd_layout
    .topSpaceToView(textView,kEdgeSpace)
    .leftSpaceToView(textView,kEdgeSpace)
    .rightSpaceToView(textView,kEdgeSpace)
    .heightIs(15);
    
    _restNumLabel.sd_layout
    .bottomEqualToView(textView).offset(-kEdgeSpace)
    .heightIs(21)
    .rightEqualToView(textView).offset(-kEdgeSpace)
    .leftEqualToView(textView).offset(kEdgeSpace);
    
    if (_originalText) {
        _placeHolderLabel.hidden = YES;
        textView.text = _originalText;
        _restNumLabel.text = [NSString stringWithFormat:@"%zd/%zd",_maxNum - _originalText.length,_maxNum];
    }else{
        _placeHolderLabel.hidden = NO;
        _placeHolderLabel.text = _placeHolder;
        _restNumLabel.text = [NSString stringWithFormat:@"%zd/%zd",_maxNum,_maxNum];
    }
    
    
}

-(void)resetTextViewBGColor:(UIColor *)bgColor{
    _textView.backgroundColor = bgColor;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    UITextRange *selectedRange = [textView markedTextRange];
    
    //获取高亮部分
    
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //获取高亮部分内容
    
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    
    if (selectedRange && pos) {
        
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _maxNum) {
            
            return YES;
        }else{
            
            return NO;
        }
        
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = _maxNum - comcatstr.length;
    
    if (caninputlen >= 0){
        
        return YES;
        
    }else{
        
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                              
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                s = trimString;
                
            }
            
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _restNumLabel.text = [NSString stringWithFormat:@"%zd/%zd",0,(long)_maxNum];
        }
        
        return NO;
    }
    
}


-(void)textViewDidChange:(UITextView *)textView{
    
    UITextRange *selectedRange = [textView markedTextRange];
    
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > _maxNum)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:_maxNum];
        [textView setText:s];
    }

    //不让显示负数
    _restNumLabel.text = [NSString stringWithFormat:@"%zd/%zd",MAX(0,_maxNum - existTextNum),_maxNum];
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHolderLabel.alpha = 0;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolderLabel.alpha = 1;
    }
}






@end
