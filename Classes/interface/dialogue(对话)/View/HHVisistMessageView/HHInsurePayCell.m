//
//  HHInsurePayCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHInsurePayCell.h"
#import "RCDTestMessage.h"

@implementation HHInsurePayCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 80);
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.descLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
    self.descLab.backgroundColor = [UIColor lightGrayColor];
    self.descLab.font= [UIFont systemFontOfSize:14];
    self.descLab.numberOfLines = 0;
    self.descLab.textColor = [UIColor whiteColor];
    self.descLab.textAlignment = NSTextAlignmentCenter;
    [self.baseContentView addSubview:self.descLab];
    self.descLab.layer.cornerRadius = 5.0f;
    self.descLab.layer.masksToBounds = YES;
    
    self.insurePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.insurePayBtn.frame = CGRectMake(10, CGRectGetMaxY(self.descLab.frame) + 5, [UIScreen mainScreen].bounds.size.width - 120, 30);
    self.insurePayBtn.backgroundColor = [UIColor redColor];
    [self.insurePayBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.insurePayBtn addTarget:self action:@selector(insureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseContentView addSubview:self.insurePayBtn];

}

- (void)insureBtnClicked:(UIButton *)btn{
    if (self.insurePayBtnBlock) {
        self.insurePayBtnBlock(400.0f);
    }
}
- (void)setDataModel:(RCMessageModel *)model{
    
    [super setDataModel:model];
    RCDTestMessage *testMessage = (RCDTestMessage *)self.model.content;
    if (testMessage) {
        self.descLab.text = @"123";
    }
//    HHVisitMessage *testMessage = (HHVisitMessage *)self.model.content;
//    if (testMessage) {
//        self.descla.text = testMessage.contentShow;
//        CGFloat width = [NSString getWidthWithString:testMessage.contentShow height:15 font:14];
//        CGRect rect = self.descla.frame;
//        rect.size.width = width;
//        rect.origin.x = 50 + (([UIScreen mainScreen].bounds.size.width - 100) - width) / 2;
//        self.descla.frame =rect;
//    }
}


@end
