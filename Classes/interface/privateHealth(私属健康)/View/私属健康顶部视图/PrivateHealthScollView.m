//
//  PrivateHealthScollView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PrivateHealthScollView.h"
#import "UserInfoView.h"
#import "PeripheralsView.h"



@interface PrivateHealthScollView ()<UIScrollViewDelegate>

@property(nonatomic,assign)CGFloat frameWidth;//本视图宽度
@property(nonatomic,assign)CGFloat frameHeight;//本视图高度
@property(nonatomic,strong)UIPageControl * pageControl;

@property(nonatomic,copy)NSString * headImageStr;//头像
@property(nonatomic,assign)CGFloat healthValue;//健康值
@property(nonatomic,copy)NSString * healthStr;//健康状况
@property(nonatomic,assign)int healthValueStr;//健康指数
@property(nonatomic,copy)NSString* dateStr;//日期



@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UserInfoView * userInfoView;

@end


@implementation PrivateHealthScollView
{
    NSInteger _vipLevel;
}

-(instancetype)initWithFrame:(CGRect)frame headImage:(NSString *)headImageStr healthValue:(CGFloat)healthValue vipLevel:(NSInteger)vipLevel healthStr:(NSString *)healthStr healthValueStr:(int)healthValueStr dateStr:(NSString *)dateStr{
    if (self = [super initWithFrame:frame]) {
            self.frameWidth = frame.size.width;
            self.frameHeight = frame.size.height;
            self.headImageStr = headImageStr;
            self.healthValue = healthValue;
            _vipLevel = vipLevel;
            self.healthStr = healthStr;
            self.healthValueStr = healthValueStr;
            self.dateStr = dateStr;
            [self createUI];
        }
        return self;
}

-(void)createUI{
   
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];
    //设置翻页效果
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    //添加子视图
    //用户头像视图
    UIView * headBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];
    [SZRFunction SZRSetLayerImage:headBGView imageStr:@"PH_HeadBG"];
    [self.scrollView addSubview:headBGView];
    
    UserInfoView * infoView = [UserInfoView new];
    self.userInfoView = infoView;
    [headBGView addSubview:infoView];
    infoView.sd_layout
    .heightIs(kAdaptedHeight(350/2))
    .widthEqualToHeight(YES)
    .centerXEqualToView(headBGView)
    .centerYEqualToView(headBGView).offset(-kAdaptedHeight(10));
    infoView.vipLevel = _vipLevel;
    infoView.headImageStr = self.headImageStr;
    infoView.healthValue = self.healthValue;
    infoView.healthStr = self.healthStr;
    infoView.healthValueStr = self.healthValueStr;
    infoView.dateStr = self.dateStr;
    [infoView createUI];
    
    
    //外设视图
    PeripheralsView * peripheralsView = [[PeripheralsView alloc]initWithFrame:CGRectMake(self.frameWidth, 0, self.frameWidth, self.frameHeight)];
    [self.scrollView addSubview:peripheralsView];
    
    self.scrollView.contentSize = CGSizeMake(self.frameWidth, self.frameHeight);
#pragma mark 以后打开
//    [self createPageControl:2];

}

-(void)updateHeadImage:(NSString *)imageURL vipLevel:(int)vipLevel{
    self.userInfoView.headImageStr = imageURL;
    self.userInfoView.vipLevel = vipLevel;
    [self.userInfoView updateData];
}


-(void)createPageControl:(NSInteger)pageNum{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frameHeight-20, self.frameWidth, 10)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = pageNum;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = SZR_NewLightGreen;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
}


#pragma mark 滑动调用方法
//滑动停止之后 结束减速方法中判断偏移量
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x + self.frameWidth * 0.5 /self.frameWidth;
    self.pageControl.currentPage = page;
}






@end
