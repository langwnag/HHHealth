//
//  TestCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TestCell.h"
#import "HHVisitMessage.h"
#import "NSString+LYString.h"

@implementation TestCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 100);
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.descla = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
    self.descla.backgroundColor = [UIColor lightGrayColor];
    self.descla.font= [UIFont systemFontOfSize:14];
    self.descla.textColor = [UIColor whiteColor];
    self.descla.textAlignment = NSTextAlignmentCenter;
    [self.baseContentView addSubview:self.descla];
    self.descla.layer.cornerRadius = 5.0f;
    self.descla.layer.masksToBounds = YES;
}

- (void)setDataModel:(RCMessageModel *)model{
    
    [super setDataModel:model];
    HHVisitMessage *testMessage = (HHVisitMessage *)self.model.content;
    if (testMessage) {
        self.descla.text = testMessage.contentShow;
       CGFloat width = [NSString getWidthWithString:testMessage.contentShow height:15 font:14];
        CGRect rect = self.descla.frame;
        rect.size.width = width;
        rect.origin.x = 50 + (([UIScreen mainScreen].bounds.size.width - 100) - width) / 2;
        self.descla.frame =rect;
    }
}

@end
