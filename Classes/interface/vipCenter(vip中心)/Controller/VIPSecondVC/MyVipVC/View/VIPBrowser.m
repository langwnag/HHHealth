//
//  VIPBrowser.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "VIPBrowser.h"
#import "VIPModel.h"


#define kBaseTag 100
#define kRightImageTag 200
#define kSubLabelTag 300
#define kItemSpace kAdaptedWidth(60)
#define kItemWidth kAdaptedWidth(80)
#define kItemHeight kAdaptedWidth(80)
#define kItemSelectedWidth kAdaptedWidth(190)
#define kItemSelectedHeight kAdaptedWidth(190)
#define kScrollViewContentOffset (SZRScreenWidth / 2.0 - (kItemWidth / 2.0 + kItemSpace))

#define kR 102
#define kG 102
#define kB 102
#define kLabelFont(size) [UIFont boldSystemFontOfSize:kAdaptedWidth(size)]

@interface VIPBrowser ()<UIScrollViewDelegate>

@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong) NSArray * VIPDataArr;
@property(nonatomic,strong) NSMutableArray * items;
@property(nonatomic,assign) CGPoint scrollViewContentOffset;
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,assign) BOOL isTapDetected;

@end


@implementation VIPBrowser



- (instancetype)initWithFrame:(CGRect)frame VIPDataArr:(NSArray *)vipDataArr currentIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.VIPDataArr = vipDataArr;
        if (index >= 0 && index < self.VIPDataArr.count) {
            self.currentIndex = index > 4 ? 0 : index;
//            [self setCurrentMovieIndex:self.currentIndex];
        }
    }
    
    return self;
}

-(void)commonInit{
    self.layer.contents = (id)[UIImage imageNamed:@"myVipTopBG"].CGImage;
    
    UIView * line = [UIView new];
//    line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self addSubview:line];
    line.sd_layout
    .widthRatioToView(self,1)
    .heightIs(kAdaptedWidth(1))
    .centerYEqualToView(self).offset(-kAdaptedWidth(15));

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:1 alpha:0].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor];
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, self.width, kAdaptedWidth(1));
    [line.layer addSublayer:gradientLayer];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake((kItemWidth + kItemSpace) * self.VIPDataArr.count + kItemSpace, kVIPBrowserHeight);
    
    [self configScrollViewSubViews];
    [self setCurrentMovieIndex:self.currentIndex];

    _scrollView.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset);
}

-(void)configScrollViewSubViews{
    NSInteger i = 0;
    _items = [NSMutableArray array];
    
    for (VIPModel * vipModel in self.VIPDataArr) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake((kItemSpace + kItemWidth)*i + kItemSpace, 0, kItemWidth, kItemHeight)];
        
        [_scrollView addSubview:bgView];
        
        UIView * itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
        itemView.tag = i + kBaseTag;
        [bgView addSubview:itemView];
        [self.items addObject:itemView];
        
        UIImageView * outSideImageV = [UIImageView new];
        outSideImageV.userInteractionEnabled = YES;
        outSideImageV.image = [UIImage imageNamed:@"VIPAlpha"];
        
        UIImageView * vipImageV = [UIImageView new];
        vipImageV.userInteractionEnabled = YES;
        vipImageV.image = [UIImage imageNamed:vipModel.VIPImage];
        
        UIImageView * rightSmallImageV = [UIImageView new];
        rightSmallImageV.userInteractionEnabled = YES;
        rightSmallImageV.tag = kRightImageTag + i;
        rightSmallImageV.backgroundColor = [UIColor clearColor];
        if (i == self.currentIndex) {
            rightSmallImageV.image = [UIImage imageNamed:vipModel.VIPImage];
            [VDNetRequest VD_OSSImageView:vipImageV fullURLStr:[DEFAULTS objectForKey:CLIENTHEADPORTRATION] placeHolderrImage:kDefaultUserImage];
        }
        
        UILabel * vipLabel = [UILabel new];
        vipLabel.textAlignment = NSTextAlignmentCenter;
        vipLabel.tag = i + kSubLabelTag;
        vipLabel.text = vipModel.VIPName;
        
        [itemView sd_addSubviews:@[outSideImageV,vipImageV,rightSmallImageV,vipLabel]];
        
        bgView.sd_layout
        .centerYEqualToView(_scrollView).offset(-kAdaptedWidth(15));
        
        itemView.sd_layout
        .centerXEqualToView(bgView)
        .centerYEqualToView(bgView);
        
        outSideImageV.sd_layout
        .centerXEqualToView(itemView)
        .centerYEqualToView(itemView)
        .heightRatioToView(itemView,45.0/80)
        .widthRatioToView(itemView,45.0/80);
        
        vipImageV.sd_layout
        .centerXEqualToView(outSideImageV)
        .centerYEqualToView(outSideImageV)
        .heightRatioToView(itemView,37.0/80)
        .widthRatioToView(itemView,37.0/80);
        vipImageV.sd_cornerRadiusFromWidthRatio = @0.5;
        
        rightSmallImageV.sd_layout
        .centerXEqualToView(itemView).offset(16.5/sqrt(2))
        .centerYEqualToView(itemView).offset(16.5/sqrt(2))
        .widthRatioToView(itemView,16.0/sqrt(2)/80)
        .heightRatioToView(itemView,16.0/sqrt(2)/80);
        
        vipLabel.sd_layout
        .centerXEqualToView(outSideImageV)
        .bottomSpaceToView(itemView,0)
        .widthRatioToView(outSideImageV,1)
        .heightRatioToView(itemView,13.0/80);
        vipLabel.sd_cornerRadiusFromHeightRatio = @0.5;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
        [itemView addGestureRecognizer:tap];
        
        i++;
    }
        [self adjustSubviews:self.scrollView];
}



#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.VIPDataArr.count != 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([self.delegate respondsToSelector:@selector(movieBrowser:didChangeItemAtIndex:)]) {
                [self.delegate movieBrowser:self didChangeItemAtIndex:self.currentIndex];
            }
            if ([self.delegate respondsToSelector:@selector(movieBrowser:didEndScrollingAtIndex:)]) {
                [self.delegate movieBrowser:self didEndScrollingAtIndex:self.currentIndex];
            }
        });
    }
    [self commonInit];

}

- (void)adjustSubviews:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + kScrollViewContentOffset) / (kItemWidth + kItemSpace);
    index = MIN(self.VIPDataArr.count - 1, MAX(0, index));
    
    CGFloat scale = (scrollView.contentOffset.x + kScrollViewContentOffset - (kItemWidth + kItemSpace) * index) / (kItemWidth + kItemSpace);
    
    if (self.VIPDataArr.count > 0) {
        
        if (scale < 0.0) {
            scale = 1 - MIN(1.0, ABS(scale));
            
            [self reLayOutViews:index scale:scale];
            
            if (index + 1 < self.VIPDataArr.count) {
                
                [self reLayOutViews:index + 1 scale:0];

            }
            
        } else if (scale <= 1.0) {
            if (index + 1 >= self.VIPDataArr.count) {
                
                scale = 1 - MIN(1.0, ABS(scale));
                
                [self reLayOutViews:self.VIPDataArr.count - 1 scale:scale];
                
            } else {
                CGFloat scaleLeft = 1 - MIN(1.0, ABS(scale));
                
                [self reLayOutViews:index scale:scaleLeft];
                
                CGFloat scaleRight = MIN(1.0, ABS(scale));
                
                [self reLayOutViews:index + 1 scale:scaleRight];
                
            }
        }
        
        for (UIView * view in self.items) {
            if (view.tag != index + kBaseTag && view.tag != (index + kBaseTag + 1)) {
                view.sd_layout
                .widthIs(kItemWidth)
                .heightIs(kItemHeight);
                UILabel * label = (UILabel *)[self viewWithTag:view.tag + kSubLabelTag - kBaseTag ];
                label.font = kLabelFont(10);
                label.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
                label.textColor = [UIColor whiteColor];
                label.sd_cornerRadiusFromHeightRatio = @0.5;
                
                UIImageView * rightSmallImageV = [self viewWithTag:view.tag + kRightImageTag - kBaseTag];
                rightSmallImageV.sd_layout
                .centerXEqualToView(view).offset(16.5/sqrt(2))
                .centerYEqualToView(view).offset(16.5/sqrt(2));
        
            }
        }
    }
    
}

-(void)reLayOutViews:(NSInteger)index scale:(CGFloat)scale{
  
        UIView* view = self.items[index];
        view.sd_layout
        .heightIs(kItemHeight + (kItemSelectedHeight - kItemHeight) * scale)
        .widthIs(kItemWidth + (kItemSelectedWidth - kItemWidth) * scale);
        UILabel * label = (UILabel *)[self viewWithTag:kSubLabelTag + index];
        label.font = kLabelFont(10 + (17 - 10)*scale);
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:scale];
        label.textColor = RGBCOLOR(255 + (kR - 255)*scale, 255 + (kG - 255)*scale, 255 + (kB - 255)*scale);
        label.sd_cornerRadiusFromHeightRatio = @0.5;
        
        UIImageView * rightSmallImageV = [self viewWithTag:kRightImageTag + index];
        rightSmallImageV.sd_layout
        .centerXEqualToView(view).offset((16.5 + (39.2 - 16.5) * scale)/sqrt(2))
        .centerYEqualToView(view).offset((16.5 + (39.2 - 16.5) * scale)/sqrt(2));
        
}

    
    



-(void)setCurrentMovieIndex:(NSInteger)index{
    if (index >= 0 && index < self.VIPDataArr.count) {
//        self.currentIndex = index;
        CGPoint point = CGPointMake((kItemSpace + kItemWidth) * index - kScrollViewContentOffset, 0);
        [self.scrollView setContentOffset:point animated:NO];
        
    }
}

#pragma mark - Tap Detection

- (void)tapDetected:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == self.currentIndex + kBaseTag) {
        if ([self.delegate respondsToSelector:@selector(movieBrowser:didSelectItemAtIndex:)]) {
            [self.delegate movieBrowser:self didSelectItemAtIndex:self.currentIndex];
            return;
        }
    }
    
    CGPoint point = [tapGesture.view.superview convertPoint:tapGesture.view.center toView:self.scrollView];
    point = CGPointMake(point.x - kScrollViewContentOffset - ((kItemWidth / 2 + kItemSpace)), 0);
    self.scrollViewContentOffset = point;
    
    self.isTapDetected = YES;
    
    [self.scrollView setContentOffset:point animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpace / 2)) / (kItemWidth + kItemSpace);
    index = MIN(self.VIPDataArr.count - 1, MAX(0, index));
    
    if (self.currentIndex != index) {
        self.currentIndex = index;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieBrowserDidEndScrolling) object:nil];
    
    [self adjustSubviews:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger index = (targetContentOffset->x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpace / 2)) / (kItemWidth + kItemSpace);
    targetContentOffset->x = (kItemSpace + kItemWidth) * index - kScrollViewContentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performSelector:@selector(movieBrowserDidEndScrolling) withObject:nil afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!CGPointEqualToPoint(self.scrollViewContentOffset, self.scrollView.contentOffset)) {
        if (self.isTapDetected) {
            self.isTapDetected = NO;
            [self.scrollView setContentOffset:self.scrollViewContentOffset animated:YES];
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self movieBrowserDidEndScrolling];
        });
    }
}




#pragma mark - end scrolling handling

- (void)movieBrowserDidEndScrolling
{
    if ([self.delegate respondsToSelector:@selector(movieBrowser:didEndScrollingAtIndex:)]) {
        [self.delegate movieBrowser:self didEndScrollingAtIndex: self.currentIndex];
    }
    
}

#pragma mark - setters

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if ([self.delegate respondsToSelector:@selector(movieBrowser:didChangeItemAtIndex:)]) {
        [self.delegate movieBrowser:self didChangeItemAtIndex:_currentIndex];
    }
}





@end
