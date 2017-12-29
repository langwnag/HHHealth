//
//  ExamComplete.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ExamComplete.h"

@implementation ExamComplete
{
    NSString * _alertContent;
}

-(instancetype)initWithFrame:(CGRect)frame alertContent:(NSString *)alertContent{
    if (self = [super initWithFrame:frame]) {
        _alertContent = alertContent;
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIImageView * electrocardiogramImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"electrocardiogram"]];
    
    UIImageView * stethophoneImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stethophone"]];
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectNull color:HEXCOLOR(0xffffff) font:[UIFont boldSystemFontOfSize:kAdaptedWidth(12)] text:@""];
    label.numberOfLines = 0;
    label.isAttributedContent = YES;
    [self sd_addSubviews:@[electrocardiogramImageV,stethophoneImageV,label]];

    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:_alertContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3];
    
    [attriStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f} range:NSMakeRange(0, attriStr.length)];
    label.attributedText = attriStr;
    
    electrocardiogramImageV.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(kAdaptedHeight(200))
    .centerYIs(self.centerY_sd - kAdaptedHeight(32));
    
    stethophoneImageV.sd_layout
    .topSpaceToView(self,kAdaptedHeight(130))
    .heightIs(kAdaptedHeight(328.0/2))
    .widthIs(kAdaptedWidth(251.0/2))
    .centerXEqualToView(self);
    
    label.sd_layout
    .topSpaceToView(stethophoneImageV,kAdaptedHeight(8))
    .heightIs(kAdaptedHeight(75.0/2))
    .leftSpaceToView(self,kAdaptedWidth(50))
    .rightSpaceToView(self,kAdaptedWidth(50));
    
}


@end
