//
//  VIPCell.m
//  YiJiaYi
//
//  Created by SZR on 16/9/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "VIPCellView.h"
#import "GoldCoinsVC.h"
#define SMALL_HEIGHT 101
#define SMALL_WIDTH SZRScreenWidth/3

#define FOURImageArr @[@"vip_hehebi",@"vip_grade",@"vip_record"]
@interface VIPCellView()
@property (nonatomic,strong) UIView * view1;
// 金币数
@property (nonatomic,strong) UILabel* coinsLa;
// 次数
@property (nonatomic,strong) UILabel* numLa;

@end
@implementation VIPCellView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    [SZRFunction SZRSetLayerImage:self imageStr:@"fourCell_BG"];
    NSArray * arr = @[[NSString stringWithFormat:@"合合币:%@币",@"8"],@"会员级别",[NSString stringWithFormat:@"寻诊记录:%@次",@"0"]];
    for (int i = 0; i < 3; i++) {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake((i%3)*SMALL_WIDTH, (i/3)*SMALL_HEIGHT+11/3, SMALL_WIDTH, SMALL_HEIGHT)];
        view.userInteractionEnabled = YES;
        view.tag = 200+i;
        [self addSubview:view];
        // 给View添加手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tap];

        //图片
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:FOURImageArr[i]];
        [view addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.offset(10);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        UILabel * typeLabel = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] text:arr[i]];
        
        typeLabel.adjustsFontSizeToFitWidth = YES;
        typeLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageV.mas_centerX);
            make.width.mas_equalTo(SMALL_WIDTH);
            make.bottom.offset(-8);
            make.height.mas_equalTo(21);
        }];
        
    }

    [self layoutIfNeeded];
    
}
- (void)tap:(UITapGestureRecognizer* )tap{
    if (self.tagClickBlock) {
        self.tagClickBlock(tap.view.tag+1);
    }
}



@end
