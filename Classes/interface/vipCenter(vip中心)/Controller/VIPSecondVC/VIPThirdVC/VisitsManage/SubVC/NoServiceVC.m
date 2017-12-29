//
//  NoServiceVC.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoServiceVC.h"

@interface NoServiceVC ()

@end

@implementation NoServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadNetWorkDataWithIsDropDown:YES];
}

- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown{
    [super loadNetWorkDataWithIsDropDown:isDropDown];
    
    [self requestNetDataWithReceiveStatus:@"PAY_WAIT"];
}

@end
