//
//  GiftView.h
//  YiJiaYi
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftView;
@protocol GiftViewDelegate <NSObject>
@optional;
- (void)giftView:(GiftView* )giftView rechargeBtnDidClicked:(UIButton *)rechargeBtn;
- (void)giftView:(GiftView *)giftView sendBtnDidClickedWithFCount:(NSString *)fCount;
@end

@interface GiftView : UIView

@property (nonatomic,weak) id <GiftViewDelegate> delegate;

/**
 collectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 滚动
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/**
 提醒充值La
 */
@property (weak, nonatomic) IBOutlet UILabel *remindCoinLa;

/**
 充值按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *topupBtn;

/**
 发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;



@end
