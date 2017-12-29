//
//  IngredientsCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 食材cell
 */
@interface IngredientsCell : UITableViewCell
/** 图片 */
@property (nonatomic,strong) UIImageView* imgUrl;
/** 标题 */
@property(nonatomic,copy)NSString * titleStr;
@end
