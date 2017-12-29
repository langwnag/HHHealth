//
//  TopHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TopHeaderView.h"
#import "LYTabCollectionView.h"
#import "NSString+LYString.h"
#import "ItemView.h"
@interface TopHeaderView ()

/** 标题 */
@property (nonatomic,strong) UILabel* titleLa;
/** 描述 */
@property (nonatomic,strong) UILabel* desLa;
/** lastView */
@property (nonatomic,strong) UIView* lastView;
/** desView */
@property (nonatomic,strong) UIView* desView;
/** LYTabCollectionView */
@property (nonatomic,strong) LYTabCollectionView * tabView;

/** ItemView */
@property (nonatomic,strong) ItemView* itemView;

@end
@implementation TopHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDesLabHeight:) name:@"HaveChangeTabViewFrame" object:nil];
        }
    return self;
}



- (void)changeDesLabHeight:(NSNotification *)notification{
    CGRect desLabRect = self.desLa.frame;
    NSString * tmpHeight = notification.object;
    desLabRect.origin.y = [tmpHeight floatValue] + self.tabView.frame.origin.y;
    self.desLa.frame = desLabRect;
}


- (void)configUI{

    self.topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight_2(400))];
    [self addSubview:self.topImg];

    self.titleLa = [[UILabel alloc] initWithFrame:CGRectMake(kAdaptedWidth_2(20), CGRectGetMaxY(self.topImg.frame)+kAdaptedHeight_2(16), 300, 21)];
    [self addSubview:self.titleLa];
    
    //高度请给屏幕高度
    LYTabCollectionView * tabView = [[LYTabCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLa.frame)+10, self.bounds.size.width, self.bounds.size.height)];
    self.tabView = tabView;
    tabView.selectTabBlock = ^(NSString * title){
        !self.selectItemBlock ? : self.selectItemBlock(title);
    };
    [self addSubview:tabView];
   
    self.desLa = [[UILabel alloc] initWithFrame:CGRectMake(kAdaptedWidth_2(20), CGRectGetMaxY(tabView.frame)+kAdaptedHeight_2(12), SZRScreenWidth-kAdaptedWidth_2(20)*2, 50)];
    self.desLa.numberOfLines = 0;
    kLabelThinLightColor(self.desLa, kAdaptedWidth_2(21), [UIColor grayColor]);
    [self addSubview:self.desLa];
  
     self.itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.desLa.frame)+kAdaptedHeight_2(12), SZRScreenWidth, 60)];
    [self addSubview:self.itemView];
    
    self.lastView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.itemView.frame)+kAdaptedHeight_2(18), SZRScreenWidth, kAdaptedHeight_2(8))];
    self.lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.lastView];

}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.tabView.dataArr = _dataArr;
}


- (void)setDesItemArr:(NSArray *)desItemArr{
    _desItemArr = desItemArr;
    self.itemView.desArray = desItemArr;
}

//- (void)setImgUrlStr:(NSString *)imgUrlStr{
//    _imgUrlStr = imgUrlStr;
//    self.topImg.image = [UIImage imageNamed:imgUrlStr];
//}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLa.text = titleString;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.desLa.text = _titleStr;
    CGFloat desLaHeight = [NSString getHeightWithString:titleStr width: SZRScreenWidth- 20 font:13];
    CGRect desLaRect = self.desLa.frame;
    desLaRect.size.height = desLaHeight;
    self.desLa.frame = desLaRect;
    
    CGRect itemRect = self.itemView.frame;
    itemRect.origin.y = desLaRect.origin.y + desLaHeight;
    self.itemView.frame = itemRect;

    CGRect lastViewRect = self.lastView.frame;
    lastViewRect.origin.y = itemRect.origin.y + itemRect.size.height;
    self.lastView.frame = lastViewRect;
    
    self.topHeaderViewHeight = lastViewRect.origin.y+lastViewRect.size.height;
}



@end
