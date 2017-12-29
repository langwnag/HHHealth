//
//  ContentViewCell.m
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "ContentViewCell.h"
#import "PracticeVC.h"
#import "IngredientsVC.h"
#import "RelevantKnowledgeVC.h"
#import "PhaseGramsVC.h"
#import "BaseTableViewControllers.h"

@interface ContentViewCell ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,BaseTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray<BaseTableViewControllers *> *dataArray;

@property (strong, nonatomic) UIPageViewController *pageViewCtrl;

@property (strong, nonatomic) UIScrollView *pageScrollView;

@end

//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ContentViewCell

- (void)dealloc {
    //清除监听
    [self.pageScrollView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
    
}

-(void)dl_refresh
{
    [self.dataArray[self.selectIndex] dl_refresh];
}

#pragma mark - BaseTableViewController
-(void)dl_viewControllerDidFinishRefreshing:(BaseTableViewControllers *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:)]) {
        [self.delegate dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:self];
    }
}

///pageView
- (void)customPageView {
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewCtrl = [[UIPageViewController alloc]
                         initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                         options:option];
    
    self.pageViewCtrl.dataSource = self;
    self.pageViewCtrl.delegate = self;
    
    PracticeVC *ctrl1 = [[PracticeVC alloc] init];
    ctrl1.dishesId = self.dishesId;
    ctrl1.step = self.step;
    ctrl1.delegate = self;
    IngredientsVC *ctrl2 = [[IngredientsVC alloc] init];
    ctrl2.dishesId = self.dishesId;
    ctrl2.delegate = self;
    RelevantKnowledgeVC *ctrl3 = [[RelevantKnowledgeVC alloc] init];
    ctrl3.dishesId = self.dishesId;
    ctrl3.delegate = self;
    PhaseGramsVC *ctrl4 = [[PhaseGramsVC alloc] init];
    ctrl4.dishesId = self.dishesId;
    ctrl4.delegate = self;
    
    self.dataArray = @[ctrl1,ctrl2,ctrl3,ctrl4].mutableCopy;
    
    [self.pageViewCtrl setViewControllers:@[self.dataArray[0]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:YES
                               completion:nil];
    
    
    [self.contentView addSubview:self.pageViewCtrl.view];
    
    for (UIView *view in self.pageViewCtrl.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            //监听拖动手势
            self.pageScrollView = (UIScrollView *)view;
            [self.pageScrollView addObserver:self
                               forKeyPath:@"panGestureRecognizer.state"
                                  options:NSKeyValueObservingOptionNew
                                  context:nil];
        }
    }
    
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.contentView);
    }];
}

//监听拖拽手势的回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        SZRLog(@"bottomSView 滑动了");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"changed"];
    } else if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        SZRLog(@"结束拖拽");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"ended"];
    }
}

//创建pageViewController
- (void)setPageView {
    [self customPageView];
}

//用于让pageView到边缘时不让滑动一段距离的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)regisCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[ContentViewCell class] forCellReuseIdentifier:@"cellid"];
}

+ (ContentViewCell *)dequeueCellForTableView:(UITableView *)tableView {

    return [tableView dequeueReusableCellWithIdentifier:@"cellid"];
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    //修改所有的子控制器的状态
    for (BaseTableViewControllers *ctrl in self.dataArray) {
        ctrl.canScroll = canScroll;
        if (!canScroll) {
            ctrl.tableView.contentOffset = CGPointZero;
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self.pageViewCtrl setViewControllers:@[self.dataArray[selectIndex]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:NO
                               completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

/**
 *  @brief 点击或滑动 UIPageViewController 左侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回前一个视图控制器
 */
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    
    // index 为 0 表示已经翻到最前页
    if (index == 0 ||index == NSNotFound) {
        return  nil;
    }

    // 下标自减
    index --;
    
    return self.dataArray[index];
}

/**
 *  @brief 点击或滑动 UIPageViewController 右侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回下一个视图控制器
 */
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    // index为数组最末表示已经翻至最后页
    if (index == NSNotFound ||
        index == (self.dataArray.count - 1)) {
        return nil;
    }

    // 下标自增
    index ++;
    return self.dataArray[index];
}

/**
 *  @brief 转场动画即将开始
 *
 *  @param pageViewController     翻页控制器
 *  @param pendingViewControllers 即将展示的控制器
  */
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {

}

/**
 *  @brief 该方法会在 UIPageViewController 翻页效果出发之后，尚未完成时执行
 *
 *  @param pageViewController      翻页控制器
 *  @param finished                动画完成
 *  @param previousViewControllers 前一个控制器(非当前)
 *  @param completed               转场动画执行完
 */
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    NSUInteger index = [self.dataArray indexOfObject:self.pageViewCtrl.viewControllers.firstObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterPageViewScroll" object:[NSNumber numberWithUnsignedInteger:index]];
}

@end
