//
//  ClassificationScrollContentVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ClassificationScrollContentVC.h"
#import "PersonalCenterTableView.h"
#import "ClassCell.h"
#import "HFStretchableTableHeaderView.h"
#import "DLUserPageNavBar.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import <YUSegment.h>
#import "DLUserHeaderView.h"
#import "LYRelevantFoodModel.h"

@interface ClassificationScrollContentVC ()<UITableViewDelegate,UITableViewDataSource,DLUserPageNavBarDelegate,ContentViewCellDelegate>

/** tableView */
@property (nonatomic,strong) PersonalCenterTableView* tableView;
/** //下拉头部放大控件 */
@property (nonatomic,strong) HFStretchableTableHeaderView* stretchableTableHeaderView;
/** 分段选择器 */
@property (nonatomic,strong) YUSegment* segment;
//YES代表能滑动
@property (nonatomic, assign) BOOL canScroll;
//pageViewController
@property (strong, nonatomic) ClassCell *contentCell;
//导航栏的背景view
@property (strong, nonatomic) DLUserPageNavBar *userPageNavBar;
//是否应该刷新
@property(nonatomic,assign)BOOL shouldRefresh;
//偏移量
@property(nonatomic,assign)NSInteger lastContentOffY;
//是否在刷新
@property(nonatomic,assign)BOOL isRefreshing;
//头部视图
@property(nonatomic,strong)DLUserHeaderView *userHeaderView;

@end

@implementation ClassificationScrollContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dl_uiConfig];
    [self dl_addNotification];
    [self requestNetData];
}
//相关菜例
- (void)requestNetData{
    
    NSDictionary * dic = @{@"methodName":@"ApiRelatedDishes", @"material_id":@"181", @"page":@"1", @"size":@"10", @"appid":@"225858ca5671aca4658eef91fe445a87", @"appkey":@"f533b9849bcf7493"};
    [VDNetRequest COOKING_RequestHandle:dic
                         viewController:self
                                success:^(id responseObject) {
                                    
                                    LYRelevantFoodModel * model = [LYRelevantFoodModel whc_ModelWithJson:responseObject];
                                    NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:model.data.data];
                                    NSLog(@"6666666");
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:nil];
}

- (PersonalCenterTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight) style:UITableViewStylePlain];
    }
    return _tableView;
}

- (DLUserPageNavBar *)userPageNavBar{
    if (!_userPageNavBar) {
        _userPageNavBar = [DLUserPageNavBar userPageNavBar];
        _userPageNavBar.delegate = self;
        _userPageNavBar.dl_alpha = 0;
        _userPageNavBar.frame = CGRectMake(0, 0, SZRScreenWidth, 64);
    }
    return _userPageNavBar;
}

- (YUSegment *)segment{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[@"相关菜例",@"选购要诀",@"营养功效",@"实用百科"]];
        _segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _segment.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        _segment.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        _segment.selectedTextColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
        _segment.indicator.backgroundColor = [UIColor colorWithRed:0.08 green:0.77 blue:1.00 alpha:1.00];
        [_segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (void)dl_uiConfig{
    self.canScroll = YES;
    self.fd_prefersNavigationBarHidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [ClassCell regisCellForTableView:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.userPageNavBar];
    
    self.userHeaderView = [DLUserHeaderView userHeaderView];
    self.userHeaderView.frame = CGRectMake(0, 0, SZRScreenWidth, SZRScreenWidth  / 1.7);
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:self.userHeaderView];
}

-(void)dl_addNotification
{
    //通知的处理，本来也不需要这么多通知，只是写一个简单的demo，所以...根据项目实际情况进行优化吧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
}

///通知的处理
//pageViewController页面变动时的通知
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    //更改YUSegment选中目标
    self.segment.selectedIndex = [ntf.object integerValue];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tableView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        self.tableView.scrollEnabled = NO;
    }
}

//监听segment的变化
- (void)onSegmentChange {
    //改变pageView的页码
    self.contentCell.selectIndex = self.segment.selectedIndex;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //要减去导航栏 状态栏 以及 sectionheader的高度
    return self.view.frame.size.height-44-64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.contentCell) {
        self.contentCell = [ClassCell dequeueCellForTableView:tableView];
        self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentCell.delegate = self;
        [self.contentCell setPageView];
    }
    return self.contentCell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //下拉放大 必须实现
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
    
    //计算导航栏的透明度
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = SZRScreenWidth  / 1.7 - 64;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    NSLog(@"alpha--%f",alpha);
    self.userPageNavBar.dl_alpha = alpha;
    
    
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-64;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
            _canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
    
    [self configRefreshStateWithScrollView:scrollView];
}

-(void)configRefreshStateWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -64 && scrollView.contentOffset.y < self.lastContentOffY) {
        self.shouldRefresh = YES;
    }else{
        self.shouldRefresh = NO;
    }
    
    if (scrollView.contentOffset.y < 0 && !self.isRefreshing && scrollView.contentOffset.y < self.lastContentOffY && self.lastContentOffY < 0) {
        if(!self.isRefreshing){
            [self.userPageNavBar dl_willRefresh];
        }else{
            [self.userPageNavBar dl_endRefresh];
        }
    }
    
    self.lastContentOffY = scrollView.contentOffset.y;
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.shouldRefresh && !self.isRefreshing) {
        [self.userPageNavBar dl_refresh];
        [self.contentCell dl_refresh];
        self.isRefreshing  = YES;
    }else if(!self.isRefreshing){
        [self.userPageNavBar dl_endRefresh];
        self.isRefreshing = NO;
    }
}

#pragma mark - DLUserPageNavBarDelegate
-(void)userPagNavBar:(DLUserPageNavBar *)navBar didClickButton:(DLUserPageButtonType)buttonType
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:(ClassCell *)cell
{
    [self.userPageNavBar dl_endRefresh];
    self.isRefreshing = NO;
}



//下拉放大必须实现
- (void)viewDidLayoutSubviews {
    [_stretchableTableHeaderView resizeView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController* vc = [NSClassFromString(@"ClassDetailVC") new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
