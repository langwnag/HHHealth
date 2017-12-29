//
//  SZRCollectionView.m
//  yingke
//
//  Created by SZR on 16/3/21.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "SZRCollectionView.h"

@implementation SZRCollectionView

-(instancetype)initWithFrame:(CGRect)frame flowLayOut:(UICollectionViewFlowLayout *)flow controller:(id<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>)controller{
    if (self = [super initWithFrame:frame collectionViewLayout:flow]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = controller;
        self.delegate = controller;
        //添加到controller上
        UIViewController * VC = (UIViewController *)controller;
        [VC.view addSubview:self];
    }
    return self;
}
@end
