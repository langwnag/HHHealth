//
//  ClassDetailVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ClassDetailVC.h"
#import "TopDetailViews.h"
#import "PersonalCenterTableView.h"
#import "ContentViewCell.h"
#import "HFStretchableTableHeaderView.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import <YUSegment.h>
#import "TopHeaderView.h"
#import "MenuDetailsModel.h"
#import "IWMPlayerViewController.h"
#import "LYNavigationView.h"
@interface ClassDetailVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic,strong) PersonalCenterTableView* tableView;
/** //下拉头部放大控件 */
@property (nonatomic,strong) HFStretchableTableHeaderView* stretchableTableHeaderView;
/** 分段选择器 */
@property (nonatomic,strong) YUSegment* segment;
//YES代表能滑动
@property (nonatomic, assign) BOOL canScroll;
//pageViewController
@property (strong, nonatomic) ContentViewCell *contentCell;
//偏移量
@property(nonatomic,assign)NSInteger lastContentOffY;
//是否在刷新
@property(nonatomic,assign)BOOL isRefreshing;

/** topDetailViews */
@property (nonatomic,strong) TopDetailViews* topDetailView;
/** TopHeaderView */
@property (nonatomic,strong) TopHeaderView* topHeaderView;
/** model */
@property (nonatomic,strong) MenuDetailsModel* menuModel;
/** 导航背景View */
@property (nonatomic,strong) LYNavigationView* navigationView;
@property (nonatomic, strong) UIButton * leftBtn;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray* dataArray;


@end

@implementation ClassDetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavItems:@{NAVTITLE:@"玉米",NAVLEFTIMAGE:kBackBtnName}];
    [self dl_uiConfig];
    [self dl_addNotification];
    
    [self loadDatamenuDetails];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (PersonalCenterTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PersonalCenterTableView alloc] init];
        _tableView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (LYNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[LYNavigationView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        _navigationView.alpha = 0.0f;
    }
    return _navigationView;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(15, 27, 30, 30);
        [_leftBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(lyLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}



- (YUSegment *)segment{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[@"  做法  ",@"食材",@"相关常识",@"相宜相克"]];
        _segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _segment.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        _segment.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        _segment.selectedTextColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
        _segment.selectedFont = [UIFont systemFontOfSize:15];
        _segment.indicator.backgroundColor = [UIColor orangeColor];
        [_segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}


- (void)dl_uiConfig{
    self.canScroll = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;

    self.tableView.showsVerticalScrollIndicator = NO;
    [ContentViewCell regisCellForTableView:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.leftBtn];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;


    self.topDetailView = [[TopDetailViews alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    // 张金山
//    self.tableView.tableHeaderView = self.topDetailView;

    self.topDetailView.backgroundColor = [UIColor whiteColor];
//    __weak ClassDetailVC * weakSelf = self;
    self.topDetailView.selectItemBlock = ^(NSString* titleStr){
//        UIViewController* vc = [NSClassFromString(@"CategoryListVC") new];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)loadDatamenuDetails{
    NSDictionary* paramDic = @{@"methodName":@"ApiDishesDetail",
                               @"dishes_id":self.dishId,
                               @"appid":COOKING_APPID,
                               @"appkey":COOKING_APPKEY};
    [VDNetRequest COOKING_RequestHandle:paramDic
                         viewController:self
                                success:^(id responseObject) {
                                   self.menuModel = [MenuDetailsModel mj_objectWithKeyValues:responseObject[@"data"]];
                                    [self setupLoadUI];
//                                    CGFloat topDetailViewHeight = [self.topDetailView loadDataWithModel:_menuModel];
//                                    [self.topDetailView setFrame:CGRectMake(_topDetailView.frame.origin.x, _topDetailView.frame.origin.y, _topDetailView.frame.size.width, topDetailViewHeight)];
                                    self.navigationView.title = self.menuModel.dishes_title;
                                    self.contentCell.dishesId = self.menuModel.dishes_id;
                                    self.contentCell.step = self.menuModel.step;
                                    [self.contentCell setPageView];
                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:@""];

}


- (void)setupLoadUI{

    [VDNetRequest VD_OSSImageView:self.topDetailView.topImg fullURLStr:self.menuModel.image placeHolderrImage:kDefaultLoading];
    
    __weak ClassDetailVC * weakSelf = self;
    self.topDetailView.clickBtnBlock = ^(){
        [weakSelf setupCLplayer:[NSURL URLWithString:weakSelf.menuModel.material_video] titleStr:weakSelf.menuModel.dishes_name ];
    };
    self.topDetailView.viewTagBlock = ^(NSInteger tag){
        if (tag == 101) {
            [weakSelf setupCLplayer:[NSURL URLWithString:weakSelf.menuModel.material_video] titleStr:weakSelf.menuModel.dishes_name];
        }else if (tag == 102){
            [weakSelf setupCLplayer:[NSURL URLWithString:weakSelf.menuModel.process_video] titleStr:weakSelf.menuModel.dishes_name];
        }
    };
    self.topDetailView.titleString = self.menuModel.dishes_title;

    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary*dict in self.menuModel.tags_info) {
        [tempArr addObject:[dict objectForKey:@"text"]];
    }
    
    self.topDetailView.dataArr = tempArr;
    
    self.topDetailView.descrptionTitleStr = self.menuModel.material_desc;
    
    NSString* hardStr = [NSString stringWithFormat:@"难度：%@",self.menuModel.hard_level];
    NSString* timeStr = [NSString stringWithFormat:@"烹饪时间：%@",self.menuModel.cooking_time];
    NSString* tasteStr = [NSString stringWithFormat:@"口味：%@",self.menuModel.taste];
    self.topDetailView.desItemArr =  @[hardStr,timeStr,tasteStr];
    self.tableView.tableHeaderView = self.topDetailView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - play video
- (void)setupCLplayer:(NSURL *)url titleStr:(NSString* )titleStr {
    IWMPlayerViewController *movie = [[IWMPlayerViewController alloc] init];
    movie.videoURL = url;
    movie.videoTitle = titleStr;
    [self.navigationController pushViewController:movie animated:YES];
    
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
        self.contentCell = [ContentViewCell dequeueCellForTableView:tableView];
        self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentCell.delegate = self;
    }
    return self.contentCell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //计算导航栏的透明度
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-64;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.navigationView.alpha = 1.0f;

        if (_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
            self.navigationView.alpha = 1.0f;
            _canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    } else {
        self.navigationView.alpha = 0.0f;
        if (!_canScroll) {
            self.navigationView.alpha = 1.0f;
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
}


- (void)lyLeftBtnClicked:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
