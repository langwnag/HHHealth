//
//  LYInsureOrderViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYInsureOrderViewController.h"
#import "LYEditAddressView.h"
//#import "LYNumSelectView.h"
//#import "LYFunctionMenuView.h"
#import "LYBuyConditionView.h"

@interface LYInsureOrderViewController ()<LYEditAddressViewDelegate>

@property (nonatomic, strong) UIScrollView      * scrollView;
@property (nonatomic, strong) LYEditAddressView * addressView;
@property (nonatomic, strong) LYBuyConditionView * conditionView;
@end

static CGFloat addressViewHeight = 105;
static CGFloat lineSpace = 20;
static CGFloat conditionViewHeight = 201;

@implementation LYInsureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    LYNumSelectView * selectView = [[LYNumSelectView alloc] initWithFrame:CGRectMake(0, 0, 100, 50) currentNum:9 maxNum:20];
//    
//    LYFunctionMenuView * fuctionMenu = [[LYFunctionMenuView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
//    fuctionMenu.title = @"嘿嘿嘿";
//    fuctionMenu.rightView = selectView;
//    fuctionMenu.clickable = YES;
//    fuctionMenu.delegate =self;
//    [self.view addSubview:fuctionMenu];
//
//    NSLog(@"%ld", selectView.currentNum);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.conditionView];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, addressViewHeight + lineSpace + conditionViewHeight);
    }
    return _scrollView;
}

- (LYEditAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[LYEditAddressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, addressViewHeight)];
        _addressView.delegate = self;
        _addressView.backgroundColor = [UIColor whiteColor];
    }
    return _addressView;
}

- (LYBuyConditionView *)conditionView{
    if (!_conditionView) {
        _conditionView = [[LYBuyConditionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + lineSpace, self.view.bounds.size.width, conditionViewHeight)];
    }
    return _conditionView;
}
//点击地址View
- (void)clickAddressView:(UILabel *)lab{
    NSLog(@"clickAddressView");
}

//- (void)tapOnFunctionMenuView{
//    NSLog(@"tapOnFunctionMenuView");
//}
@end
