//
//  LYFoodDetailViewController.m
//  LYScrollView
//
//  Created by Mr.Li on 2017/6/28.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYFoodDetailViewController.h"
#import "AAViewController.h"
#import "BBViewController.h"
#import "CCViewController.h"
#import "DDViewController.h"
//#import "XHSegmentControl.h"

#import "LYSegmentControl.h"

@interface LYFoodDetailViewController ()<UIScrollViewDelegate, LYSegmentControlDelegate>

@property (nonatomic, strong) UIImageView           * bannerView;
@property (nonatomic, strong) UIScrollView          * scrView;
@property (nonatomic, strong) UIScrollView          * horizontalScrView;
//@property (nonatomic, strong) UISegmentedControl    * segmentControl;
@property (nonatomic, strong) LYSegmentControl * segControl;

@property (nonatomic, strong) AAViewController      * avc;

@property (nonatomic, assign) CGFloat avcOffsetY;
@property (nonatomic, assign) CGFloat bvcOffsetY;
@property (nonatomic, assign) CGFloat cvcOffsetY;
@property (nonatomic, assign) CGFloat dvcOffsetY;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL showBannerView;

@end

@implementation LYFoodDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.alpha = 0.f;
    self.selectedIndex = 0;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.scrView];
    [self.scrView addSubview:self.horizontalScrView];
    [self.scrView addSubview:self.bannerView];
    [self.scrView addSubview:self.segControl];
    
    self.avc = [[AAViewController alloc] init];
    self.avc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50 * 50);
    self.avc.view.backgroundColor = [UIColor blueColor];
    [self.horizontalScrView addSubview:self.avc.view];
    self.avc.tableView.scrollEnabled = NO;
    [self addChildViewController:self.avc];
    
    BBViewController * bvc = [[BBViewController alloc] init];
    bvc.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:bvc.view];
    [self addChildViewController:bvc];
    
    CCViewController * cvc = [[CCViewController alloc] init];
    cvc.view.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:cvc.view];
    [self addChildViewController:cvc];
    
    DDViewController * dvc = [[DDViewController alloc] init];
    dvc.view.frame = CGRectMake(self.view.frame.size.width * 3, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.horizontalScrView addSubview:dvc.view];
    [self addChildViewController:dvc];
}

- (UIImageView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _bannerView.image =[UIImage imageNamed:@"222"];
    }
    return _bannerView;
}

- (UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrView.delegate = self;
        _scrView.tag = 1001;
        _scrView.bounces = NO;
        _scrView.backgroundColor = [UIColor cyanColor];
//        _scrView.showsVerticalScrollIndicator = NO;
        _scrView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 10000);
    }
    return _scrView;
}

- (UIScrollView *)horizontalScrView{
    if (!_horizontalScrView) {
        _horizontalScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segControl.frame), self.view.bounds.size.width, 50 * 50)];
        _horizontalScrView.delegate = self;
        _horizontalScrView.bounces = NO;
        _horizontalScrView.tag = 1002;
        _horizontalScrView.backgroundColor = [UIColor redColor];
        _horizontalScrView.pagingEnabled = YES;
//        _horizontalScrView.showsHorizontalScrollIndicator = NO;
        _horizontalScrView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 50 * 50);
    }
    return _horizontalScrView;
}


- (LYSegmentControl *)segControl{
    if (!_segControl) {
        NSArray * titleArr = @[@"1", @"2", @"3", @"4"];
        _segControl = [[LYSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.bounds.size.width, 40) titles:titleArr];
        _segControl.delegate = self;
    }
    return _segControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置segmentControl位置
    if (scrollView == self.scrView) {
        if (scrollView.contentOffset.y > 300 - 64) {
            CGRect rect = self.segControl.frame;
            rect.origin.y = scrollView.contentOffset.y + 64;
            NSLog(@"%lf", scrollView.contentOffset.y);
            self.segControl.frame = rect;
        }else{
            CGRect rect = self.segControl.frame;
            rect.origin.y = 300;
            NSLog(@"%lf", scrollView.contentOffset.y);
            self.segControl.frame = rect;
        }
        
        //设置导航栏透明度
        if (scrollView.contentOffset.y > 300 - 64 * 2 && scrollView.contentOffset.y < 300 - 64) {
            NSLog(@"%lf", scrollView.contentOffset.y);
            self.navigationController.navigationBar.alpha = (scrollView.contentOffset.y - 300 + 64 * 2 )/ 64.0f;
        }else if (scrollView.contentOffset.y < 300 - 64 * 2){
            self.navigationController.navigationBar.alpha = 0.0f;
        }else{
            self.navigationController.navigationBar.alpha = 1.0f;
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
    }
    
//    if (scrollView == self.horizontalScrView) {
//        if (self.horizontalScrView.contentOffset.x == 0) {
//            self.avcOffsetY = self.scrView.contentOffset.y;
//        }
//    }
//    if (self.horizontalScrView.contentOffset.x == 0 && ) {
//        self.avcOffsetY =
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");

//    if (self.horizontalScrView == scrollView) {
//        
//        if (self.scrView.contentOffset.y > 300 - 64) {
//            
//            if (self.horizontalScrView.contentOffset.x == 0) {
//                self.avcOffsetY = self.scrView.contentOffset.y;
//            }else if (self.horizontalScrView.contentOffset.x == self.view.bounds.size.width){
//                self.bvcOffsetY = self.scrView.contentOffset.y;
//            }
//
//        }
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    if (self.horizontalScrView == scrollView ) {
//        
//        if (self.scrView.contentOffset.y > 300 - 64) {
//            if (self.horizontalScrView.contentOffset.x == 0) {
//                CGPoint point = self.scrView.contentOffset;
//                point.y = self.avcOffsetY;
//                self.scrView.contentOffset = point;
//            }else if (self.horizontalScrView.contentOffset.x == self.view.bounds.size.width){
//                [UIView animateWithDuration:0.1 animations:^{
//                    CGPoint point = self.scrView.contentOffset;
//                    point.y = self.bvcOffsetY;
//                    self.scrView.contentOffset = point;
//                }];
//            }
//
//        }
//    }
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
    }else if (selectedIndex == 1){
        point.y = self.bvcOffsetY;
    }else if (selectedIndex == 2){
        point.y = self.cvcOffsetY;
    }else if (selectedIndex == 3){
        point.y = self.dvcOffsetY;
    }
    [UIView animateWithDuration:1 animations:^{
        self.scrView.contentOffset = point;
    }];
}
#pragma mark - LYSegmentControlDelegate
- (void)lySegmentControlSelectAtIndex:(NSInteger)index{
    self.selectedIndex = index;
    
    CGPoint point = self.horizontalScrView.contentOffset;
    point.x = self.view.bounds.size.width * index;
    self.horizontalScrView.contentOffset = point;
}

@end
