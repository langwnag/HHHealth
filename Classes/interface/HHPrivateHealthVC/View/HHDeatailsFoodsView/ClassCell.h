//
//  ClassCell.h
//  YiJiaYi
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassCell;

@protocol ContentViewCellDelegate <NSObject>

-(void)dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:(ClassCell *)cell;

@end

@interface ClassCell : UITableViewCell
//cell注册
+ (void)regisCellForTableView:(UITableView *)tableView;
+ (ClassCell *)dequeueCellForTableView:(UITableView *)tableView;
//子控制器是否可以滑动  YES可以滑动
@property (nonatomic, assign) BOOL canScroll;
//外部segment点击更改selectIndex,切换页面
@property (assign, nonatomic) NSInteger selectIndex;
@property(nonatomic,weak)id<ContentViewCellDelegate> delegate;

//创建pageViewController
- (void)setPageView;

-(void)dl_refresh;

@end
