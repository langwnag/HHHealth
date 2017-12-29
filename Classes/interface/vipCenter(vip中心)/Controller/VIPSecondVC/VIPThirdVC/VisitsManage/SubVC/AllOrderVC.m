//
//  AllOrderVC.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AllOrderVC.h"
@interface AllOrderVC ()

@end

@implementation AllOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadNetWorkDataWithIsDropDown:YES];
}

- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown{
    [super loadNetWorkDataWithIsDropDown:isDropDown];
    
    [self requestNetDataWithReceiveStatus:@" "];
}


@end
