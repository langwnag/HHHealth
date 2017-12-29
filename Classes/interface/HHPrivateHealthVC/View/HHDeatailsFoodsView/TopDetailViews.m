//
//  TopDetailViews.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TopDetailViews.h"
#import "ItemView.h"
#import "LYTabCollectionView.h"
#import "TagSelectView.h"
#import "HHSwitchBtnView.h"
@interface TopDetailViews ()<TagSelectViewDelegate>
/** 标题 */
@property (nonatomic,strong) UILabel* titleLa;
/** 描述 */
@property (nonatomic,strong) UILabel* desLa;
/** lastView */
@property (nonatomic,strong) UIView* lastView;
/** desView */
@property (nonatomic,strong) UIView* desView;
/** 标签图标 */
@property (nonatomic,strong) UIImageView* iconImg;

/** 开关图标 */
@property (nonatomic,strong) UIButton* switchBtn;
/** 按钮集合 */
@property (nonatomic,strong) HHSwitchBtnView* switchBtnView;

/** itemView */
@property (nonatomic,strong) ItemView* itemView;
/** TagSelectView */
@property (nonatomic,strong) TagSelectView* tagSelect;

@end

@implementation TopDetailViews

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{

    self.topImg = [UIImageView new];
    self.topImg.userInteractionEnabled = YES;
    [self addSubview:self.topImg];

    self.switchBtn = [UIButton new];
    [self.switchBtn setImage:IMG(@"swithBtn") forState:UIControlStateNormal];
    [self.switchBtn addTarget:self action:@selector(switchClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topImg addSubview:self.switchBtn];
    
    self.switchBtnView = [[HHSwitchBtnView alloc] initWithFrame:CGRectMake(0, 200, SZRScreenWidth, 30)];
    __weak TopDetailViews * weakSelf = self;
    self.switchBtnView.viewTapBlock = ^(NSInteger tag){
        SZRLog(@"----tag---- %ld",tag);
        !weakSelf.viewTagBlock ? : weakSelf.viewTagBlock(tag);
    };
    [self.topImg addSubview:self.switchBtnView];
    
    self.titleLa = [UILabel new];
    kLabelThinLightColor(self.titleLa, kAdaptedWidth_2(30), [UIColor blackColor]);
    [self addSubview:self.titleLa];

    self.iconImg = [UIImageView new];
    self.iconImg.image = IMG(@"thelabel");
    [self addSubview:self.iconImg];
    
    // 标签
    self.tagSelect = [[TagSelectView alloc] init];
    // 屏幕宽度减去左边控件的距离，默认传0
    self.tagSelect.viewWidth = kAdaptedWidth_2(20) + 15 +3;
    //(注意****) 这个一定要执行，这个方法添加数组关联布局
//    [self.tagSelect setUpTitleArray:[NSMutableArray arrayWithArray:@[@"dsfdsfsfda",@"sdfffdsfsd",@"dfafsdfdsaf"]]];
    self.tagSelect.delegate = self;
    [self addSubview:self.tagSelect];
    
    // 描述
    self.desLa = [UILabel new];
    kLabelThinLightColor(self.desLa, kAdaptedWidth_2(21), [UIColor grayColor]);

    [self addSubview:self.desLa];

    // itemView
    self.itemView = [ItemView new];
    [self addSubview:self.itemView];
    
    // 分割线
    UIView* lastView = [UIView new];
    lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lastView];
    
    self.topImg.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .widthRatioToView(self,1)
    .heightIs(kAdaptedHeight_2(400));
    
    self.switchBtn.sd_layout
    .centerXEqualToView(self.topImg)
    .centerYEqualToView(self.topImg)
    .widthIs(35)
    .heightEqualToWidth();
    
    self.switchBtnView.sd_layout
    .leftEqualToView(self.topImg)
    .bottomSpaceToView(self.topImg,10)
    .widthRatioToView(self.topImg,1)
    .heightIs(30);
    
    self.titleLa.sd_layout
    .topSpaceToView(self.topImg,kAdaptedHeight_2(16))
    .leftSpaceToView(self,kAdaptedWidth_2(20))
    .widthIs(200)
    .heightIs(kAdaptedHeight_2(14));

    self.iconImg.sd_layout
    .topSpaceToView(self.topImg,30)
    .leftSpaceToView(self,kAdaptedWidth_2(20))
    .widthIs(15)
    .heightIs(15);

    self.tagSelect.sd_layout
    .leftSpaceToView(self.iconImg,3)
    .topSpaceToView(self.titleLa,kAdaptedHeight_2(16))
    .rightSpaceToView(self,kAdaptedWidth_2(20));
    
    
    self.desLa.sd_layout
    .topSpaceToView(self.tagSelect,kAdaptedHeight_2(12))
    .leftSpaceToView(self,kAdaptedWidth_2(20))
    .rightSpaceToView(self,kAdaptedWidth_2(20))
    .autoHeightRatio(0);

    self.itemView.sd_layout
    .topSpaceToView(self.desLa,kAdaptedHeight_2(12))
    .rightSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .heightIs(60);
    
    lastView.sd_layout
    .topSpaceToView(self.itemView,kAdaptedHeight_2(18))
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(kAdaptedHeight_2(8));
    [self setupAutoHeightWithBottomView:lastView bottomMargin:2];
    // 更新布局
    [self layoutSubviews];
    [self layoutIfNeeded];
}



- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLa.text = titleString;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tagSelect setUpTitleArray:[NSMutableArray arrayWithArray:dataArr]];
}

- (void)setDescrptionTitleStr:(NSString *)descrptionTitleStr{
    _descrptionTitleStr = descrptionTitleStr;
    self.desLa.text = descrptionTitleStr;
}

- (void)setDesItemArr:(NSArray *)desItemArr{
    _desItemArr = desItemArr;
    self.itemView.desArray = desItemArr;
}

// 代理回调是个字符串
- (void)TagdidSelectTitle:(NSString *)title SelectIndex:(NSInteger)index
{
    !self.selectItemBlock ? : self.selectItemBlock(title);
    SZRLog(@"选择对象==%@----下标==%ld",title,index);
}

- (void)switchClickBtn:(UIButton* )switchBtn{
    !self.clickBtnBlock ? : self.clickBtnBlock();
//    SZRLog(@"-----switchBtn-----");
}

// 张金山
- (CGFloat)loadDataWithModel:(MenuDetailsModel *)model {
    
//    CGFloat labelHeight = [model.text calat]
    
    return 200;
}

@end
