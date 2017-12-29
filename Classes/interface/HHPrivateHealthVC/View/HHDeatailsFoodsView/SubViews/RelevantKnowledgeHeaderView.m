//
//  RelevantKnowledgeHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RelevantKnowledgeHeaderView.h"

@implementation RelevantKnowledgeHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView* imgUrl = [UIImageView new];
        [self addSubview:imgUrl];
        self.imageUrl = imgUrl;

        
        imgUrl.sd_layout
        .heightIs(k6P_3AdaptedHeight(768))
        .topSpaceToView(self,k6P_3AdaptedHeight(20))
        .rightEqualToView(self)
        .leftEqualToView(self);
        

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
