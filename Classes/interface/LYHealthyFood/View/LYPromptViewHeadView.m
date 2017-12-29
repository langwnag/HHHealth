//
//  LYPromptViewHeadView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYPromptViewHeadView.h"

@interface LYPromptViewHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@end

@implementation LYPromptViewHeadView

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLab.text = subTitle;
}
@end
