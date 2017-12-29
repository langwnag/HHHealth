//
//  PracticeCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 做法cell
 */
@interface PracticeCell : UITableViewCell
/** 描述la */
@property(nonatomic,copy)NSString * testStr;
/** 图片 */
@property (nonatomic,strong) UIImageView* imgUrl;

@end
