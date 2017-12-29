//
//  HasCompletedVC.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HasCompletedVC.h"


@interface HasCompletedVC ()

@end

@implementation HasCompletedVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadNetWorkDataWithIsDropDown:YES];
}

- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown{
    [super loadNetWorkDataWithIsDropDown:isDropDown];
    
    [self requestNetDataWithReceiveStatus:@"PAY_COMPLETE"];
}
@end
