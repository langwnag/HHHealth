//
//  TopHeaderView.h
//  YiJiaYi
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectItemBlock)(NSString* title);
@interface TopHeaderView : UIView
/** 数据源 */
@property (nonatomic,copy) NSArray* dataArr;
/** 描述 */
@property (nonatomic,copy) NSString* titleStr;
/** 图片 */
//@property (nonatomic,strong) NSString* imgUrlStr;
/** 图片 */
@property (nonatomic,strong) UIImageView* topImg;
/** 标题 */
@property(nonatomic,copy)NSString * titleString;
/** itemArr */
@property(nonatomic,copy) NSArray * desItemArr;

/** headerView */
@property (nonatomic,assign) CGFloat topHeaderViewHeight;
@property (nonatomic,copy) SelectItemBlock selectItemBlock;

@end
