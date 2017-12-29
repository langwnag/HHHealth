//
//  TestMySelfCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/7/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TestMySelfCell.h"

@implementation TestMySelfCell
/*
-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.tagLabel=[[UIButton alloc]init];
        self.tagLabel.backgroundColor=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.00f];
        self.tagLabel.layer.masksToBounds=YES;
        self.tagLabel.layer.cornerRadius=10;
        self.tagLabel.userInteractionEnabled=NO;
        [self.contentView addSubview:self.tagLabel];
        //        [self.tagLabel setBackgroundImage: [UIImage imageNamed:@"sc_tag_tagSelected"] forState:UIControlStateNormal];
        self.tagLabel.titleLabel.font=[UIFont systemFontOfSize:13];
        //125*44
        //        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.contentView).offset( 10);
        //            make.left.equalTo(self.contentView).offset(8);
        //            make.right.equalTo(self.contentView).offset(-8);
        //            make.height.equalTo(@(22));
        //        }];
    }
    return self;
}

*/
- (void)awakeFromNib {
    // Initialization code
}

@end
