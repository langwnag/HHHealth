//
//  VisitsManageVC.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "VisitsManageVC.h"
#import "orderHeader.h"
#import "AllOrderVC.h"
#import "NoServiceVC.h"
#import "HasCompletedVC.h"
@interface VisitsManageVC ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    orderHeader *_headView;
}
@end

@implementation VisitsManageVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.index) {
        [self changeScrollview:self.index];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"出诊管理"}];
    self.view.backgroundColor = [UIColor whiteColor];
    __weakSelf;
    _headView = [[orderHeader alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6PAdaptedHeight(44))];
    _headView.items = @[@"全部",@"未服务",@"已完成"];
    _headView.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:index];
    };
    [self.view addSubview:_headView];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame),SZRScreenWidth ,SZRScreenHeight-k6PAdaptedHeight(44)-k6PAdaptedHeight(64))];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];

    [self addViewControllsToScrollView];

}
#pragma mark-将3个controller添加到VisitsManage上
-(void)addViewControllsToScrollView{
    AllOrderVC* allVC = [AllOrderVC new];
    allVC.view.frame = CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView addSubview:allVC.view];
    [self addChildViewController:allVC];

    NoServiceVC* servVC = [NoServiceVC new];
    servVC.view.frame = CGRectMake(_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView addSubview:servVC.view];
    [self addChildViewController:servVC];
    
    HasCompletedVC* copVC = [HasCompletedVC new];
    copVC.view.frame = CGRectMake(_scrollView.bounds.size.width*2, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView addSubview:copVC.view];
    [self addChildViewController:copVC];
}



#pragma mark-通过点击button来改变scrollview的偏移量
-(void)adjustScrollView:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(index*_scrollView.bounds.size.width, 0);
    }];
}

#pragma mark-选中scorllview来调整headvie的选中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_headView setSelectAtIndex:index];
}

#pragma mark 测试用
-(void)changeScrollview:(NSInteger)index{
    
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(index*_scrollView.bounds.size.width, 0);
    }];
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
