//
//  SZRRefresh.h
//  客邦
//
//  Created by SZR on 16/6/15.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownRefreshBlock)();//下拉刷新block

typedef void(^UpRefreshBlock)();//上拉加载block


@interface SZRRefresh : NSObject


/**
 *  创建本类单例实例
 */
+(instancetype)shareSZRRefresh;


/**
 *  上拉加载
 *
 *  @param upRefreshBlock 上拉加载blcok
 *
 *  @return 上拉表尾
 */
-(MJRefreshFooter *)SZR_UpRefresh:(UpRefreshBlock)upRefreshBlock;


/**
 *  下拉刷新
 *
 *  @param downRefreshBlcok 下拉刷新block
 *  @param viewController   要添加无网视图的控制器
 *
 *  @return 下拉表头
 */
-(MJRefreshHeader *)SZR_DownRefresh:(DownRefreshBlock)downRefreshBlcok viewController:(UIViewController *)viewController;



/**
 *  添加无网视图
 */
-(void)SZR_DefaultNONetworkView:(UIViewController *)viewController;

/**
 *  移除网络视图
 */
-(void)SZR_RemoveONetworkView:(UIViewController *)viewController;
@end
