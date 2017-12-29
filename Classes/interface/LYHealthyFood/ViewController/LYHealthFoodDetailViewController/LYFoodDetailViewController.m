//
//  LYFoodDetailViewController.m
//  LYScrollView
//
//  Created by Mr.Li on 2017/6/28.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYFoodDetailViewController.h"
#import "LYSegmentControl.h"
#import "LYRelevantDishViewController.h"
#import "LYBuyPointViewController.h"
#import "LYNutritionEffectViewController.h"
#import "LYPracticalWikiViewController.h"
#import "LYRelevantFoodModel.h"
#import "LYMaterialDetailModel.h"
#import "LYSegmentControl.h"
#import "LYNavigationView.h"
#import "LYPlayBannerView.h"
#import "IWMPlayerViewController.h"

@interface LYFoodDetailViewController ()<UIScrollViewDelegate, LYSegmentControlDelegate, LYPlayBannerViewDelegate>

@property (nonatomic, strong) LYPlayBannerView      * bannerView;
@property (nonatomic, strong) UIScrollView          * scrView;
@property (nonatomic, strong) UIScrollView          * horizontalScrView;

@property (nonatomic, strong) LYSegmentControl      * segControl;

@property (nonatomic, assign) CGFloat avcOffsetY;
@property (nonatomic, assign) CGFloat bvcOffsetY;
@property (nonatomic, assign) CGFloat cvcOffsetY;
@property (nonatomic, assign) CGFloat dvcOffsetY;

@property (nonatomic, assign) CGFloat avcMaxHeight;
@property (nonatomic, assign) CGFloat bvcMaxHeight;
@property (nonatomic, assign) CGFloat cvcMaxHeight;
@property (nonatomic, assign) CGFloat dvcMaxHeight;


@property (nonatomic, strong) LYRelevantDishViewController * relevantVc;
@property (nonatomic, strong) LYBuyPointViewController * buyPointVc;
@property (nonatomic, strong) LYNutritionEffectViewController * nutritionVc;
@property (nonatomic, strong) LYPracticalWikiViewController * wikiVc;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL showBannerView;
@property (nonatomic, assign) BOOL clickOtherBtn;
@property (nonatomic, strong) NSMutableArray * tmpArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) LYNavigationView * navigationView;

@property (nonatomic, strong) NSString * videoStr;
/** 标题名字 */
@property(nonatomic,copy)NSString * titleStr;

@end

static CGFloat const bannerHeight = 250.0f;
static CGFloat const segControlHeight = 40.0f;
static CGFloat const navigationHeight = 64.0f;

@implementation LYFoodDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.scrView];
    [self.scrView addSubview:self.horizontalScrView];
    [self.scrView addSubview:self.bannerView];
    [self.scrView addSubview:self.segControl];
    [self setSubViewControllers];
    self.selectedIndex = 0;
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentSize:) name:@"LYScrollViewShouldChangeContentSize" object:nil];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.leftBtn];

    [self requestOtherData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestOtherData{
    NSDictionary * dic = @{@"methodName":@"ApiFoodDetail", @"material_id":self.materialId, @"appid":@"225858ca5671aca4658eef91fe445a87", @"appkey":@"f533b9849bcf7493"};
    [VDNetRequest COOKING_RequestHandle:dic
                         viewController:self
                                success:^(id responseObject) {
                                    
                                    LYMaterialDetailModel * model = [LYMaterialDetailModel whc_ModelWithJson:responseObject];
                                    
                                    self.buyPointVc.buyPointTitle = model.data.pick;
                                    self.buyPointVc.imageUrlStr = model.data.pick_image;
                                    self.bvcMaxHeight = [NSString getHeightWithString:model.data.pick width:self.view.bounds.size.width - 30 font:14] + 222;

                                    self.nutritionVc.buyPointTitle = model.data.effect;
                                    self.nutritionVc.imageUrlStr = model.data.effect_image;
                                    self.cvcMaxHeight = [NSString getHeightWithString:model.data.effect width:self.view.bounds.size.width - 30 font:14] + 222;
                                    self.wikiVc.buyPointTitle = model.data.applied;
                                    self.wikiVc.imageUrlStr = model.data.applied_image;
                                    self.dvcMaxHeight = [NSString getHeightWithString:model.data.applied width:self.view.bounds.size.width - 30 font:14] + 222;

                                    self.videoStr = model.data.video;
                                    self.titleStr = model.data.material_name;
                                    
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:nil];
}

- (void)changeContentSize:(NSNotification *)notification{
    
    self.avcMaxHeight = [notification.object floatValue];
    
    CGSize size = self.scrView.contentSize;
    size.height = bannerHeight + [notification.object floatValue] + segControlHeight;
    self.scrView.contentSize = size;
    
    CGRect rect = self.relevantVc.view.frame;
    rect.size.height = [notification.object floatValue];
    self.relevantVc.view.frame = rect;
    
    CGRect rect1 = self.horizontalScrView.frame;
    rect1.size.height = [notification.object floatValue];
    self.horizontalScrView.frame = rect1;
    
    CGSize size1 = self.horizontalScrView.contentSize;
    size1.height = [notification.object floatValue];
    self.horizontalScrView.contentSize = size1;
}

- (void)changeFrameWithHeight:(CGFloat)height{
    
    CGSize size = self.scrView.contentSize;
    size.height = bannerHeight + height + segControlHeight;
    self.scrView.contentSize = size;
    
    CGRect rect = self.relevantVc.view.frame;
    rect.size.height = height;
    self.relevantVc.view.frame = rect;
    
    CGRect rect1 = self.horizontalScrView.frame;
    rect1.size.height = height;
    self.horizontalScrView.frame = rect1;
    
    CGSize size1 = self.horizontalScrView.contentSize;
    size1.height = height;
    self.horizontalScrView.contentSize = size1;

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)setSubViewControllers{
    
    self.relevantVc = [[LYRelevantDishViewController alloc] init];
    self.relevantVc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.relevantVc.materialId = self.materialId;
    [self.horizontalScrView addSubview:self.relevantVc.view];
    [self addChildViewController:self.relevantVc];
    
    self.buyPointVc = [[LYBuyPointViewController alloc] init];
    self.buyPointVc.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:self.buyPointVc.view];
    [self addChildViewController:self.buyPointVc];
    
    self.nutritionVc = [[LYNutritionEffectViewController alloc] init];
    self.nutritionVc.view.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:self.nutritionVc.view];
    [self addChildViewController:self.nutritionVc];
    
    self.wikiVc = [[LYPracticalWikiViewController alloc] init];
    self.wikiVc.view.frame = CGRectMake(self.view.frame.size.width * 3, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:self.wikiVc.view];
    [self addChildViewController:self.wikiVc];
}

- (LYPlayBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[LYPlayBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, bannerHeight)];
        _bannerView.delegate = self;
        [_bannerView.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:nil];
    }
    return _bannerView;
}

- (UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrView.delegate = self;
        _scrView.tag = 1001;
        _scrView.bounces = NO;
        _scrView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return _scrView;
}

- (UIScrollView *)horizontalScrView{
    if (!_horizontalScrView) {
        _horizontalScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segControl.frame), self.view.bounds.size.width, 50 * 50)];
        _horizontalScrView.delegate = self;
        _horizontalScrView.bounces = NO;
        _horizontalScrView.tag = 1002;
        _horizontalScrView.pagingEnabled = YES;
        _horizontalScrView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 50 * 50);
    }
    return _horizontalScrView;
}


- (LYSegmentControl *)segControl{
    if (!_segControl) {
        NSArray * titleArr = @[@"相关菜例", @"购买要诀", @"营养功效", @"实用百科"];
        _segControl = [[LYSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.bounds.size.width, segControlHeight) titles:titleArr];
        _segControl.delegate = self;
    }
    return _segControl;
}

- (NSMutableArray *)tmpArr{
    if (!_tmpArr) {
        _tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tmpArr;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(15, 27, 30, 30);
        [_leftBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(lyLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (void)lyLeftBtnClicked:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (LYNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[LYNavigationView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navigationHeight)];
        _navigationView.title = self.navTitle;
        _navigationView.alpha = 0.0f;
    }
    return _navigationView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置segmentControl位置
    if (scrollView == self.scrView) {
        if (scrollView.contentOffset.y > bannerHeight - navigationHeight) {
            CGRect rect = self.segControl.frame;
            rect.origin.y = scrollView.contentOffset.y + navigationHeight;
            self.segControl.frame = rect;
        }else{
            CGRect rect = self.segControl.frame;
            rect.origin.y = bannerHeight;
            self.segControl.frame = rect;
        }
        
        //设置导航栏透明度
        if (scrollView.contentOffset.y > bannerHeight - navigationHeight * 2 && scrollView.contentOffset.y < bannerHeight - navigationHeight) {
            self.navigationView.alpha = (scrollView.contentOffset.y - bannerHeight + navigationHeight * 2 ) / navigationHeight;
        }else if (scrollView.contentOffset.y < bannerHeight - navigationHeight * 2){
            self.navigationView.alpha = 0.0f;
        }else{
            self.navigationView.alpha = 1.0f;
        }
        
        if (self.selectedIndex == 0) {
            self.avcOffsetY = scrollView.contentOffset.y;
        }else if (self.selectedIndex == 1){
            self.bvcOffsetY = scrollView.contentOffset.y;
        }else if (self.selectedIndex == 2){
            self.cvcOffsetY = scrollView.contentOffset.y;
        }else{
            self.dvcOffsetY = scrollView.contentOffset.y;
        }
        
        if (scrollView.contentOffset.y == (scrollView.contentSize.height - [UIScreen mainScreen].bounds.size.height)) {
            self.page += 1;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.horizontalScrView) {
        self.selectedIndex = self.horizontalScrView.contentOffset.x / self.view.bounds.size.width;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.segControl.selectedIndex = selectedIndex;
 
    CGPoint point = self.scrView.contentOffset;
    if (selectedIndex == 0) {
        point.y = self.avcOffsetY;
        [self changeFrameWithHeight:self.avcMaxHeight];
    }else if (selectedIndex == 1){
        point.y = self.bvcOffsetY;
        [self changeFrameWithHeight:self.bvcMaxHeight];
    }else if (selectedIndex == 2){
        point.y = self.cvcOffsetY;
        [self changeFrameWithHeight:self.cvcMaxHeight];
    }else if (selectedIndex == 3){
        point.y = self.dvcOffsetY;
        [self changeFrameWithHeight:self.dvcMaxHeight];
    }
    [UIView animateWithDuration:1 animations:^{
        self.scrView.contentOffset = point;
    }];
}

- (void)setPage:(NSInteger)page{
    _page = page;
    if (page > 1) {
        self.relevantVc.page = page;
    }
}
#pragma mark - LYSegmentControlDelegate
- (void)lySegmentControlSelectAtIndex:(NSInteger)index{
    self.selectedIndex = index;
    
    CGPoint point = self.horizontalScrView.contentOffset;
    point.x = self.view.bounds.size.width * index;
    self.horizontalScrView.contentOffset = point;
    
    
//    if (index != 0 && !self.clickOtherBtn) {
//        [self requestOtherData];
//        self.clickOtherBtn = YES;
//    }
}

#pragma mark - LYPlayBannerViewDelegate
- (void)clickPlayBannerView{
    if (self.videoStr.length > 0) {
        [self setupCLplayer:[NSURL URLWithString:self.videoStr] titleStr:self.titleStr];
    }
}

#pragma mark - play video
- (void)setupCLplayer:(NSURL *)url titleStr:(NSString* )titleStr{
    

    IWMPlayerViewController *movie = [[IWMPlayerViewController alloc] init];
    movie.hidesBottomBarWhenPushed = YES;
    movie.videoURL = url;
    movie.videoTitle = titleStr;
    [self.navigationController pushViewController:movie animated:YES];
}

@end
