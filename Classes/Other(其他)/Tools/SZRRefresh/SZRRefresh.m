//
//  SZRRefresh.m
//  客邦
//
//  Created by SZR on 16/6/15.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "SZRRefresh.h"
#import "NONetworkView.h"

NONetworkView * _NONetworkView;

static SZRRefresh * _SZRRefresh = nil;
@implementation SZRRefresh
{
//    NONetworkView * _NONetworkView;
}
+(instancetype)shareSZRRefresh{
    static dispatch_once_t onceToken;
  
    dispatch_once(&onceToken,^{
        if (_SZRRefresh == nil) {
            _SZRRefresh = [[self alloc]init];
        }
    });
    return _SZRRefresh;
}

-(MJRefreshHeader *)SZR_DownRefresh:(DownRefreshBlock)downRefreshBlcok viewController:(UIViewController *)viewController{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                {
                    [MBProgressHUD showTextOnly:@"网络未连接"];
                    [self SZR_DefaultNONetworkView:viewController];
                }
                break;
                    
                default:
                {
                    
                    [self SZR_RemoveONetworkView:viewController];
                    //调用下拉刷新block
                    downRefreshBlcok();
                }
                    break;
            }
        }];

    }];
    return header;
}

-(MJRefreshFooter *)SZR_UpRefresh:(UpRefreshBlock)upRefreshBlock{
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{

        AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                {
                    [MBProgressHUD showTextOnly:@"网络未连接"];
                }
                    break;
                    
                default:
                {
                    //上拉加载block
                    upRefreshBlock();
                }
                    break;
            }
        }];
        
    }];

    return footer;
}


//添加无网视图
-(void)SZR_DefaultNONetworkView:(UIViewController *)viewController{

    
    BOOL ret = [self ISVCContentsNONetworkView:viewController];
    
    if (!ret) {
        _NONetworkView = [[[NSBundle mainBundle]loadNibNamed:@"NONetworkView" owner:nil options:nil]firstObject];
        CGRect frame = viewController.view.frame;
        if (frame.origin.x > 0) {
            frame = CGRectMake(0, frame.origin.y,frame.size.width,frame.size.height);
        }
        _NONetworkView.frame = frame;
        //设置block
        _NONetworkView.refreshBtnBlock = ^(){
            
            if ([viewController respondsToSelector:@selector(loadData)]) {
                [viewController performSelector:@selector(loadData)];
            }
        };
      
        [viewController.view addSubview:_NONetworkView];
    }

}
//移除 无网络视图
-(void)SZR_RemoveONetworkView:(UIViewController *)viewController{
   
    for (UIView * view in viewController.view.subviews) {
        if ([[view class] isSubclassOfClass:[NONetworkView class]]) {
            
            [view removeFromSuperview];
        }
    }

}

-(BOOL)ISVCContentsNONetworkView:(UIViewController *)viewController{
    for (UIView * view in viewController.view.subviews) {
        if ([[view class] isSubclassOfClass:[NONetworkView class]]) {
            return YES;
        }
    }
    return NO;
}




@end
