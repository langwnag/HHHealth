//
//  LYFlashSaleViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYFlashSaleViewController.h"

@interface LYFlashSaleViewController ()

@end

@implementation LYFlashSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNetWorkDataWithIsDropDown:YES];
}

- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown{
    [super loadNetWorkDataWithIsDropDown:isDropDown];
    
    [self requestNetDataWithReceiveStatus:[NSString stringWithFormat:@"%ld", self.commodityId]];
}
@end